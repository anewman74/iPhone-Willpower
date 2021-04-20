//
//  WeeklyViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "WeekListViewController.h"
#define kFilename	@"willpower.sqlite3"

@interface WeeklyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    WeekListViewController *weeklistVC;
    IBOutlet UITableView *alljournals;    
    NSMutableArray *tableData;
    NSString *rowChosen;
    NSString *createSQL;
    NSString *query;
    NSString *title;
	NSString *message;
	UIAlertView *alert;	
    int rownumber;
    int count;
    int datacount;
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    UIApplication *app;
}

@property (nonatomic, retain) WeekListViewController *weeklistVC;
@property (nonatomic, retain) NSMutableArray *tableData;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
