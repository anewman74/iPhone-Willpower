//
//  DailyRemindersTableViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class DailyReminderUpdate;

@interface DailyRemindersTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    DailyReminderUpdate *dailyremind;
    UIApplication *app;
    IBOutlet UITableView *alljournals;
    NSMutableArray *tableCellNames;
    NSString *rowString;
    NSString *query;
    NSString *query2;
    char *quoteChar;
    NSString *quoteDB;
    int rownum;
}
@property (nonatomic, retain) DailyReminderUpdate *dailyremind;
@property (nonatomic, retain) UITableView *alljournals;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
