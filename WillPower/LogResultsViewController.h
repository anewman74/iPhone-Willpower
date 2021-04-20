//
//  LogResultsViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class ResultViewController;

#define kFilename	@"willpower.sqlite3"

@interface LogResultsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    sqlite3 *database;
    NSString *createSQL;
    IBOutlet UITableView *alljournals;    
    NSMutableArray *tableData;
    ResultViewController *resultVC;
    NSString *nameChosen;
    NSString *query; 
    int rownumber;
    UIApplication *app;
}
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) ResultViewController *resultVC;

-(void)initializeTableData;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
