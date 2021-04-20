//
//  MonthListViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "MonthListViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "MonthResultViewController.h"
#import "Singleton.h"

@implementation MonthListViewController

@synthesize alljournals;
@synthesize monthresultVC;

#pragma initialize table data.
-(void)initializeTableData{
    
    // Get the row carried forward from the last view
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];   
    
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
    
    // Get the date of the first recorded entry.
	query2 = [[NSString alloc] initWithFormat: @"SELECT monthstring, yearstring FROM goals where name = '%@' order by date asc limit 1",nameCheck];     
    //NSLog(@"query2 - %@", query2);
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){  
            
            // Get the first date entered
            firstMonthChar = (char *)sqlite3_column_text(stmt, 0);
            firstYearChar = (char *)sqlite3_column_text(stmt, 1);
            firstMonthString = [[NSString alloc] initWithFormat:@"%s",firstMonthChar];
            firstYearString = [[NSString alloc] initWithFormat:@"%s",firstYearChar];
            
            firstMonthInt = [firstMonthString intValue];
            firstYearInt = [firstYearString intValue];
        }
        sqlite3_finalize(stmt);
    }
    
    
    // Get the date of the last recorded entry.
	query3 = [[NSString alloc] initWithFormat: @"SELECT monthstring, yearstring FROM goals where name = '%@' order by date desc limit 1",nameCheck];     
    //NSLog(@"query3 - %@", query3);
    
    sqlite3_stmt *statement2;
    if(sqlite3_prepare_v2(database, [query3 UTF8String],-1, &statement2, nil) == SQLITE_OK){
        while(sqlite3_step(statement2) == SQLITE_ROW){
            
            lastMonthChar = (char *)sqlite3_column_text(statement2, 0);
            lastYearChar = (char *)sqlite3_column_text(statement2, 1);
            lastMonthString = [[NSString alloc] initWithFormat:@"%s",lastMonthChar];
            lastYearString = [[NSString alloc] initWithFormat:@"%s",lastYearChar];
            
            lastMonthInt = [lastMonthString intValue];
            lastYearInt = [lastYearString intValue];
            
            // Get seven month and year value previously.
            if (lastMonthInt >= 7) {
                sevenMonthInt = lastMonthInt - 6;
                sevenYearInt = lastYearInt;
            }
            else {
                sevenMonthInt = 12 - (6 - lastMonthInt);
                sevenYearInt = lastYearInt - 1;
            }

            // Convert the seven month int into the string name
            sevenMonthString = [[Singleton sharedSingleton] getMonthString:sevenMonthInt];
            
            // Convert the last month int into the string name
            lastMonString = [[Singleton sharedSingleton] getMonthString:lastMonthInt];
            
            // Create the row name and  add it to the array
            rowName = [[NSString alloc] initWithFormat: @"%@ %i - %@ %i",sevenMonthString,sevenYearInt,lastMonString,lastYearInt];
            [tableCellNames addObject:rowName]; 
            [tableDataRow addObject:[NSString stringWithFormat: @"%i-%i",lastMonthInt,lastYearInt]];
            
            while ( (sevenYearInt > firstYearInt) || ((sevenYearInt == firstYearInt) && (sevenMonthInt > firstMonthInt)) ) {
                
                // Get the next month data.
                if (sevenMonthInt == 1) {
                    nextMonthInt = 12;
                    nextYearInt = sevenYearInt -1;
                }
                else {
                    nextMonthInt = sevenMonthInt - 1;
                    nextYearInt = sevenYearInt;
                }
                
                // Convert the next month int into the string name
                nextMonthString = [[Singleton sharedSingleton] getMonthString:nextMonthInt];
                
                // Get the following seven month data.
                if (nextMonthInt >= 7) {
                    sevenMonthInt = nextMonthInt - 6;
                    sevenYearInt = nextYearInt;
                }
                else {
                    sevenMonthInt = 12 - (6 - nextMonthInt);
                    sevenYearInt = nextYearInt - 1;
                }
                
                // Convert the seven month int into the string name.
                sevenMonthString = [[Singleton sharedSingleton] getMonthString:sevenMonthInt];

                // Create the row name and  add it to the array.
                rowName = [[NSString alloc] initWithFormat: @"%@ %i - %@ %i",sevenMonthString,sevenYearInt,nextMonthString,nextYearInt];
                [tableCellNames addObject:rowName]; 
                [tableDataRow addObject:[NSString stringWithFormat: @"%i-%i",nextMonthInt,nextYearInt]];
            }
        }
         sqlite3_finalize(statement2);
    }
    
    // Load table view.
	[self.tableView reloadData];
    //NSLog(@"table cell names in row - %@", tableCellNames);
    //NSLog(@"table data row - %@", tableDataRow);
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
	
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
    //initialize arrays
    tableDataRow = 0;
	tableDataRow = [[NSMutableArray alloc] init];
    tableCellNames = 0;
	tableCellNames = [[NSMutableArray alloc] init];
    
	[self initializeTableData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Monthly Log Entries", @"log entries");
	
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
  
    rowString = [tableDataRow objectAtIndex:indexPath.row];    
    splite = [rowString componentsSeparatedByString:@"-"];
    
    selectedMonth = [splite objectAtIndex:0];
    selMonth = [selectedMonth intValue];
    
    selectedYear = [splite objectAtIndex:1];
    selYear = [selectedYear intValue];
    
    // Save the double values in the Singleton class
    [[Singleton sharedSingleton] setselectedmonth:selMonth];    
    [[Singleton sharedSingleton] setselectedyear:selYear];
    
    // Go to the Day Result View
    if (self.monthresultVC == nil)
    {
        MonthResultViewController *aDetail = [[MonthResultViewController alloc] initWithNibName: @"MonthResultViewController" bundle:[NSBundle mainBundle]];
        self.monthresultVC = aDetail;
        [aDetail release];
    }	
    WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:monthresultVC animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)dealloc
{
    [super dealloc];
    [monthresultVC release];
    [alljournals release];
    [tableDataRow release];
    [tableCellNames release];
    [splite release];
    [rowString release];
    [query release];
    [query2 release];
    [query3 release];
    [rowName release];
    [nameCheck release];
    [firstMonthString release];
    [firstYearString release];
    [lastMonthString release];
    [lastMonString release];
    [lastYearString release];
    [sevenMonthString release];
    [sevenDateString release];
    [lastDateString release];
    [nextMonthString release];
    [selectedMonth release];
    [selectedYear release];
    [app release];
}


@end