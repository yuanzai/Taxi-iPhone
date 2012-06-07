#import "DriverPositionQuery.h"
#import "DriverPositionModel.h"
#import "DriverAnnotation.h"
#import "PostMethodAsync.h"
#import "GlobalVariables.h"

@implementation DriverPositionModel

- (void) getAllDriverPositionsWithDriverID
{
    [DriverPositionQuery getAllDriverPositionsWithcompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!response || error){
            NSLog(@"no response");
            NSLog(@"%@",[error localizedDescription]);
        }else {
            NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            newKey = [[NSMutableDictionary alloc]init];
            oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
            NSLog(@"Driver coordinates - %@", array);
            int x = 0;
            while (x<[array count])
            {
                
                NSDictionary *rawDriverItem = [array objectAtIndex:x];
                
                //LIVE TEST
                
                float lat;
                float longi;
                if (![rawDriverItem objectForKey:@"latitude"]){
                    
                    //localhost test
                    lat = [[rawDriverItem objectForKey:@"lat"] floatValue]/1E6;
                    longi = [[rawDriverItem objectForKey:@"longi"] floatValue]/1E6;
                    
                } else {
                    
                    //heroku hobcab test
                    lat = [[rawDriverItem objectForKey:@"latitude"] floatValue];
                    longi = [[rawDriverItem objectForKey:@"longitude"] floatValue];
                }
                
                
                
                NSString* driver_id = [rawDriverItem objectForKey:@"driver_id"];
                
                if ([oldKey objectForKey:driver_id] != nil){
                    DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
                    driverItem = [oldKey objectForKey:driver_id];
                    [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
                    [newKey setValue:driverItem forKey:driver_id]; 
                } else {
                    DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
                    driverItem.driverInfo = rawDriverItem;
                    driverItem.driver_id = driver_id;
                    driverItem.title = driver_id;
                    [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
                    
                    [newKey setValue:driverItem forKey:driver_id]; 
                }
                
                rawDriverItem = nil;
                x++;
            };
            
            [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
            
            array = nil;    
            NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
            
        }
        
    }];
    
}

- (void) getDriverPositionsWithDriverID:(NSString*) driver_id
{
    [DriverPositionQuery getDriverPositionsWithDriver_id:driver_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(!response || error){
            NSLog(@"no response");
            NSLog(@"%@",[error localizedDescription]);
        }else {
            NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            newKey = [[NSMutableDictionary alloc]init];
            oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
            NSLog(@"Driver coordinates - %@", array);
            int x = 0;
            while (x<[array count])
            {
                
                NSDictionary *rawDriverItem = [array objectAtIndex:x];
                
                float lat;
                float longi;
                if (![rawDriverItem objectForKey:@"latitude"]){
                    
                    //localhost test
                    lat = [[rawDriverItem objectForKey:@"lat"] floatValue]/1E6;
                    longi = [[rawDriverItem objectForKey:@"longi"] floatValue]/1E6;
                    
                } else {
                    
                    //heroku hobcab test
                    lat = [[rawDriverItem objectForKey:@"latitude"] floatValue];
                    longi = [[rawDriverItem objectForKey:@"longitude"] floatValue];
                }
                
                if ([oldKey objectForKey:driver_id] != nil){
                    DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
                    driverItem = [oldKey objectForKey:driver_id];
                    [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
                    [newKey setValue:driverItem forKey:driver_id]; 
                } else {
                    DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
                    driverItem.driverInfo = rawDriverItem;
                    driverItem.driver_id = driver_id;
                    driverItem.title = driver_id;
                    [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
                    
                    [newKey setValue:driverItem forKey:driver_id]; 
                }
                
                rawDriverItem = nil;
                x++;
            };
            
            [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
            array = nil;   
        }
    }];
    
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        
}

@end
