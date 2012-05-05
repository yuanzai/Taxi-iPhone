//
//  ChooseLocationViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "AddressAnnotation.h"

static NSString* apiKey = @"AIzaSyCqe57ih20Bt7X26dk1vFgatymmmxyS9VI";

@implementation ChooseLocationViewController
@synthesize dirty;
@synthesize loading;
@synthesize suggestions, references;
@synthesize mapView;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapView setDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
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
    
    
    //NSString* apiKey = @"AIzaSyCqe57ih20Bt7X26dk1vFgatymmmxyS9VI";
    
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?parameters
    /*
     input — The text string on which to search. The Place service will return candidate matches based on this string and order results based on their perceived relevance.
     sensor — Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request. This value must be either true or false.
     key — Your application's API key. This key identifies your application for purposes of quota management. Visit the APIs Console to create an API Project and obtain your key.
     
     API key = AIzaSyCqe57ih20Bt7X26dk1vFgatymmmxyS9VI 
     */
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=%@&components=country:sg", query, apiKey];
    
    urlString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //NSURLResponse *response = nil;
    //NSError *error = nil;   
    //NSData *responseData = 
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
    
    
    /*
     
     AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     NSMutableArray* sug = [[NSMutableArray alloc] init];
     
     NSArray* placemarks = [JSON objectForKey:@"Placemark"];
     
     for (NSDictionary* placemark in placemarks) {
     NSString* address = [placemark objectForKey:@"address"];
     
     NSDictionary* point = [placemark objectForKey:@"Point"];
     NSArray* coordinates = [point objectForKey:@"coordinates"];
     NSNumber* lon = [coordinates objectAtIndex:0];
     NSNumber* lat = [coordinates objectAtIndex:1];
     
     MKPointAnnotation* place = [[MKPointAnnotation alloc] init];
     place.title = address;
     CLLocationCoordinate2D c = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
     place.coordinate = c;
     [sug addObject:place];
     [place release];
     }
     
     self.suggestions = sug;
     [sug release];
     
     [self.searchDisplayController.searchResultsTableView reloadData];
     loading = NO;
     
     if (dirty) {
     dirty = NO;
     [self loadSearchSuggestions];
     }
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
     NSLog(@"failure %@", [error localizedDescription]);
     loading = NO;
     }];
     operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
     [operation start];
     */
}

#pragma mark -
#pragma mark UITableView methods

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
	
	//MKPointAnnotation* suggestion = [suggestions objectAtIndex:indexPath.row];
	cell.textLabel.text = [suggestions objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.searchDisplayController setActive:NO animated:YES];
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
        
        NSLog(@"%@", [location objectForKey:@"lat"]);
        NSLog(@"%@", [location objectForKey:@"lng"]);
        
        //float lat = [[location objectForKey:@"lat"]floatValue];        
        //float longi = [[location objectForKey:@"longi"]floatValue];        
        double lat = [[location objectForKey:@"lat"]doubleValue];
        double longi = [[location objectForKey:@"lng"]doubleValue];        
        
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(lat, longi);    
        coordinate.latitude = lat;
        coordinate.longitude = longi;
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.007;
        span.longitudeDelta=0.007;	 
        region.span=span;
        region.center=coordinate;
        
        [mapView setRegion:region animated:TRUE];
        [mapView regionThatFits:region];
        
        
        AddressAnnotation *myAA = [[AddressAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(lat,longi)];
        [mapView addAnnotation:myAA];
        
    }];
    
    
	//MKPointAnnotation* suggestion = [suggestions objectAtIndex:indexPath.row];
    // You could add "suggestion" to a map since it implements MKAnnotation
    // example: [map addAnnotation:suggestion]
    
    //label.text = suggestion.title;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [suggestions count];
}



@end