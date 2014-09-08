//
//  RegisterViewController.h
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import <UIKit/UIKit.h>

@class HTTPQueryModel;
@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField* emailField;
    IBOutlet UITextField* passwordField;
    IBOutlet UITextField* mobileField;
    IBOutlet UITextField* nameField;
    HTTPQueryModel *registerQuery;
    NSUserDefaults* preferences;
    IBOutlet UILabel* topLabel;
    IBOutlet UIButton* escapeButton;
    UIActivityIndicatorView *activityView;
    UIView* viewBlocker;
    
    IBOutlet UIButton* OKButton;
    IBOutlet UIButton* cancelButton;
    

}
-(IBAction)clickOKButton:(id)sender;
-(IBAction)clickCancelButton:(id)sender;
-(void)printLabel:(NSString*) label;

@end
