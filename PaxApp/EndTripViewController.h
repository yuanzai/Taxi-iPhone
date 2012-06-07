//
//  EndTripViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EndTripViewController : UIViewController
{
    IBOutlet UITextView* review;
    IBOutlet UIButton* star1;
    IBOutlet UIButton* star2;
    IBOutlet UIButton* star3;
    IBOutlet UIButton* star4;
    IBOutlet UIButton* star5;
}

- (IBAction)touchStar:(id)sender;
-(IBAction)escapeKeyboard:(id)sender;

@end
