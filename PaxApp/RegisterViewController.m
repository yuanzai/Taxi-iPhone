//
//  RegisterViewController.m
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import "RegisterViewController.h"
#import "Toast+UIView.h"
#import "HTTPQueryModel.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    preferences = [NSUserDefaults standardUserDefaults];
    escapeButton.enabled = NO;
    emailField.delegate = self;
    passwordField.delegate = self;
    mobileField.delegate = self;
    nameField.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)clickOKButton:(id)sender
{
    if ([emailField.text isEqualToString:@""] || !(emailField.text)){
        [self.view makeToast:@"Please enter your email!" duration:1.5 position:@"center"];
    } else if ([passwordField.text isEqualToString:@""] || !(passwordField.text)){
        [self.view makeToast:@"Please enter your password!" duration:1.5 position:@"center"];
    } else if ([mobileField.text isEqualToString:@""] || !(mobileField.text)){
        [self.view makeToast:@"Please enter your mobile number!" duration:1.5 position:@"center"];
    } else if ([nameField.text isEqualToString:@""] || !(nameField.text)){
        [self.view makeToast:@"Please enter your name!" duration:1.5 position:@"center"];
    } else {
        
        
        NSMutableDictionary* registerData = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* postData = [[NSMutableDictionary alloc]init];
        
        [registerData setObject:emailField.text forKey:@"email"];
        [registerData setObject:mobileField.text forKey:@"mobile_number"];
        [registerData setObject:nameField.text forKey:@"name"];
        [registerData setObject:passwordField.text forKey:@"password"];
        [registerData setObject:passwordField.text forKey:@"password_confirmation"];
        [postData setObject:registerData forKey:@"passenger"];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setCenter:CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) +160)];
        [self.view addSubview:activityView];
        [activityView startAnimating];
        viewBlocker = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.view addSubview:viewBlocker];

        
        registerQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postRegister" Data:postData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(response && data) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
                
                if ([httpResponse statusCode] == 201) {
                    //register success
                    [preferences setObject:nameField.text forKey:@"ClientName"];
                    [preferences setObject:mobileField.text forKey:@"ClientNumber"];
                    [preferences setObject:passwordField.text forKey:@"ClientPassword"];
                    [preferences setObject:emailField.text forKey:@"ClientEmail"];
                    [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMain" waitUntilDone:YES];
                    
                    //NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    //NSLog(@"Register OK response - %@",dict);
                    
                } else if ([httpResponse statusCode] == 422) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(printLabel:) withObject:[dict objectForKey:@"errors"] waitUntilDone:YES];
                    NSLog(@"Register Error response - %@",dict);
                    
                } else {
                    [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(printLabel:) withObject:@"Cannot connect" waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(printLabel:) withObject:@"Cannot connect" waitUntilDone:YES];
            }
            
            
        } failHandler:^{
            [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(printLabel:) withObject:@"Cannot connect" waitUntilDone:YES];
        }];
        
    }

}

-(void) hideSpinner
{
    [activityView startAnimating];
    [activityView removeFromSuperview];
    
}

-(IBAction)clickCancelButton:(id)sender
{
    [self performSegueWithIdentifier:@"gotoLogin" sender:nil];
}

-(void)printLabel:(NSString*) label
{
    topLabel.text = label;
}

-(void) hideActivityView
{
    [activityView startAnimating];
    [activityView removeFromSuperview];
    [viewBlocker removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    escapeButton.enabled = YES;
}

-(IBAction)escapeKeyboard:(id)sender
{
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [mobileField resignFirstResponder];
    [nameField resignFirstResponder];
    
    escapeButton.enabled = NO;
}
@end
