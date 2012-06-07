//
//  JobInfoUIVIew.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfoUIVIew : UIView
{
    IBOutlet UILabel* destination;
    IBOutlet UILabel* driver;
    IBOutlet UILabel* license;

}
@property (strong,nonatomic) IBOutlet UILabel* destination;
@property (strong,nonatomic) IBOutlet UILabel* driver;
@property (strong,nonatomic) IBOutlet UILabel* license;

- (void) setLabels;
- (void) updateDriver;
@end
