#import "AddressAnnotation.h"


@implementation AddressAnnotation
@synthesize coordinate, subtitle, title;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;    
    return self;
}

@end
