//
//  WeekListViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "WeekListViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "WeekResultViewController.h"
#import "Singleton.h"

@implementation WeekListViewController
@synthesize alljournals;
@synthesize weekresultVC;

#pragma initialize table data
-(void)initializeTableData{
    
    // Date formatter
    formatter = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter setDateFormat:@"MM/dd/yyyy"];   
    
    formatter2 = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter2 setDateFormat:@"EEEE, HH, mm, MMMM dd yyyy"];
    
    formatter3 = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter3 setDateFormat:@"HH mm"];
    
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
	query2 = [[NSString alloc] initWithFormat: @"SELECT date FROM goals where name = '%@' order by date asc limit 1",nameCheck];     
    //NSLog(@"query2 - %@", query2);
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){  
            
            // Get the last date entered
            firstDateEntered = sqlite3_column_double(stmt, 0);
            firstDateEnter = [NSDate dateWithTimeIntervalSince1970:firstDateEntered];
            firstDate = [formatter stringFromDate:firstDateEnter];  
        }
        sqlite3_finalize(stmt);
    }
    
    // Get the date of the last recorded entry.
	query3 = [[NSString alloc] initWithFormat: @"SELECT date FROM goals where name = '%@' order by date desc limit 1",nameCheck];     
    //NSLog(@"query3 - %@", query3);

    sqlite3_stmt *statement2;
    if(sqlite3_prepare_v2(database, [query3 UTF8String],-1, &statement2, nil) == SQLITE_OK){
        while(sqlite3_step(statement2) == SQLITE_ROW){

            // Get the last date entered
            lastDateEntered = sqlite3_column_double(statement2, 0);
            dateEnter = [NSDate dateWithTimeIntervalSince1970:lastDateEntered];
            lastDate = [formatter2 stringFromDate:dateEnter];
                
            // Get the day of this date
            splite = [lastDate componentsSeparatedByString:@","];
            dayName = [splite objectAtIndex:0];
                
            // Calculate the days between this dayName and the next Sunday.
            if ([dayName isEqualToString:@"Monday"]) {addDays = 5;}
            else if ([dayName isEqualToString:@"Tuesday"]) {addDays = 4;}
            else if ([dayName isEqualToString:@"Wednesday"]) {addDays = 3;}
            else if ([dayName isEqualToString:@"Thursday"]) {addDays = 2;}
            else if ([dayName isEqualToString:@"Friday"]) {addDays = 1;}
            else if ([dayName isEqualToString:@"Saturday"]) {addDays = 0;}
            else {addDays = 6;}
                
            // Get the hour and minutes of this last entry
            dayHour = [[splite objectAtIndex:1] intValue];
            dayMinutes = [[splite objectAtIndex:2] intValue];
            
            // Get the double value of the time remaining in the day ( 24 hours -selected time's hour and minutes).
            doubleHourMin = ((24 - (dayHour + 1)) * 60 * 60) + ((60 - dayMinutes) * 60);
            
            // The double value of one day.
            oneday = 24 * 60 * 60;
            
            
            // Get next Sunday at 0:00 hours by adding values of additional day and extra hours or selected day.
            nextSunday = lastDateEntered + (addDays * oneday) + doubleHourMin;
            nexSunday = [NSDate dateWithTimeIntervalSince1970:nextSunday];            
            nexSun = [formatter2 stringFromDate:nexSunday];
            nexSunSpecific = [formatter3 stringFromDate:nexSunday];
            
            // Take into account possible daylight saving.
            if ([nexSunSpecific isEqualToString:@"23 00"]) {
                nextSunday = nextSunday + (60 * 60);
            }
            else if ([nexSunSpecific isEqualToString:@"01 00"]) {
                nextSunday = nextSunday - (60 * 60);
            }
            nexSunday = [NSDate dateWithTimeIntervalSince1970:nextSunday];            
            nexSun = [formatter2 stringFromDate:nexSunday];
            
            
            // Calculate next Saturday to put in the row
            nextSaturday = nextSunday - oneday;
            nexSaturday = [NSDate dateWithTimeIntervalSince1970:nextSaturday];            
            nexSat = [formatter stringFromDate:nexSaturday];
            nexSatSpecific = [formatter3 stringFromDate:nexSaturday];
            
            // Take into account possible daylight saving.
            if ([nexSatSpecific isEqualToString:@"23 00"]) {
                nextSaturday = nextSaturday + (60 * 60);
            }
            else if ([nexSatSpecific isEqualToString:@"01 00"]) {
                nextSaturday = nextSaturday - (60 * 60);
            }
            nexSaturday = [NSDate dateWithTimeIntervalSince1970:nextSaturday];            
            nexSat = [formatter stringFromDate:nexSaturday];  
            nexSatSpecific = [formatter2 stringFromDate:nexSaturday];
                
            
            // Calculate Sunday seven weeks previously time at midnight to get the exact lowest double date value.
            sevenSunday = nextSunday - (49 * oneday);
            sevSunday = [NSDate dateWithTimeIntervalSince1970:sevenSunday];            
            sevSun = [formatter stringFromDate:sevSunday];
            sevSunSpecific = [formatter3 stringFromDate:sevSunday];
            
            // Take into account possible daylight saving.
            if ([sevSunSpecific isEqualToString:@"23 00"]) {
                sevenSunday = sevenSunday + (60 * 60);
            }
            else if ([sevSunSpecific isEqualToString:@"01 00"]) {
                sevenSunday = sevenSunday - (60 * 60);
            }
            sevSunday = [NSDate dateWithTimeIntervalSince1970:sevenSunday];            
            sevSun = [formatter stringFromDate:sevSunday]; 
            sevSunSpecific = [formatter2 stringFromDate:sevSunday];
            
            
            // Create the row name and  add it to the array
            rowName = [[NSString alloc] initWithFormat: @"%@ - %@",sevSun,nexSat];
            [tableCellNames addObject:rowName]; 
            [tableDataRow addObject:[NSString stringWithFormat:@"%f - %f", sevenSunday, nextSaturday]];
                
            
            // If the first date is before previous Sunday seven weeks prior, then run the loop again
            while (firstDateEntered < sevenSunday) {
                
                sevSunday = [NSDate dateWithTimeIntervalSince1970:sevenSunday];                  
                sevSun = [formatter2 stringFromDate:sevSunday];
                
                // Calculate Saturday seven weeks prior to put in the row
                sevenSaturday = sevenSunday - oneday;
                sevSaturday = [NSDate dateWithTimeIntervalSince1970:sevenSaturday];            
                sevSat = [formatter stringFromDate:sevSaturday];
                sevSatSpecific = [formatter3 stringFromDate:sevSaturday];
                
                // Take into account possible daylight saving.
                if ([sevSatSpecific isEqualToString:@"23 00"]) {
                    sevenSaturday = sevenSaturday + (60 * 60);
                }
                else if ([sevSatSpecific isEqualToString:@"01 00"]) {
                    sevenSaturday = sevenSaturday - (60 * 60);
                }
                sevSaturday = [NSDate dateWithTimeIntervalSince1970:sevenSaturday];            
                sevSat = [formatter stringFromDate:sevSaturday];
                sevSatSpecific = [formatter2 stringFromDate:sevSaturday];
                
                
                // Calculate Sunday seven weeks previously time at midnight to get the exact lowest double date value.
                sevenPrevSunday = sevenSunday - (49 * oneday);
                sevPrevSunday = [NSDate dateWithTimeIntervalSince1970:sevenPrevSunday];            
                sevPrevSun = [formatter stringFromDate:sevPrevSunday];
                sevPrevSunSpecific = [formatter3 stringFromDate:sevPrevSunday];
                
                // Take into account possible daylight saving.
                if ([sevPrevSunSpecific isEqualToString:@"23 00"]) {
                    sevenPrevSunday = sevenPrevSunday + (60 * 60);
                }
                else if ([sevPrevSunSpecific isEqualToString:@"01 00"]) {
                    sevenPrevSunday = sevenPrevSunday - (60 * 60);
                }
                sevPrevSunday = [NSDate dateWithTimeIntervalSince1970:sevenPrevSunday];            
                sevPrevSun = [formatter stringFromDate:sevPrevSunday]; 
                sevPrevSunSpecific = [formatter2 stringFromDate:sevPrevSunday];
                
                
                // Create the row name and  add it to the array
                rowName = [[NSString alloc] initWithFormat: @"%@ - %@",sevPrevSun,sevSat];
                [tableCellNames addObject:rowName];
                [tableDataRow addObject:[NSString stringWithFormat:@"%f - %f", sevenPrevSunday, sevenSaturday]];
                
                sevenSunday = sevenPrevSunday;
            }
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
	
	self.title =  NSLocalizedString(@"Weekly Log Entries", @"log entries");
	
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
    
    formatter2 = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter2 setDateFormat:@"EEEE, HH, mm, MMMM dd yyyy"];
    
    rowString = [tableDataRow objectAtIndex:indexPath.row];
    //NSLog(@"table row string chosen - %@", rowString);
    
    splite = [rowString componentsSeparatedByString:@" - "];
    
    sevSun = [splite objectAtIndex:0];
    sevenSunday = [sevSun doubleValue];
    testDate = [NSDate dateWithTimeIntervalSince1970:sevenSunday];            
    testString = [formatter2 stringFromDate:testDate];  
    //NSLog(@"Sunday seven weeks previously: %@", testString);
    
    lastSatString = [splite objectAtIndex:1];
    lastSatDouble = [lastSatString doubleValue];
    testDate = [NSDate dateWithTimeIntervalSince1970:lastSatDouble];            
    testString = [formatter2 stringFromDate:testDate];  
    //NSLog(@"Last Saturday: %@", testString);  
    
    // Save the double values in the Singleton class
    [[Singleton sharedSingleton] setdoublesat:lastSatDouble];    
    [[Singleton sharedSingleton] setdoublesun:sevenSunday];
    
    // Go to the Day Result View
    if (self.weekresultVC == nil)
    {
        WeekResultViewController *aDetail = [[WeekResultViewController alloc] initWithNibName: @"WeekResultViewController" bundle:[NSBundle mainBundle]];
        self.weekresultVC = aDetail;
        [aDetail release];
    }	
    WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:weekresultVC animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [weekresultVC release];
    [alljournals release];
    [tableDataRow release];
    [tableCellNames release];
    [rowString release];
    [query release];
    [query2 release];
    [query3 release];
    [rowName release];
    [nameCheck release];
    [formatter release];
    [formatter2 release];
    [formatter3 release];
    [firstDateEnter release];
    [firstDate release];
    [dateEnter release];
    [lastDate release];
    [splite release];
    [dayName release];
    [nexSunday release];
    [nexSun release];
    [sevSunSpecific release];
    [nexSaturday release];
    [nexSat release];
    [nexSatSpecific release];
    [sevSaturday release];
    [sevSat release];
    [sevSatSpecific release];
    [lastSatString release];
    [sevPrevSunday release];
    [sevPrevSun release];
    [sevPrevSunSpecific release];
    [testDate release];
    [testString release];
    [app release];
}

@end