
#import "CancelJobAlert.h"
#import "JobQuery.h"
#import "GlobalVariables.h"
#import "JobCycleQuery.h"

@implementation CancelJobAlert
@synthesize textInput;
-(void) launchConfirmBox: (id) delegate
{
    confirmBox = [[UIAlertView alloc] init];
    [confirmBox setDelegate:self];
    [confirmBox setTitle:NSLocalizedString(@"Do you want to cancel?", @"")];
    [confirmBox addButtonWithTitle:@"OK"];
    [confirmBox setMessage:@"\n"];
    textInput = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 41.0, 245.0, 35.0)];
    
    textInput.adjustsFontSizeToFitWidth = YES;
    textInput.textColor = [UIColor blackColor];
    
    textInput.keyboardType = UIKeyboardTypeDefault;
    textInput.returnKeyType = UIReturnKeyDone;
    //textInput.textAlignment = UITextAlignmentCenter;
    textInput.backgroundColor = [UIColor whiteColor];
    textInput.borderStyle = UITextBorderStyleRoundedRect;
    textInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textInput.placeholder = NSLocalizedString(@"Feedback", @"");
    [textInput setEnabled:YES];
    
    [confirmBox addSubview:textInput];
    
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    [confirmBox setDelegate:delegate];
    [confirmBox show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
}

-(void) launchNoShowBox
{
    noshowBox = [[UIAlertView alloc] init];
    [noshowBox setDelegate:self];
    [noshowBox setTitle:NSLocalizedString(@"Do you want to report a driver no show?", @"")];
    
    [noshowBox addButtonWithTitle:NSLocalizedString(@"Yes", @"")];
    [noshowBox addButtonWithTitle:NSLocalizedString(@"No", @"")];
    
    [noshowBox show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
}


@end
