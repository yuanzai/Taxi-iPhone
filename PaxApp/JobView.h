//
//  JobView.h
//  PaxApp
//
//  Created by Junyuan Lau on 29/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobView : UIView
{
    IBOutlet UIView* infoView;
}
@property (strong,nonatomic)IBOutlet UIView *infoView;
- (void) hideInfoView;

- (void) showInfoView;

@end
