#import "DriverItem.h"

@implementation DriverItem
@synthesize coordinate, subTitle, title;
@synthesize driver_id;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}


@end
