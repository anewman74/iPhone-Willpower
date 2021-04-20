//
//  DailyReminderUpdate.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
@class DailyRemindersTableViewController;

@interface DailyReminderUpdate : UIViewController <UITextViewDelegate> {
    sqlite3 *database;
    DailyRemindersTableViewController *dailyTab;
    
    NSString *query;
    int newrownumber;
    char *quoteChar;
    NSString *quoteDB;
    NSString *title;
    NSString *message;
	UIAlertView *alert;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UITextView *quote;
    UIButton *btnSaveQuote;
    UIButton *btnUpdateQuote;
    UIButton *btnDeleteQuote;
    
    NSString *newquote;
    BOOL moveViewUp;
	CGFloat scrollAmount;
    UIApplication *app;
    UIApplication *app2;
}
@property (nonatomic, retain) UITextView *quote;
@property (nonatomic, retain) DailyRemindersTableViewController *dailyTab;

-(IBAction) update;
-(IBAction) deleteQuote;
-(IBAction) insertQuote;
-(void)applicationDidEnterBackground:(NSNotification *)notification;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
