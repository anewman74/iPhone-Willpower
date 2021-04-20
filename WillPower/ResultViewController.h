//
//  ResultViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class DetailsViewController;

#define kFilename	@"willpower.sqlite3"


@interface ResultViewController : UIViewController {
    
    DetailsViewController *detailsViewController;
    sqlite3 *database;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
	UIDatePicker *datePicker;
    UILabel *lblTime;
    UIButton *btnSave;
 
	NSDateFormatter *formatter;
	NSDateFormatter *formatter2;
    NSDateFormatter *formatter3;
    
    NSDate *now;
    NSDate *dateInDatabase;
    NSString *query;
    NSString *query2;
	NSDate *dateSelectedTime;
    double doubleSelectedTime;
    NSString *strDatabaseDate;
    NSString *strSelectedDate;
    NSString *strSelectedMonthYear;
    NSArray *splite;
    NSString *strSelectedMonth;
    NSString *strSelectedYear;
    int newrownumber;
    char *nameChosen;
    NSString *nameCheck;
    NSString *strTitle1; 
    NSString *strTitle2;
    NSString *capitalizedTitle;
    UIApplication *app;
}
@property (nonatomic, retain) DetailsViewController *detailsViewController;
@property (nonatomic, retain) UIDatePicker *datePicker;

-(void)details;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
