#import "DriverAnnotation.h"


@implementation DriverAnnotation
@synthesize coordinate, subTitle, title;
@synthesize driver_id, driverInfo;


-(void)initWithCoordinate:(CLLocationCoordinate2D) c
{
    [self willChangeValueForKey:@"coordinate"];
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
    
    [self didChangeValueForKey:@"coordinate"];

}




@end
