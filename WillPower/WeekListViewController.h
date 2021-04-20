//
//  WeekListViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class WeekResultViewController;

@interface WeekListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    WeekResultViewController *weekresultVC;
    
    IBOutlet UITableView *alljournals;
    NSMutableArray *tableDataRow;
    NSMutableArray *tableCellNames;
    NSString *rowString;
    NSString *query;
    NSString *query2;
    NSString *query3;
    NSString *rowName;
    int newrownumber;
    char *nameChosen;
    NSString *nameCheck;    
    NSDateFormatter *formatter;
    NSDateFormatter *formatter2;
    NSDateFormatter *formatter3;
    
    double firstDateEntered;
    NSDate *firstDateEnter;
	NSString *firstDate;
    double lastDateEntered;
    NSDate *dateEnter;
	NSString *lastDate;
    NSArray *splite;
    NSString *dayName;
    int addDays;
    int dayHour;
    int dayMinutes;
    double doubleHourMin;
    double oneday;
    
    double nextSunday;
    NSDate *nexSunday;
    NSString *nexSun;
    NSString *nexSunSpecific;
    
    double sevenSunday;
    NSDate *sevSunday;
    NSString *sevSun;
    NSString *sevSunSpecific;
    
    double nextSaturday;
    NSDate *nexSaturday;
    NSString *nexSat;
    NSString *nexSatSpecific;
    
    double sevenSaturday;
    NSDate *sevSaturday;
    NSString *sevSat;
    NSString *sevSatSpecific;
    
    NSString *lastSatString;
    double lastSatDouble;
    
    double sevenPrevSunday;
    NSDate *sevPrevSunday;
    NSString *sevPrevSun;
    NSString *sevPrevSunSpecific;
    
    NSDate *testDate;
    NSString *testString;
    UIApplication *app;
    BOOL addNewRow;
   }
@property (nonatomic, retain) WeekResultViewController *weekresultVC;
@property (nonatomic, retain) UITableView *alljournals;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
