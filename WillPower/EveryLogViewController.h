//
//  EveryLogViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class UpdateViewController;

@interface EveryLogViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {    
    
    UpdateViewController *updateVC;
    sqlite3 *database;
    IBOutlet UITableView *alljournals;    
    NSMutableArray *tableData;
    NSMutableArray *tableDataRow;
    NSString *rowChosen;
    NSString *query;
    NSString *query2;
    NSArray *splite;
	NSString *secondString;
    int rownumber;
    
    int newrownumber;
    char *nameChosen;
    NSString *nameCheck; 
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    UIApplication *app;
}
@property (nonatomic, retain) UpdateViewController *updateVC;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *tableDataRow;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
