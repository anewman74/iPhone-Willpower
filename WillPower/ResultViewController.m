//
//  ResultViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "ResultViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "DetailsViewController.h"
#import "Singleton.h"

@implementation ResultViewController
@synthesize detailsViewController;
@synthesize datePicker;


#pragma details method gets the date and session
-(void) details {
	
	// Formatter
	formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM dd yyyy"];
    formatter2 = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter2 setDateFormat:@"EEEE, HH, mm, MMM dd yyyy"]; 
    formatter3 = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter3 setDateFormat:@"MM,yyyy"]; 
    
    //Selected Time Values:
	dateSelectedTime = [datePicker date];
    
    doubleSelectedTime = [dateSelectedTime timeIntervalSince1970];
    //NSLog(@"double selected time is  %f", doubleSelectedTime);
    
	// String date selected
	strSelectedDate = [formatter stringFromDate:dateSelectedTime];	    
    //NSLog(@"date selected in details method: %@", strSelectedDate); 
    
    // Year and month selected
    strSelectedMonthYear = [formatter3 stringFromDate:dateSelectedTime];
    splite = [strSelectedMonthYear componentsSeparatedByString:@","];
    strSelectedMonth = [splite objectAtIndex:0];
    strSelectedYear = [splite objectAtIndex:1];
    //NSLog(@"selected month: %@",strSelectedMonth);
    //NSLog(@"selected year: %@",strSelectedYear);
    
    // Get the goal chosen
	query = [[NSString alloc] initWithFormat: @"SELECT name, date, scoretitle1, scoretitle2 FROM goals where row = '%i'",newrownumber];    
    sqlite3_stmt *statement;    
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            nameChosen = (char *)sqlite3_column_text(statement, 0);
            //NSLog(@"name chosen in detail method in result view is  %s", nameChosen);
            nameCheck = [[NSString alloc] initWithFormat:@"%s",nameChosen];
            //NSLog(@"name check in detail method in result view is  %@", nameCheck);
            
            dateInDatabase = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 1)];
            strDatabaseDate = [formatter stringFromDate:dateInDatabase];	    
            //NSLog(@"date from database: %@", strDatabaseDate); 
            
            char *scti1 = (char *)sqlite3_column_text(statement, 2);
            strTitle1 = [[NSString alloc] initWithFormat:@"%s",scti1];
            //NSLog(@"strTitle 1 in detail method in result view is  %@", strTitle1);
            
            char *scti2 = (char *)sqlite3_column_text(statement, 3);
            strTitle2 = [[NSString alloc] initWithFormat:@"%s",scti2];
            //NSLog(@"strTitle2 in detail method in result view is  %@", strTitle2);
            
            //NSLog(@"new row number used is  %i", newrownumber);
        }
        sqlite3_finalize(statement);
    }
    
    //If this is the first entry (no date), update the row with the goal name in the database.
    if([strDatabaseDate isEqualToString:@"Dec 31 1969"]){
        //NSLog(@"in if - need to update not insert");
        
        char *update = "update goals set date = ?, datestring = ?, monthstring = ?, yearstring = ? where row = ?;";
        
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_double(stmt,1, [dateSelectedTime timeIntervalSince1970]);
            sqlite3_bind_text(stmt, 2, [strSelectedDate UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [strSelectedMonth UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [strSelectedYear UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 5, newrownumber);
        }
        
        if(sqlite3_step(stmt) != SQLITE_DONE)
            //NSLog(@"statement failed");
        sqlite3_finalize(stmt);
    }
    else {
        //NSLog(@"name check in detail method in else  %@", nameCheck);  
        //NSLog(@"date selected in else: %@", strSelectedDate); 
        
        // insert a new row with goal and date
        char *update = "INSERT INTO goals (name,date,datestring,monthstring,yearstring,scoretitle1,scoretitle2) VALUES(?,?,?,?,?,?,?);";	
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [nameCheck UTF8String], -1, NULL);
            sqlite3_bind_double(stmt,2, [dateSelectedTime timeIntervalSince1970]);
            sqlite3_bind_text(stmt, 3, [strSelectedDate UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [strSelectedMonth UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5, [strSelectedYear UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6, [strTitle1 UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 7, [strTitle2 UTF8String], -1, NULL);
        }
        if(sqlite3_step(stmt) != SQLITE_DONE)
            //NSLog(@"statement failed");
        sqlite3_finalize(stmt);	
        
        // Get the last DB entry made to carry to next view in singleton to use in update.
        query2 =  @"SELECT row FROM goals order by row desc limit 1"; 	
        sqlite3_stmt *stateme;
        if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stateme, nil) == SQLITE_OK){
            while(sqlite3_step(stateme) == SQLITE_ROW){
                int row = sqlite3_column_int(stateme, 0);
                [[Singleton sharedSingleton] setnewrownumber:row];		    
                //NSLog(@"after date entered - last row saved : %i", row); 
            }
            sqlite3_finalize(stateme);
        }
    }
    
        
	sqlite3_close(database);
    
	// Push to details view controller
	if (self.detailsViewController == nil)
	{
		DetailsViewController *aDetail = [[DetailsViewController alloc] initWithNibName: @"DetailsViewController" bundle:[NSBundle mainBundle]];
		self.detailsViewController = aDetail;
		[aDetail release];
	}
    WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:detailsViewController animated:YES];  
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(89,10,142,22)];
        lblTime.numberOfLines = 0;
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor yellowColor];
        lblTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [lblTime setTextAlignment:UITextAlignmentCenter];
        lblTime.text = @"Time of Activity:";
        [self.view  addSubview:lblTime];
        
        datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        now = [[NSDate alloc] init];
        [datePicker setDate:now animated:YES];
        [datePicker setMinimumDate:nil];
        [datePicker setMaximumDate:nil];
        [now release];
        [self.view addSubview:datePicker];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,292,282,48)];
        [btnSave setImage:[UIImage imageNamed:@"button-save.png"] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(details) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
    }
    else {
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(89,140,142,22)];
        lblTime.numberOfLines = 0;
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor blackColor];
        lblTime.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
        [lblTime setTextAlignment:UITextAlignmentCenter];
        lblTime.text = @"Time of Activity:";
        [self.view  addSubview:lblTime];
        
        datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 180, 320, 216)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        now = [[NSDate alloc] init];
        [datePicker setDate:now animated:YES];
        [datePicker setMinimumDate:nil];
        [datePicker setMaximumDate:nil];
        [now release];
        [self.view addSubview:datePicker];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,410,282,48)];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(details) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
    }
    
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    //NSLog(@"row chosen in result view is  %i", newrownumber);   
    
	//Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
    
    self.title =  NSLocalizedString(@"Record Result", @"record result");
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
	
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
}


- (void)dealloc {
    [super dealloc];
    [detailsViewController release];
    [datePicker release];
    [formatter release];
    [formatter2 release];
    [formatter3 release];
    [now release];
    [dateInDatabase release];
    [query release];
    [query2 release];
    [dateSelectedTime release];
    [strDatabaseDate release];
    [strSelectedDate release];
    [strSelectedMonthYear release];
    [splite release];
    [strSelectedMonth release];
    [strSelectedYear release];
    [nameCheck release];
    [strTitle1 release];
    [strTitle2 release];
    [app release];
}


@end
