//
//  DailyViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DayListViewController.h"
#define kFilename	@"willpower.sqlite3"

@interface DailyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    DayListViewController *daylistVC;
    IBOutlet UITableView *alljournals;    
    NSMutableArray *tableData;
    NSString *createSQL;
    NSString *nameChosen;
    NSString *query;
    NSString *title;
	NSString *message;
	UIAlertView *alert;	
    int rownumber;
    int count;
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    UIApplication *app;
}

@property (nonatomic, retain) DayListViewController *daylistVC;
@property (nonatomic, retain) NSMutableArray *tableData;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
