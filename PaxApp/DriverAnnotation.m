#import "DriverAnnotation.h"


@implementation DriverAnnotation
@synthesize coordinate, subTitle, title;
@synthesize driver_id, driverInfo;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}




@end
