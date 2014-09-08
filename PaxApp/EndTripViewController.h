

#import <UIKit/UIKit.h>

@class ActivityProgressView;
@interface EndTripViewController : UIViewController
{
    IBOutlet UITextView* review;
    IBOutlet UIButton* star1;
    IBOutlet UIButton* star2;
    IBOutlet UIButton* star3;
    IBOutlet UIButton* star4;
    IBOutlet UIButton* star5;
    int starLevel;
    ActivityProgressView* activity;
    IBOutlet UILabel* fareText;
}

- (IBAction)touchStar:(id)sender;
-(IBAction)escapeKeyboard:(id)sender;
-(void) showProgress;
-(void) hideActivityView;
-(void) gotoMain;
-(IBAction)doneButton:(id)sender;
-(IBAction)gotoOnroute:(id)sender;

@end
