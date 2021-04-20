//
//  MonthlyViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MonthListViewController.h"
#define kFilename	@"willpower.sqlite3"

@interface MonthlyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    NSString *createSQL;
    MonthListViewController *monthlistVC;
    IBOutlet UITableView *alljournals;    
    NSMutableArray *tableData;
    NSString *rowChosen;
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

@property (nonatomic, retain) MonthListViewController *monthlistVC;
@property (nonatomic, retain) NSMutableArray *tableData;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
