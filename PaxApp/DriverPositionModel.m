#import "DriverPositionQuery.h"
#import "DriverPositionModel.h"
#import "DriverAnnotation.h"
#import "PostMethodAsync.h"
#import "GlobalVariables.h"

@implementation DriverPositionModel

- (void) getAllDriverPositionsWithDriverID
{
    
    [DriverPositionQuery getDriverPositionsWithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!response || error){
            NSLog(@"no response - %i", i);
            NSLog(@"%@",[error localizedDescription]);
            i++;
            
            
            if (i==2)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showProgressActivity" object:nil];
        }else {
            i=0;
            [self performSelectorOnMainThread:@selector(updateDriverListWithData:) withObject:data waitUntilDone:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProgressActivity" object:nil];

        }
        
    }];
    
}

- (void) getDriverPositionsWithDriverID:(NSString*) driver_id
{
    [DriverPositionQuery getSpecifiedDriverPositionWithDriverID:driver_id :^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(!response || error){
            NSLog(@"no response");
            NSLog(@"%@",[error localizedDescription]);
        }else {
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
            
            //heroku hopcab test
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

-(void) updateSingleDriverListWithData:(NSData*) data
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        
    
    NSDictionary *rawDriverItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    NSLog(@"Driver coordinates - %@", rawDriverItem);
    
        //LIVE TEST
        
        float lat;
        float longi;
        if (![rawDriverItem objectForKey:@"latitude"]){
            
            //localhost test
            lat = [[rawDriverItem objectForKey:@"lat"] floatValue]/1E6;
            longi = [[rawDriverItem objectForKey:@"longi"] floatValue]/1E6;
            
        } else {
            
            //heroku hopcab test
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
    
    [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}

@end
