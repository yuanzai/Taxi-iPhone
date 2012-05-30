//
//  PrefsViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrefsViewController.h"

@implementation PrefsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    preferences = [NSUserDefaults standardUserDefaults];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    static NSString* topSectionIdentifier = @"topSectionIdentifier";
    static NSString* botSectionIdentifier = @"botSectionIdentifier"; 

    if([indexPath section] ==0) {
        UITableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topSectionIdentifier];
        if (topCell == nil) {
            topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:topSectionIdentifier];
        
            topCell.accessoryType = UITableViewCellAccessoryNone;
            topCell.backgroundColor = [UIColor whiteColor];
            topCell.selectionStyle = UITableViewCellSelectionStyleNone;

            UITextField *topCellTextfield = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            topCellTextfield.adjustsFontSizeToFitWidth = YES;
            topCellTextfield.textColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            topCellTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            if ([indexPath row] == 0) {
                if ([preferences stringForKey:@"ClientName"] != nil)
                    topCellTextfield.text = [preferences stringForKey:@"ClientName"];
                    
                topCellTextfield.placeholder = @"Your name";
                topCellTextfield.keyboardType = UIKeyboardTypeDefault;
                topCellTextfield.returnKeyType = UIReturnKeyDone;
                topCell.textLabel.text = @"Name";
                nameField = topCellTextfield;
                
            } else {
                if ([preferences stringForKey:@"ClientNumber"] != nil)
                    topCellTextfield.text = [preferences stringForKey:@"ClientNumber"];
                
                topCellTextfield.placeholder = @"Your number";
                topCellTextfield.keyboardType = UIKeyboardTypePhonePad;
                topCellTextfield.returnKeyType = UIReturnKeyDone;
                topCell.textLabel.text = @"Number";
                numField = topCellTextfield;
            }
            
            topCellTextfield.backgroundColor = [UIColor whiteColor];
            topCellTextfield.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            topCellTextfield.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
            topCellTextfield.textAlignment = UITextAlignmentRight;
            topCellTextfield.tag = 0;
            topCellTextfield.delegate = self;
            
            topCellTextfield.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [topCellTextfield setEnabled: YES];
            
            [topCell addSubview:topCellTextfield];
        }
        
        
        return topCell;
    } else {
        UITableViewCell *botCell = [tableView dequeueReusableCellWithIdentifier:botSectionIdentifier];
        if (botCell == nil) {
            botCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                             reuseIdentifier:topSectionIdentifier];
            
            botCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            botCell.backgroundColor = [UIColor whiteColor];
            //botCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            
            switch ([indexPath row]) {
                case 0:
                {
                    botCell.textLabel.text = @"Broadcasted Drivers";
                    botCell.detailTextLabel.text = @"detail";
                    
                }
                    break;
                case 1:
                {
                    botCell.textLabel.text = @"Saved Addresses";
                    botCell.detailTextLabel.text = @"detail";
                    
                }
                    break;
                    
                case 2:
                {
                    botCell.textLabel.text = @"Account";
                    botCell.detailTextLabel.text = @"detail";
                    
                }
                    break;                
                case 3:
                {
                    botCell.textLabel.text = @"Travel History";
                    
                }
                    break;                
                case 4:
                {
                    botCell.textLabel.text = @"Logout";
                    
                }
                    break;                    
                default:
                    break;
            }
            
            
            
        }
        return botCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 1){
        switch ([indexPath row]) {
            case 0:
            {
                [self performSegueWithIdentifier:@"gotoDrivers" sender:self];
                
            }
                break;
            case 1:
            {
                [self performSegueWithIdentifier:@"gotoAddress" sender:self];

                
            }
                break;
                
            case 2:
            {
                [self performSegueWithIdentifier:@"gotoAccount" sender:self];
                
            }
                break;                
            case 3:
            {
                [self performSegueWithIdentifier:@"gotoHistory" sender:self];
                
            }
                break;                
            case 4:
            {
                //[self performSegueWithIdentifier:@"gotoLogout" sender:self];
                
            }
                break;                    
            default:
                break;
        }
        
    }
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    return YES;     

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
  
    [textField resignFirstResponder];
    
    [preferences setObject:nameField.text forKey:@"ClientName"];
    [preferences setObject:numField.text forKey:@"ClientNumber"];
    
    return YES;     
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    return YES;     

    
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField isEqual:numField]) {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
    }

    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    return YES;     

}


@end
