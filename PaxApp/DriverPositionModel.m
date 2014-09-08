#import "DriverPositionQuery.h"
#import "DriverPositionModel.h"
#import "DriverAnnotation.h"
#import "PostMethodAsync.h"
#import "GlobalVariables.h"
#import "HTTPQueryModel.h"

@implementation DriverPositionModel

- (void) getAllDriverPositionsWithDriverID
{
    
    HTTPQueryModel* allDriversQuery;
    allDriversQuery = [[HTTPQueryModel alloc] initURLConnectionWithMethod:@"getAllDrivers" Data:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if ([httpResponse statusCode] == 200) {
            i=0;
            [self performSelectorOnMainThread:@selector(updateDriverListWithData:) withObject:data waitUntilDone:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProgressActivity" object:nil];
        } else if(!response || error || [httpResponse statusCode] != 200){
            NSLog(@"Get all drivers - no response - %i", i);
            i++;
            if (i==2)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showProgressActivity" object:nil];
        }
        
    } failHandler:^{
        NSLog(@"Get all drivers - no response - %i", i);
        i++;
        if (i==2)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showProgressActivity" object:nil];
    }];
}

- (void) getDriverPositionsWithDriverID:(NSString*) driver_id
{
    HTTPQueryModel* driverQuery;
    driverQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getDriver" Data:[[NSDictionary alloc]initWithObjectsAndKeys:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"id"],@"job_id", nil] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if ([httpResponse statusCode] == 200){
            NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
            [self performSelectorOnMainThread:@selector(updateSingleDriverListWithData:) withObject:data waitUntilDone:YES];
        } else {
            NSLog(@"%@ - %@ - Fail to get data",self.class,NSStringFromSelector(_cmd));
        }
    } failHandler:^{
        NSLog(@"%@ - %@ - Fail to get data",self.class,NSStringFromSelector(_cmd));
    }];

}

-(void) updateDriverListWithData:(NSData*) data
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        

    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    int x = 0;
    while (x<[array count])
    {
        NSDictionary *rawDriverItem = [array objectAtIndex:x];

        [self updateListWithArray:rawDriverItem];
        x++;
    };
    
    [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
    newKey = nil;
    array = nil;
     
}

-(void) updateSingleDriverListWithData:(NSData*) data
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        
    NSDictionary *rawDriverItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    [self updateListWithArray:rawDriverItem];    
    [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
    newKey = nil;
}

- (void) updateListWithArray:(NSDictionary*) rawDriverItem
{
    
    float lat = [[rawDriverItem objectForKey:@"latitude"] floatValue];
    float longi = [[rawDriverItem objectForKey:@"longitude"] floatValue];
    
    NSString* driver_id = [rawDriverItem objectForKey:@"driver_id"];
    DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
    
    if ([oldKey objectForKey:driver_id] != nil){
        driverItem = [oldKey objectForKey:driver_id];
    } else {
        driverItem.driverInfo = rawDriverItem;
        driverItem.driver_id = driver_id;
        driverItem.title = driver_id;
    }
    
    [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];            
    [newKey setValue:driverItem forKey:driver_id]; 
    rawDriverItem = nil;
}
@end
