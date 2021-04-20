//
//  EveryLogViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "EveryLogViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "Singleton.h"
#import "UpdateViewController.h"

@implementation EveryLogViewController
@synthesize updateVC;
@synthesize tableData;
@synthesize tableDataRow;

#pragma initialize table data.
-(void)initializeTableData {
    
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    //NSLog(@"row chosen in every log view after set is  %i", newrownumber);
    
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
            //NSLog(@"name chosen in every log view is  %s", nameChosen);
            
            nameCheck = [[NSString alloc] initWithFormat:@"%s",nameChosen];
            //NSLog(@"name check in every log method in result view is  %@", nameCheck);
        }
        sqlite3_finalize(statement);
    }	

    //NSLog(@"name check in every log view before insert call is  %@", nameCheck);

    // Get all the dates for the goal chosen
	query2 = [[NSString alloc] initWithFormat: @"SELECT date, row FROM goals where name = '%@' order by date desc",nameCheck]; 
    
    //NSLog(@"query2 - %@", query2);
        
    sqlite3_stmt *statement2;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &statement2, nil) == SQLITE_OK){
            while(sqlite3_step(statement2) == SQLITE_ROW){
                
                double doubleDate = sqlite3_column_double(statement2, 0);
                //NSLog(@"testing: %f",doubleDate); 
                dateInDatabase = [NSDate dateWithTimeIntervalSince1970:doubleDate];
                
                formatter = [[[NSDateFormatter alloc] init] autorelease]; 
                [formatter setDateFormat:@"HH:mm, MMMM dd yyyy"]; 
                
                strSelectedTime = [formatter stringFromDate:dateInDatabase];	    
                //NSLog(@"date from database: %@", strSelectedTime); 
                
                [tableData addObject:strSelectedTime];
                [tableDataRow addObject:[NSString stringWithFormat:@"%f - %i", doubleDate, sqlite3_column_int(statement2, 1)]];
            }
        sqlite3_finalize(statement2);
    }
	[self.tableView reloadData];
    
    //NSLog(@"table data - %@", tableData);
    //NSLog(@"table data row - %@", tableDataRow);
}


#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
	
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	tableData = 0;
	tableData = [[NSMutableArray alloc] init]; //initialize the array
    tableDataRow = 0;
	tableDataRow = [[NSMutableArray alloc] init]; //initialize the array
    
	[self initializeTableData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Log Entries", @"log entries");
	
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
    //NSLog(@"row clicked - indexPath - %i",row);
	row = row+1;
	int count = (int)[tableDataRow count];	
	
	for (int i=1; i<count+1; i++) {
		if(row == i)
		{            
            rowChosen = [tableDataRow objectAtIndex:indexPath.row];
            //NSLog(@"table row string chosen - %@", rowChosen);
            
			splite = [rowChosen componentsSeparatedByString:@" - "];
			secondString = [splite objectAtIndex:1];
            rownumber = [secondString intValue];
			
			[[Singleton sharedSingleton] setnewrownumber:rownumber];
            //NSLog(@"row number for this name is  %i", rownumber);
            
            if (self.updateVC == nil)
			{
				UpdateViewController *gResultLog = [[UpdateViewController alloc] initWithNibName: @"UpdateViewController" bundle:[NSBundle mainBundle]];
				self.updateVC = gResultLog;
				[gResultLog release];
			}
            WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navController pushViewController:updateVC animated:YES];
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [updateVC release];
    [alljournals release];
    [tableData release];
    [tableDataRow release];
    [rowChosen release];
    [query release];
    [query2 release];
    [splite release];
    [secondString release];
    [nameCheck release];
    [dateInDatabase release];
    [strSelectedTime release];
    [formatter release];
    [app release];
}

@end