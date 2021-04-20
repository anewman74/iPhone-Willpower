//
//  DailyRemindersTableViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "DailyRemindersTableViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "DailyReminderUpdate.h"
#import "Singleton.h"

@implementation DailyRemindersTableViewController

@synthesize alljournals;
@synthesize dailyremind;

#pragma initialize table data.
-(void)initializeTableData{

    // Get quotes
    query2 = [[NSString alloc] initWithFormat: @"SELECT quote,row FROM reminders"];     
    //NSLog(@"query2 - %@", query2);
        
    sqlite3_stmt *stmt3;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stmt3, nil) == SQLITE_OK){
        while(sqlite3_step(stmt3) == SQLITE_ROW){
                
            quoteChar = (char *)sqlite3_column_text(stmt3, 0);
            quoteDB = [[NSString alloc] initWithFormat:@"%s",quoteChar];
            
            // Take out backslashes from single quotes or double quotes.
            quoteDB = [quoteDB stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
            rownum = sqlite3_column_int(stmt3, 1);
            [tableCellNames addObject:quoteDB];
        }
        sqlite3_finalize(stmt3);
    }
    
    // Load table view.
    [self.tableView reloadData];
    //NSLog(@"table cell names in row - %@", tableCellNames);
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {    
    
    //initialize arrays
    tableCellNames = 0;
	tableCellNames = [[NSMutableArray alloc] init];
	
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
    
    // Call the function
	[self initializeTableData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Daily Reminders", @"daily reminders");
	
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
    row = row+1;
	int count = (int)[tableCellNames count];
    
	for (int i=1; i<count+1; i++) {
		if(row == i)
		{
            rowString = [tableCellNames objectAtIndex:indexPath.row];
            
            // Put a backslash in front of single quotes or double quotes.
            rowString = [rowString stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
            rowString = [rowString stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
            
            // I have to get a correct row number from the database where goal is this name
            query = [[NSString alloc] initWithFormat: @"SELECT row FROM reminders where quote = '%@'",rowString];
            //NSLog(@"query: %@",query);
    
            sqlite3_stmt *stateme;
            if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stateme, nil) == SQLITE_OK){
                while(sqlite3_step(stateme) == SQLITE_ROW){
                    rownum = sqlite3_column_int(stateme, 0);
            
                    // Save into Singleton class
                    [[Singleton sharedSingleton] setnewrownumber:rownum];
                }
                sqlite3_finalize(stateme);
            }
    
            // Go to the Daily Reminders View
            if (self.dailyremind == nil)
             {
             DailyReminderUpdate *aDetail = [[DailyReminderUpdate alloc] initWithNibName: @"DailyReminderUpdate" bundle:[NSBundle mainBundle]];
             self.dailyremind = aDetail;
             [aDetail release];
             }	
             WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
             [delegate.navController pushViewController:dailyremind animated:YES];
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [dailyremind release];
    [app release];
    [alljournals release];
    [tableCellNames release];
    [rowString release];
    [query release];
    [query2 release];
    [quoteDB release];
}

@end