//
//  MyTripsViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTripsViewController.h"
#import "CustomNavBar.h"

#import "FakeMyTripsArray.h"

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
    [thisNavBar setCustomNavBarTitle:@"My Trips" subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    
    NSDictionary* dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"Jalan Wakaff", @"pickup_address",
                           @"Toa Payoh", @"destination_address",
                           @"21 March 2012 9:00 am", @"pickup_datetime",
                           @"Pending", @"job_status",
                           @"Mr Driver", @"driver_name",
                           @"SBC 1234", @"driver_license",
                           @"1234567", @"driver_number",
                           nil];
    
    myArray = [[NSArray alloc]initWithObjects:dict1, nil];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        
        return myArray.count;
        
    } else {
        
        return 1;
    }
        
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTripsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 130, 20)];
    labelA.adjustsFontSizeToFitWidth = YES;
    labelA.textColor = [UIColor blackColor];
    labelA.text = [[myArray objectAtIndex:[indexPath row]]objectForKey:@"pickup_address"];
    labelA.font = [UIFont boldSystemFontOfSize:18];
    labelA.backgroundColor = [UIColor whiteColor];
    labelA.textAlignment = UITextAlignmentLeft;
    
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(12, 26, 300, 20)];
    labelB.font = [UIFont systemFontOfSize:12];
    labelB.textColor = [UIColor blackColor];
    labelB.text = @"To";
    labelB.textAlignment = UITextAlignmentLeft;
    CGSize maximumLabelSizeB = CGSizeMake(270,9999);
    CGSize expectedLabelSizeB = [labelB.text sizeWithFont:labelB.font constrainedToSize:maximumLabelSizeB 
                                           lineBreakMode:labelB.lineBreakMode];
    
    CGRect newFrameB = labelB.frame;
    newFrameB.size.width= expectedLabelSizeB.width;
    labelB.frame = newFrameB;
    
    
    UILabel *labelBB = [[UILabel alloc] initWithFrame:CGRectMake(labelB.frame.size.width + 17, 26, 300, 20)];
    labelBB.font = [UIFont boldSystemFontOfSize:18];
    labelBB.textColor = [UIColor blackColor];
    labelBB.text = [[myArray objectAtIndex:[indexPath row]]objectForKey:@"destination_address"];
    
    labelBB.textAlignment = UITextAlignmentLeft;
    

    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(12, 46, 200, 20)];
    labelC.textColor = [UIColor grayColor];
    labelC.font = [UIFont systemFontOfSize:14];

    labelC.text = [[myArray objectAtIndex:[indexPath row]]objectForKey:@"pickup_datetime"];
    
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
    
    labelD.text = [[myArray objectAtIndex:[indexPath row]]objectForKey:@"job_status"];
    
    
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
        return @"Future Trips";
        
    } else {
        return @"Past Trips";
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
