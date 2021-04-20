//
//  DayListViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "DayListViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "DayResultViewController.h"
#import "Singleton.h"

@implementation DayListViewController
@synthesize alljournals;
@synthesize dayresultVC;

#pragma initialize table data
-(void)initializeTableData{
    
    // Get the row carried forward from the last view
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    //NSLog(@"row chosen in day list view after set is  %i", newrownumber);    
    
	//Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
    
    // Get the goal chosen
	query = [[NSString alloc] initWithFormat: @"SELECT name FROM goals where row = '%i'",newrownumber];    
    sqlite3_stmt *statement;    
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            nameChosen = (char *)sqlite3_column_text(statement, 0);
            nameCheck = [[NSString alloc] initWithFormat:@"%s",nameChosen];
        }
        sqlite3_finalize(statement);
    }
    
    // Get all the distinct datestring for the goal chosen to add into the array for each row in the table.
	query2 = [[NSString alloc] initWithFormat: @"SELECT DISTINCT datestring FROM goals where name = '%@' order by date desc",nameCheck]; 
    
    //NSLog(@"query2 - %@", query2);
    
    // Declare a count variable
    int tablecount = 0;
    int rowNum = 1;
    
    sqlite3_stmt *statement2;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &statement2, nil) == SQLITE_OK){
        while(sqlite3_step(statement2) == SQLITE_ROW){
            
            dateChosen = (char *)sqlite3_column_text(statement2, 0);
            strSelectedTime = [[NSString alloc] initWithFormat:@"%s",dateChosen];
            //NSLog(@"date string from database is  %@", strSelectedTime);
            
            // Add seven dates into each new array
            if(tablecount % 7 == 0) {
                
                //NSLog(@"count table where i modulus is zero: %i",tablecount);
                rowName = [[NSString alloc] initWithFormat: @"Result: %i",rowNum];
                [tableCellNames addObject:rowName]; 
                rowNum++;
            }   
            tablecount++;
        }
        sqlite3_finalize(statement2);
    }
        
    // Load table view.
	[self.tableView reloadData];
    //NSLog(@"table data row - %@", tableCellNames);
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
	
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
    //initialize array
    tableCellNames = 0;
	tableCellNames = [[NSMutableArray alloc] init];
    
	[self initializeTableData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Daily Log Entries", @"log entries");
	
	app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    sqlite3_close(database);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableCellNames count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
	//Set up the cell
    cell.textLabel.text = [[tableCellNames objectAtIndex:indexPath.row] capitalizedString];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
    //NSLog(@"row clicked - indexPath - %i",row);
    
    //Get the value listed in the row as 'Test Result ..'
	row = row+1;
    //NSLog(@"test result int - %i",row);
    
    // Save row in the Singleton class.
    [[Singleton sharedSingleton] settestresultnumber:row];
    
    // Go to the Day Result View
    if (self.dayresultVC == nil)
    {
        DayResultViewController *aDetail = [[DayResultViewController alloc] initWithNibName: @"DayResultViewController" bundle:[NSBundle mainBundle]];
        self.dayresultVC = aDetail;
        [aDetail release];
    }	
    WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:dayresultVC animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [dayresultVC release];
    [alljournals release];
    [tableCellNames release];
    [query release];
    [query2 release];
    [rowName release];
    [nameCheck release];
    [strSelectedTime release];
    [app release];
}

@end