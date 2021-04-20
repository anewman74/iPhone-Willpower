//
//  NewDataViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define kFilename	@"willpower.sqlite3"

@interface NewDataViewController : UIViewController <UITextFieldDelegate> {
    
    sqlite3 *database;
    UIApplication *app;
    BOOL moveViewUp;
    BOOL keyboardJustAppeared;
	CGFloat scrollAmount;
    int keyboardSize;
    UIToolbar *keyboardToolbar;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UIButton *btnSave;
    UILabel *lblGoal;
    UILabel *lblScore1;
    UILabel *lblScore2;
    UITextField *txtGoal;
    UITextField *scoretitle1;
    UITextField *scoretitle2;
    UILabel *suggestion;
}
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

-(void) saveGoal;
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void) scrollTheView:(BOOL)movedUp;
-(void)resignKeyboard:(id)sender;
-(void)previousField:(id)sender;
-(void)nextField:(id)sender;

@end
