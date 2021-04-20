//
//  DayListViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class DayResultViewController;


@interface DayListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    DayResultViewController *dayresultVC;    
    IBOutlet UITableView *alljournals;
    NSMutableArray *tableCellNames;
    NSString *query;
    NSString *query2;
    NSString *rowName;
    
    int newrownumber;
    char *nameChosen;
    char *dateChosen;
    NSString *nameCheck;
	NSString *strSelectedTime;
    UIApplication *app;
}
@property (nonatomic, retain) DayResultViewController *dayresultVC;
@property (nonatomic, retain) UITableView *alljournals;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
