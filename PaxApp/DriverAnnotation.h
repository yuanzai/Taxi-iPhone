#import <MapKit/MapKit.h>
@interface DriverAnnotation : NSObject <MKAnnotation, NSURLConnectionDataDelegate> 
{
	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subTitle;
    NSString *driver_id;
    NSDictionary *driverInfo;

    
}
@property (nonatomic,strong) NSString *driver_id;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSDictionary *driverInfo;

-(void)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
