//
//  UpdateViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"

@interface UpdateViewController : UIViewController <UITextFieldDelegate> {
    
    sqlite3 *database;
    
    NSString *query;
    NSString *query2;
    int newrownum;
    NSCharacterSet *numbersSet;
    NSString *title;
	NSString *message;
	UIAlertView *alert;	
	BOOL moveViewUp;
	BOOL keyboardJustAppeared;
	CGFloat scrollAmount;
    int keyboardSize;
    UIToolbar *keyboardToolbar;
    int topKeyboardPoint;
    
    char *nameChosen;
    NSString *nameCheck;
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    NSString *capitalizedName;
    NSString *capitalizedDate;
    NSString *capitalizedScoreTitle1;
    NSString *capitalizedScoreTitle2;
    NSString *capitalizedComment;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UILabel *goalName;
    UILabel *goalDate;
	UILabel *scoreLabel1;
	UITextField *score1;
	UILabel *scoreLabel2;
	UITextField *score2;
    UILabel *lblPerformance;
	UITextField *rating;
    UILabel *lblComment;
	UITextField *comment;
    UIButton *btnSave;
    UIButton *btnDeleteResult;
    UIButton *btnDeleteGoal;
    
    UIApplication *app;
}
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

-(void) save;
-(void)deleteLog;
-(void)deleteGoal;
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void) scrollTheView:(BOOL)movedUp;
-(void)resignKeyboard:(id)sender;
-(void)previousField:(id)sender;
-(void)nextField:(id)sender;

@end
