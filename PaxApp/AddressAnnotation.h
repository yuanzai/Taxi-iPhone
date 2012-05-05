
#import <MapKit/MapKit.h>
@interface AddressAnnotation : NSObject <MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subTitle;
}
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,copy) NSString *title;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
