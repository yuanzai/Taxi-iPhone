//
//  SplashViewController.m
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import "SplashViewController.h"
#import "GlobalVariables.h"
#import "ActivityProgressView.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setCenter:CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) +100)];
    [self.view addSubview:activityView];
    [activityView startAnimating];

    myLogin = [[LoginModel alloc]init];
    myLogin.delegate = self;
    [myLogin loginWithPreferences];
    
    NSMutableDictionary* bookingForm = [[NSMutableDictionary alloc]init];
    [[GlobalVariables myGlobalVariables] setGCurrentForm:bookingForm];
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:@"ios" forKey:@"platform"];

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

-(void)loginStatus:(NSString *)status withError:(NSString *)error
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if ([status isEqualToString:@"gotoMain"]){
        [self performSelectorOnMainThread:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMain" waitUntilDone:YES];
    } else if ([status isEqualToString:@"gotoLogin"]) {
        [self performSelectorOnMainThread:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoLogin" waitUntilDone:YES];
    }
}

-(void) showActivityView
{
    activityContainer = [[ActivityProgressView alloc] initWithFrame:CGRectMake(290,100, 90, 90) text:@""];
    [self.view addSubview:activityContainer];
}

-(void) hideActivityView
{
    if (activityContainer)
        [activityContainer removeFromSuperview];
}
@end
