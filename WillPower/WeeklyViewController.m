//
//  WeeklyViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "WeeklyViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "Singleton.h"
#import "WeekListViewController.h"

@implementation WeeklyViewController
@synthesize weeklistVC;
@synthesize tableData;

#pragma initialize table data.
-(void)initializeTableData {
    
    
    query = @"SELECT DISTINCT name FROM goals";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			[tableData addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 0)]];
		}
		sqlite3_finalize(statement);
	}
    
	[self.tableView reloadData];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
	
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
    createSQL = @"CREATE TABLE IF NOT EXISTS goals (row integer primary key,date double, datestring varchar(25), monthstring varchar(25), yearstring varchar(25), name varchar(25), scoretitle1 varchar(25), score1 integer, scoretitle2 varchar(25), score2 integer, comment varchar(25), rating integer);";
    
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
	
	tableData = 0;
	tableData = [[NSMutableArray alloc] init]; //initialize the array
    
	[self initializeTableData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Goals", @"goals");
	
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

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
	//Set up the cell
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] capitalizedString];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	row = row+1;
	count = (int)[tableData count];	
	
	for (int i=1; i<count+1; i++) {
		if(row == i)
		{
            rowChosen = [tableData objectAtIndex:indexPath.row];
            
            // I have to get a correct row number from the database where goal is this name
            query = [[NSString alloc] initWithFormat: @"SELECT row, date FROM goals where name = '%@' limit 1",rowChosen];
            
            sqlite3_stmt *stateme;
            if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stateme, nil) == SQLITE_OK){
                while(sqlite3_step(stateme) == SQLITE_ROW){
                    rownumber = sqlite3_column_int(stateme, 0);
                    
                    [[Singleton sharedSingleton] setnewrownumber:rownumber];
                    
                    double doubleDate = sqlite3_column_double(stateme, 1);
                    //NSLog(@"testing: %f",doubleDate); 
                    dateInDatabase = [NSDate dateWithTimeIntervalSince1970:doubleDate];
                    formatter = [[[NSDateFormatter alloc] init] autorelease];
                    [formatter setDateFormat:@"MMMM dd yyyy"];
                    strSelectedTime = [formatter stringFromDate:dateInDatabase];
                    
                    //NSLog(@"date from database: %@", strSelectedTime); 
                }
                sqlite3_finalize(stateme);
            } 
            
            // If the only date is December 31 1969, show alert.
            if([strSelectedTime isEqualToString:@"December 31 1969"]){
                
                //Alert view message.
                title = [[NSString alloc] initWithFormat:@"Notice"];
                message = [[NSString alloc] initWithFormat:
                           @"This goal does not have any results yet."];
                
                alert = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"Record a Result."
                                         otherButtonTitles:nil];
                [alert show]; 
            }
            else {
                //NSLog(@"date wasn't December 31 1969 so go to new view");
                
                sqlite3_close(database);
                
                // Go to the daily list view
                if (self.weeklistVC == nil)
                {
                    WeekListViewController *aDetail = [[WeekListViewController alloc] initWithNibName: @"WeekListViewController" bundle:[NSBundle mainBundle]];
                    self.weeklistVC = aDetail;
                    [aDetail release];
                }	
                WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate.navController pushViewController:weeklistVC animated:YES];
            }
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [weeklistVC release];
    [alljournals release];
    [tableData release];
    [rowChosen release];
    [createSQL release];
    [query release];
    [title release];
    [message release];
    [alert release];
    [dateInDatabase release];
    [strSelectedTime release];
    [formatter release];
    [app release];
}

@end