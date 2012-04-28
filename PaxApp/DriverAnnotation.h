#import <MapKit/MapKit.h>
@interface DriverAnnotation : NSObject <MKAnnotation, NSURLConnectionDataDelegate> 
{
	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subTitle;
    NSNumber *driver_id;
    NSDictionary *driverInfo;

    
}
@property (nonatomic,strong) NSNumber *driver_id;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSDictionary *driverInfo;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
