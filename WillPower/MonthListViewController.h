//
//  MonthListViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
#import "MonthResultViewController.h"

@interface MonthListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    MonthResultViewController *monthresultVC;
    
    IBOutlet UITableView *alljournals;
    NSMutableArray *tableDataRow;
    NSMutableArray *tableCellNames;
    NSArray *splite;
    NSString *rowString;
    NSString *query;
    NSString *query2;
    NSString *query3;
    NSString *rowName;
    int newrownumber;
    char *nameChosen;
    NSString *nameCheck;
    
    char *firstMonthChar;
    char *firstYearChar;
    NSString *firstMonthString;
    NSString *firstYearString;
    int firstMonthInt;
    int firstYearInt;
    
    char *lastMonthChar;
    NSString *lastMonthString;
    int lastMonthInt;
    NSString *lastMonString;
    char *lastYearChar;
    NSString *lastYearString;
    int lastYearInt;
    
    int sevenMonthInt;
    int sevenYearInt;
    NSString *sevenMonthString;
    NSString *sevenDateString;
    NSString *lastDateString;
    
    int nextMonthInt;
    int nextYearInt;
    NSString *nextMonthString;
    NSString *selectedMonth;
    NSString *selectedYear;
    int selMonth;
    int selYear;
    UIApplication *app;
    BOOL addNewRow;
}
@property (nonatomic, retain) MonthResultViewController *monthresultVC;
@property (nonatomic, retain) UITableView *alljournals;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
