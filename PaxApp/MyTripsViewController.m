//
//  MyTripsViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTripsViewController.h"
#import "CustomNavBar.h"
#import "SelectedTripViewController.h"
#import "OtherQuery.h"
#import "HTTPQueryModel.h"
#import "ActivityProgressView.h"
#import "Toast+UIView.h"
@implementation MyTripsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:NSLocalizedString(@"My Trips", @"") subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [self showActivityView];
    HTTPQueryModel* newQuery;
    newQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getMyTrips" Data:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if ([httpResponse statusCode] == 200) {
            NSLog(@"%@ - %@ - My Trips Data Received",self.class,NSStringFromSelector(_cmd));
            NSMutableDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            futureArray = [dict objectForKey:@"future"];
            pastArray = [dict objectForKey:@"past"];
            
            [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
            [self.tableView reloadData];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            NSLog(@"Future Array - %@",futureArray);
            NSLog(@"Past Array - %@",pastArray);
            
        } else {
            [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
            [self.view makeToast:NSLocalizedString(@"Cannot connect to server", @"") duration:1.5 position:@"center"];

        }
    } failHandler:^{
        [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
        [self.view makeToast:NSLocalizedString(@"Cannot connect to server", @"") duration:1.5 position:@"center"];

    }];
    
    

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(void) reloadTable
{
    [self.tableView reloadData]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int i;
    i = 0;
    
    if (futureArray.count >0)
        i++;
    
    if (pastArray.count>0)
        i++;
    
    if (i ==0) {
        i =1;
    }
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if (futureArray.count>0){
            return futureArray.count;
        } else if (pastArray.count > 0){
            return pastArray.count;
        } else {
            return 0;
        }
        
    } else {
        
        return pastArray.count;
    }
        
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTripsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    int i;
    i = [indexPath row];
    
    if (futureArray.count>0){
        if ([indexPath section] == 1){
            myArray = pastArray;
        } else {
            myArray = futureArray;
        }
    } else if (pastArray.count > 0){
        myArray = pastArray;

    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 300, 20)];
    labelA.adjustsFontSizeToFitWidth = YES;
    labelA.textColor = [UIColor blackColor];
    if ([[myArray objectAtIndex:i]objectForKey:@"pickup_address"]!= (id)[NSNull null])
    labelA.text = [[myArray objectAtIndex:i]objectForKey:@"pickup_address"];
    
    labelA.font = [UIFont boldSystemFontOfSize:16];
    labelA.backgroundColor = [UIColor whiteColor];
    labelA.textAlignment = UITextAlignmentLeft;
    labelA.lineBreakMode = UILineBreakModeWordWrap;
    labelA.numberOfLines = 0;
    
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(12, 26, 300, 20)];
    labelB.font = [UIFont systemFontOfSize:12];
    labelB.textColor = [UIColor blackColor];
    labelB.text = NSLocalizedString(@"To", @"");
    labelB.textAlignment = UITextAlignmentLeft;
    CGSize maximumLabelSizeB = CGSizeMake(270,9999);
    CGSize expectedLabelSizeB = [labelB.text sizeWithFont:labelB.font constrainedToSize:maximumLabelSizeB 
                                           lineBreakMode:labelB.lineBreakMode];
    
    CGRect newFrameB = labelB.frame;
    newFrameB.size.width= expectedLabelSizeB.width;
    labelB.frame = newFrameB;
    
    
    UILabel *labelBB = [[UILabel alloc] initWithFrame:CGRectMake(labelB.frame.size.width + 17, 26, 280, 20)];
    labelBB.font = [UIFont boldSystemFontOfSize:16];
    labelBB.textColor = [UIColor blackColor];
    
    if ([[myArray objectAtIndex:i]objectForKey:@"dropoff_address"]!= (id)[NSNull null])
    labelBB.text = [[myArray objectAtIndex:i]objectForKey:@"dropoff_address"];
    
    labelBB.textAlignment = UITextAlignmentLeft;
    labelBB.lineBreakMode = UILineBreakModeWordWrap;
    labelBB.numberOfLines = 0;
    

    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(12, 46, 200, 20)];
    labelC.textColor = [UIColor grayColor];
    labelC.font = [UIFont systemFontOfSize:14];

    if ([[myArray objectAtIndex:i]objectForKey:@"trip_datetime"]!= (id)[NSNull null]){
        labelC.text = [[myArray objectAtIndex:i]objectForKey:@"trip_datetime"];
    }else {
        labelC.text = @"";
    }
    
    labelC.backgroundColor = [UIColor whiteColor];
    labelC.textAlignment = UITextAlignmentLeft;
    
    CGSize maximumLabelSize = CGSizeMake(270,9999);
    CGSize expectedLabelSize = [labelC.text sizeWithFont:labelC.font constrainedToSize:maximumLabelSize 
        lineBreakMode:labelC.lineBreakMode];
    
    CGRect newFrame = labelC.frame;
    newFrame.size.width= expectedLabelSize.width;
    labelC.frame = newFrame;
    
    
    
    UILabel *labelD = [[UILabel alloc] initWithFrame:CGRectMake(15 + labelC.frame.size.width, 46, 100, 20)];
    labelD.adjustsFontSizeToFitWidth = YES;
    labelD.textColor = [UIColor colorWithRed:.7
                                       green:.2
                                        blue:.2    
                                       alpha:1];
    labelD.font = [UIFont boldSystemFontOfSize:14];
    if ([[myArray objectAtIndex:i]objectForKey:@"job_status"]!= (id)[NSNull null])
    labelD.text = [[myArray objectAtIndex:i]objectForKey:@"job_status"];
    
    
    [cell addSubview:labelA];
    [cell addSubview:labelB];
    [cell addSubview:labelBB];

    [cell addSubview:labelC];
    [cell addSubview:labelD];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{        
        
    if(section == 0) {

        NSLog(@"Section 0 = %i",futureArray.count);
         NSLog(@"Section 1 = %i",pastArray.count);
        
        if (futureArray.count > 0) {

            return NSLocalizedString(@"Future Trips", @"");
        } else if (pastArray.count > 0) {
            return NSLocalizedString(@"Past Trips", @"");
        } else {
            return NSLocalizedString(@"No trips yet", @"");
        }
        
    } else {
        return NSLocalizedString(@"Past Trips", @"");
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];

    int i;

    if (futureArray.count>0){
        
        
        if ([indexPath section] == 1){
            
            myArray = pastArray;
            i = [indexPath row];
        } else {
            myArray = futureArray;
            i = [indexPath row];
        }
    } else {
        myArray = pastArray;
        i = [indexPath row];
        
    }
    
    if (!selectedDict)
        selectedDict = [[NSMutableDictionary alloc]init];
                    
    selectedDict = [myArray objectAtIndex:i];
    if(futureArray.count>0){
        if ([indexPath section] == 0){
        selectedTripType = @"future";
        }else {
        selectedTripType = @"past";
        }
    } else {
        selectedTripType = @"past";
    }
    
    NSLog(@"%@",selectedDict);
    
    [self gotoSelectedTrip];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)gotoSelectedTrip
{
    [self performSegueWithIdentifier:@"gotoSelectedTrip" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoSelectedTrip"]) {
        
        SelectedTripViewController *stVC = [segue destinationViewController];
        stVC.selectedDict = selectedDict;
        stVC.tripType = selectedTripType;
        
        //stVC.refererTag = [sender tag];
        //sender tag 11 = top chooselocation button, tag 12 = bottom choose location button
    }
}

-(void) showActivityView
{
    activityContainer = [[ActivityProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 80) text:NSLocalizedString(@"Connecting...", @"")];
    [self.view addSubview:activityContainer];
}

-(void) hideActivityView
{
    if (activityContainer)
        [activityContainer removeFromSuperview];
}

@end
