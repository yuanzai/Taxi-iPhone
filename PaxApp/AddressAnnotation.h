
#import <MapKit/MapKit.h>
@interface AddressAnnotation : NSObject <MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subtitle;
}
@property (nonatomic,strong) NSString *subtitle;
@property (nonatomic,copy) NSString *title;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
