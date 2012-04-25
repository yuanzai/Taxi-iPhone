#import <MapKit/MapKit.h>

@interface DriverItem : NSObject <MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subTitle;
    NSNumber *driver_id;
}
@property (nonatomic,strong) NSNumber *driver_id;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
