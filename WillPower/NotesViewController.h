//
//  NotesViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <sqlite3.h>
#define kFilename	@"willpower.sqlite3"
#define kFileName3   @"notes.plist"


@interface NotesViewController : UIViewController <UITextViewDelegate> {
	
    sqlite3 *database;
    NSString *createSQL;
    NSString *query;
    NSString *why1;
    NSString *why2;
    NSString *suggestion;
    NSString *exampleWhy;
    int changed;
	UITextView *textView;
}
@property (nonatomic, retain) UITextView *textView;

-(NSString *) filePath3;
-(void)applicationDidEnterBackground:(NSNotification *)notification;
-(void)applicationWillTerminate:(NSNotification *)notification;

@end
