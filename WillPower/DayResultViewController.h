//
//  DayResultViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"

@interface DayResultViewController : UIViewController {
    sqlite3 *database;
    
    NSString *query;
    NSString *query2;
    NSString *query3;
    int testresultnum;
    int newrownumber;
    char *nameChosen;
    NSString *nameCheck;
    char *dateChosen;
    NSString *dateCheck;
    NSMutableArray *dateArray;
    NSString *capitalizedName;
    NSString *capitalizedTitle1;
    NSString *capitalizedTitle2;
    UIApplication *app;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UILabel *goalName;
    UILabel *subtitle;
    UILabel *scoreLabel1;
	UILabel *scoreLabel2;
    UILabel *rating;
    UILabel *goalDate1;
	UILabel *scoreLabel11;
    UILabel *scoreLabel21;
    UILabel *rating1;
	UILabel *goalDate2;
	UILabel *scoreLabel12;
    UILabel *scoreLabel22;
    UILabel *rating2;
    UILabel *goalDate3;
    UILabel *scoreLabel13;
    UILabel *scoreLabel23;
    UILabel *rating3;
    UILabel *goalDate4;
	UILabel *scoreLabel14;
    UILabel *scoreLabel24;
    UILabel *rating4;
    UILabel *goalDate5;
	UILabel *scoreLabel15;
    UILabel *scoreLabel25;
    UILabel *rating5;
    UILabel *goalDate6;
	UILabel *scoreLabel16;
    UILabel *scoreLabel26;
    UILabel *rating6;
    UILabel *goalDate7;
	UILabel *scoreLabel17;
    UILabel *scoreLabel27;
    UILabel *rating7;
}

@end
