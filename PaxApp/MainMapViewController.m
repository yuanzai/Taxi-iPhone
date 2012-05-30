//
//  ViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMapViewController.h"
#import "DownloadDriverData.h"
#import "GlobalVariables.h"
#import "UserLocationAnnotation.h"
#import "CoreLocationManager.h"
#import "GetETA.h"
#import "GetGeocodedAddress.h"
#import "CalloutBar.h"

static NSString* apiKey = @"AIzaSyCqe57ih20Bt7X26dk1vFgatymmmxyS9VI";

@implementation MainMapViewController
@synthesize mapView;

@synthesize dirty;
@synthesize loading;
@synthesize suggestions, references;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [mapView setDelegate:self];
    [[GlobalVariables myGlobalVariables] clearGlobalData];   
    
    [self registerNotification];
    downloader = [[DownloadDriverData alloc]init];
    downloader.driver_id = @"all";
    myBar = [[CalloutBar alloc]init];
    myBar.topBar = mainTopBar;
    myBar.bottomBar = mainBottomBar;
    
    [myBar hideUserBar];
    callGetETA = [[GetETA alloc]init];
    
    [self getUserLocation];
    [downloader startDriverDataDownloadTimer];
    
    self.navigationItem.hidesBackButton = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    

}

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [downloader stopDownloadDriverDataTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    newDriverList = nil;
    oldDriverList = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateMapMarkers:)
     name:@"driverListUpdated"
     object:nil ];
 
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateUserMarker:)
     name:@"userLocationUpdated"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateETA:)
     name:@"ETA"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateGeoAddress:)
     name:@"GeoAddress"
     object:nil ];
    
}

- (void)updateMapMarkers: (NSNotification *) notification
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (!newDriverList) {
        newDriverList = [[NSArray alloc]init];
    }    
    newDriverList = [[[GlobalVariables myGlobalVariables] gDriverList] allValues]; 

    if (!tempSelectedDriver)
        tempSelectedDriver = [[NSString alloc]init];

    if (!selectedDriver) 
        selectedDriver = [[NSString alloc]init];
    
    
    tempSelectedDriver = selectedDriver;
    
    if (!oldDriverList) {
        oldDriverList = [[NSArray alloc]init];
        [mapView addAnnotations:newDriverList];

    
    } else {
        //[mapView removeAnnotations:oldDriverList];
        
        NSMutableArray *tempAddList = [[NSMutableArray alloc]init];
        NSMutableArray *tempRemoveList = [[NSMutableArray alloc]init];
        tempAddList = [NSMutableArray arrayWithArray:newDriverList];
        tempRemoveList = [NSMutableArray arrayWithArray:oldDriverList];

        if (![tempAddList containsObject:oldDriverList]) {
            [tempAddList removeObjectsInArray:oldDriverList];
            [mapView addAnnotations:tempAddList];

        }

        if (![tempRemoveList containsObject:newDriverList]) {
            [tempRemoveList removeObjectsInArray:newDriverList];
            [mapView removeAnnotations:tempRemoveList];
        }
       
    }
    oldDriverList = newDriverList;
}

- (void)getUserLocation 
{	
    if (!clManager){
        clManager = [[CoreLocationManager alloc]init];
    }
    
    [clManager startLocationManager:nil];
}

-(void)updateUserMarker: (NSNotification *) notification
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (!userLocationAnnotation) {
        userLocationAnnotation = [[UserLocationAnnotation alloc]init];
    } else {
        [mapView removeAnnotation:userLocationAnnotation];
    }
    CLLocationCoordinate2D coordinate=[[GlobalVariables myGlobalVariables] gUserCoordinate];    

	span.latitudeDelta=0.01;
	span.longitudeDelta=0.01;	 
	region.span=span;
    region.center=coordinate;
    
    [mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
    
    NSLog(@"%@,%@", [NSNumber numberWithDouble:coordinate.latitude], [NSNumber numberWithDouble:coordinate.longitude]);
    
    [userLocationAnnotation setCoordinateWithGV];
    [self addAnnotationUserMarker];
}

- (void) addAnnotationUserMarker
{
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    [mapView addAnnotation:userLocationAnnotation];

}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    selectedDriver = tempSelectedDriver;
    
    if (annotation.title == @"User Location")
    {
        NSLog(@"MKAnnotationView Called - User Location");
    	MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userloc"];
        annView.image = [UIImage imageNamed:@"userdot"];
        annView.draggable = YES;
        annView.canShowCallout = NO;

         return annView;
    }else{
        NSLog(@"MKAnnotationView Called - Drivers");

        MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"driverloc"];
        annView.image = [UIImage imageNamed:@"taxi"];
        annView.canShowCallout = NO;
        
        
        if ([annotation.title isEqualToString:selectedDriver]) {
            
            selectedAnnotation = annotation;
            
        }
        	return annView;

    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{

        [self.mapView selectAnnotation:selectedAnnotation animated:NO];   
    
}

- (void)mapView:(MKMapView *)sender didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Annotation Selected - %@", view.annotation.title);
    
    if (view.annotation.title != @"User Location") {
        
        [callGetETA startETAThread:view.annotation];
        
        if (!selectedDriver)
            selectedDriver = [[NSString alloc]init ];
        
        view.image = [UIImage imageNamed:@"selected"];
        selectedDriver = view.annotation.title;      
        
        
    }else {
        NSLog(@"No ETA");
        
    }
        
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //selectedDriver = nil;
    if (view.annotation.title != @"User Location")
    view.image = [UIImage imageNamed:@"taxi"];
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
}



- (void) updateETA: (NSNotification *) notification;
{
    NSLog(@"%@ - %@ - Updated ETA - %@",self.class,NSStringFromSelector(_cmd),[callGetETA eta]);
    [myBar showDriverBarWithETA:callGetETA.eta driver_id:nil];
    
}

- (IBAction) setGDriver_id:(id)sender
{
    //BroadCast button
 [[GlobalVariables myGlobalVariables] setGDriver_id:@"0"];  
    
}

-(void) updateGeoAddress:(NSNotification*) notification
{
    //[myBar showUserBarWithGeoAddress];

    
    [self.searchDisplayController.searchBar setPlaceholder:[[GlobalVariables myGlobalVariables]gUserAddress]];

    //[mainBottomBar setText:[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]]];
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText length] > 2) {
		if (loading) {
			dirty = YES;
		} else {
			[self loadSearchSuggestions];
		}
	}
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
}


- (void) loadSearchSuggestions {
	loading = YES;
	NSString* query = self.searchDisplayController.searchBar.text;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=%@&components=country:sg", query, apiKey];
    
    urlString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        
        NSMutableArray *sug =[[NSMutableArray alloc]initWithCapacity:5 ];
        NSMutableArray *ref =[[NSMutableArray alloc]initWithCapacity:5];
        
        NSDictionary* tester = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil]; 
        NSArray* testArray = [tester objectForKey:@"predictions"];
        
        for (NSDictionary *result in testArray) {
            
            
            NSArray* terms = [result objectForKey:@"terms"];
            NSDictionary *term0 = [terms objectAtIndex:0];
            NSString* resultname = [term0 objectForKey:@"value"]; 
            
            //NSLog([result objectForKey:@"value"]);
            NSLog(@"%@",resultname);
            [sug addObject:resultname];
            [ref addObject:[result objectForKey:@"reference"]];
        }
        
        
        self.suggestions = sug;
        self.references = ref;
        
        //[self.searchDisplayController.searchResultsTableView reloadData];
        [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES]; 
        
        loading = NO;
        if (dirty) {
            dirty = NO;
            [self loadSearchSuggestions];
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"suggest";
	
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}
    cell.textLabel.text = [suggestions objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.searchDisplayController setActive:NO animated:YES];
        [self.searchDisplayController.searchBar setPlaceholder:[suggestions objectAtIndex:indexPath.row]];
    [mapView removeAnnotations:mapView.annotations];
    NSString* refID = [references objectAtIndex:indexPath.row];    
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", refID, apiKey];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSDictionary* tester = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil]; 
        NSDictionary* result = [tester objectForKey:@"result"];
        NSDictionary* geo = [result objectForKey:@"geometry"];
        NSDictionary* location = [geo objectForKey:@"location"];
     
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([[location objectForKey:@"lat"]doubleValue], [[location objectForKey:@"lng"]doubleValue]);    

        span.latitudeDelta=0.007;
        span.longitudeDelta=0.007;	 
        region.span=span;
        region.center=coordinate;
        
        NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
        [userLocationAnnotation initWithCoordinate:coordinate];
        [self performSelectorOnMainThread:@selector(addAnnotationUserMarker) withObject:nil waitUntilDone:YES];
        
        //[self performSelectorOnMainThread:@selector(updateMapMarkers:) withObject:nil waitUntilDone:YES]; 
        
        
        [mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:[[[GlobalVariables myGlobalVariables]gDriverList]allValues] waitUntilDone:YES];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [suggestions count];
}

@end
