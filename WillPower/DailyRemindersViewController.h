//
//  DailyRemindersViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DailyRemindersTableViewController;
@class DailyReminderUpdate;
@class EarthScreen;
#import "Singleton.h"
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"

@interface DailyRemindersViewController : UIViewController <UITextFieldDelegate> {

    sqlite3 *database;
    NSString *createSQL;
    NSString *createSQL2;
    DailyRemindersTableViewController *dailyTableVC;
    DailyReminderUpdate * dailyUp;
    EarthScreen *earthscreen;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UILabel *suggestion;
    UIButton *btnViewAllQuotes;
    UIButton *btnInsertNewQuote;
    UILabel *reminderSettings;
    UILabel *displayQuotes;
    UITextField *minutes;
    UIButton *btnStartTimer;
    UIButton *btnStopTimer;
    UIButton *btnEarthView;
    
    NSString *stringTimer;
    float timerInMin;
	int timerInSec;
    int timerStopped;
    int timerStarted;
    NSString *strMin;
    NSString *title;
    NSString *message;
	UIAlertView *alert;
    NSTimer *timer;
    
    NSMutableArray *tableCellNames;
    NSString *rowString;
    NSString *query;
    NSString *query2;
    NSString *query3;
    char *quoteChar;
    NSString *quoteDB;
    NSString *quoteString;
    int changed;
    int rownum;
    int quoteNumber;
    
    NSString *quote1;
    NSString *quote2;
    NSString *quote3;
    NSString *quote4;
    NSString *quote5;
    NSString *quote6;
    NSString *quote7;
    NSString *quote8;
    NSString *quote9;
    NSString *quote10;
    NSString *quote11;
    NSString *quote12;
    NSString *quote13;
    NSString *quote14;
    NSString *quote15;
    NSString *quote16;
    
    NSDate *now;
    NSDate *originaldate;
    double doubleOriginal;
    double doubleNow;
    double doubleNew;
    NSDate *dateNew;
    float timesecs;
    NSCharacterSet *numbersSet;
    UIApplication *application;
    UIApplication *application2;
    UIApplication *application3;
    UIApplication *application4;
    NSArray *oldNotifications;
    NSMutableArray *newTable;
    UILocalNotification* reminder;
    
    BOOL moveViewUp;
	CGFloat scrollAmount;
}
@property (nonatomic, retain) DailyRemindersTableViewController *dailyTableVC;
@property (nonatomic, retain) DailyReminderUpdate *dailyUp;
@property (nonatomic, retain) EarthScreen *earthscreen;

-(IBAction) toDailyTable;
-(IBAction) newQuote;
-(IBAction) startTimer;
-(IBAction) stopTimer;
-(IBAction) earthView;
-(void) scheduleReminders:(double)timerSec reminders:(int)reminders;

-(void) beginAlerts;
-(void) nextAlert;

-(void)applicationWillTerminate:(NSNotification *)notification;
-(void)applicationDidEnterBackground:(NSNotification *)notification;
-(void)applicationWillEnterForeground:(NSNotification *)notification;
-(void) scrollTheView:(BOOL)movedUp;

@end
