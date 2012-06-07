

#import <Foundation/Foundation.h>

@interface DriverPositionModel : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableDictionary *newKey;
    NSMutableDictionary *oldKey;
}
- (void) getAllDriverPositionsWithDriverID;
- (void) getDriverPositionsWithDriverID:(NSString*) driver_id;


@end
