//
//  NewDepViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
#define kFileName4   @"newdepview.plist"

@interface NewDepViewController : UIViewController <UITextViewDelegate> {
	
    sqlite3 *database;
    NSString *createSQL;
    NSString *query;
    NSString *warning1;
    NSString *warning2;
    NSString *warning3;
    NSString *warning4;
    NSString *suggestion;
    NSString *exampleWarnings;
    int changed;
	UITextView *textView2;
}
@property (nonatomic, retain) UITextView *textView2;

-(NSString *) filePath4;
-(void)applicationDidEnterBackground:(NSNotification *)notification;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
