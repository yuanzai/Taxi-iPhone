#import "DriverPositionQuery.h"
#import "DriverPositionModel.h"
#import "DriverAnnotation.h"
#import "PostMethodAsync.h"
#import "GlobalVariables.h"

@implementation DriverPositionModel

- (void) getAllDriverPositionsWithDriverID
{
    [DriverPositionQuery getDriverPositionsWithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);

        if(!response || error || [httpResponse statusCode] != 200){
            NSLog(@"no response - %i", i);
            NSLog(@"%@",[error localizedDescription]);
            i++;
            
            
            if (i==2)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showProgressActivity" object:nil];
        }else if ([httpResponse statusCode] == 200) {
            i=0;
            [self performSelectorOnMainThread:@selector(updateDriverListWithData:) withObject:data waitUntilDone:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProgressActivity" object:nil];
        }
    }];
}

- (void) getDriverPositionsWithDriverID:(NSString*) driver_id
{
    [DriverPositionQuery getSpecifiedDriverPositionWithDriverID:driver_id JobID:[[GlobalVariables myGlobalVariables]gJob_id] CompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);

        
        if(!response || error || [httpResponse statusCode] != 200){
            NSLog(@"no response");
            NSLog(@"%@",[error localizedDescription]);
        }else if ([httpResponse statusCode] == 200){
            NSLog(@"%@",driver_id);
            [self performSelectorOnMainThread:@selector(updateSingleDriverListWithData:) withObject:data waitUntilDone:YES];   
        }
    }];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        
}

-(void) updateDriverListWithData:(NSData*) data
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        

    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd), array);        
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
    NSDictionary *rawDriverItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd), rawDriverItem);        
    
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
