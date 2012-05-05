#import "AddressAnnotation.h"


@implementation AddressAnnotation
@synthesize coordinate, subTitle, title;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;    
	return self;
}

@end
