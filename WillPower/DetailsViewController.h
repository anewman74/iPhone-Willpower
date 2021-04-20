//
//  DetailsViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"

@interface DetailsViewController : UIViewController <UITextFieldDelegate> {
    
    sqlite3 *database;
    
    NSString *query;
    int newrownum;
    NSString *title;
	NSString *message;
	UIAlertView *alert;	
	BOOL moveViewUp;
    BOOL keyboardJustAppeared;
	CGFloat scrollAmount;
    CGFloat scrollAmountExisting;
    CGFloat scrollAmountTotal;
    int keyboardSize;
    UIToolbar *keyboardToolbar;
    NSDate *dateInDatabase;
	NSString *strSelectedTime;
    NSDateFormatter *formatter;
    NSCharacterSet *numbersSet;
    NSString *capitalizedName;
    NSString *capitalizedDate;
    NSString *capitalizedScoreTitle1;
    NSString *capitalizedScoreTitle2;
    UIApplication *app;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UILabel *goalName;
    UILabel *goalDate;
    UILabel *lblPerformance;
	UILabel *scoreLabel1;
	UITextField *score1;
	UILabel *scoreLabel2;
	UITextField *score2;
	UITextField *rating;
    UILabel *lblComment;
	UITextField *comment;
    UIButton *btnSave;
    UILabel *suggestion;
}
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

-(IBAction) save;
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void) scrollTheView:(BOOL)movedUp;
-(void)resignKeyboard:(id)sender;
-(void)previousField:(id)sender;
-(void)nextField:(id)sender;

@end
