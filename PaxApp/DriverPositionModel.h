

#import <Foundation/Foundation.h>

@interface DriverPositionModel : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableDictionary *newKey;
    NSMutableDictionary *oldKey;
    int i;
}
- (void) getAllDriverPositionsWithDriverID;
- (void) getDriverPositionsWithDriverID:(NSString*) driver_id;
-(void) updateDriverListWithData:(NSData*) data;
-(void) updateSingleDriverListWithData:(NSData*) data;


@end
