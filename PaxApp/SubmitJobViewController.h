//
//  SubmitJobViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubmitClass;
@interface SubmitJobViewController : UIViewController
{
    IBOutlet UITextField* pickup;
    IBOutlet UITextField* destination;
    
    NSString* pickupString;
    NSString* destinationString;
    
    SubmitClass *newSubmitClass;
}
@property (nonatomic, strong) IBOutlet UITextField* pickup;
@property (nonatomic, strong) IBOutlet UITextField* destination;

@property (nonatomic,strong) NSString* pickupString;
@property (nonatomic,strong) NSString* destinationString;

- (IBAction)escapeKeyboard:(id)sender;
- (IBAction)setTextfields:(id)sender;

@end
