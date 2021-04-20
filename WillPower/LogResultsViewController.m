//
//  LogResultsViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "LogResultsViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "ResultViewController.h"
#import "Singleton.h"

@implementation LogResultsViewController
@synthesize tableData;
@synthesize resultVC;

#pragma initialize table data
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

	//Open database
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
	int count = (int)[tableData count];
    
    //NSLog(@"row: %i", row);
	
	for (int i=1; i<count+1; i++) {
		if(row == i)
		{
            nameChosen = [tableData objectAtIndex:indexPath.row];
            
            //NSLog(@"name chosen: %@",nameChosen);
            
            // I have to get a correct row number from the database where goal is this name
            query = [[NSString alloc] initWithFormat: @"SELECT row FROM goals where name = '%@' limit 1",nameChosen];
            
            sqlite3_stmt *stateme;
            if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stateme, nil) == SQLITE_OK){
                while(sqlite3_step(stateme) == SQLITE_ROW){
                    rownumber = sqlite3_column_int(stateme, 0);
                    
                    [[Singleton sharedSingleton] setnewrownumber:rownumber];
                }
                sqlite3_finalize(stateme);
            }
            
			sqlite3_close(database);

                        
			if (self.resultVC == nil)
			{
				ResultViewController *gResultLog = [[ResultViewController alloc] initWithNibName: @"ResultViewController" bundle:[NSBundle mainBundle]];
				self.resultVC = gResultLog;
				[gResultLog release];
			}
            WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navController pushViewController:resultVC animated:YES];
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    [super dealloc];
    [createSQL release];
    [alljournals release];
    [tableData release];
    [resultVC release];
    [nameChosen release];
    [query release];
    [app release];
}

@end
