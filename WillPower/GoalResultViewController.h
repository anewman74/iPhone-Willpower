//
//  GoalResultViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class EveryLogViewController;

@interface GoalResultViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    EveryLogViewController *everyVC;
    sqlite3 *database;
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
    int datacount;
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    UIApplication *app;
}
@property (nonatomic, retain) EveryLogViewController *everyVC;
@property (nonatomic, retain) NSMutableArray *tableData;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
