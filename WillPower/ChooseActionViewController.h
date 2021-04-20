//
//  ChooseActionViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesViewController;
@class NewDataViewController;
@class LogResultsViewController;
@class GoalResultViewController;
@class ReviewViewController;
@class NewDepViewController;
@class DailyRemindersViewController;

@interface ChooseActionViewController : UIViewController {
    
    NotesViewController *notesViewController;
    NewDataViewController *theNewData;
    LogResultsViewController *logResults;
    GoalResultViewController *goalRes;
    ReviewViewController *reviewVC;
    NewDepViewController *theNewDep;
    DailyRemindersViewController *dailyVC;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UIButton *btnWhy;
    UIButton *btnNewGoal;
    UIButton *btnLogResults;
    UIButton *btnGoalResults;
    UIButton *btnReview;
    UIButton *btnNewDep;
    UIButton *btnDailyReminders;
}
@property (nonatomic, retain) NotesViewController *notesViewController;
@property (nonatomic, retain) NewDataViewController *theNewData;
@property (nonatomic, retain) LogResultsViewController *logResults;
@property (nonatomic, retain) GoalResultViewController *goalRes;
@property (nonatomic, retain) ReviewViewController *reviewVC;
@property (nonatomic, retain) NewDepViewController *theNewDep;
@property (nonatomic, retain) DailyRemindersViewController *dailyVC;

-(void) notes;
-(void) toNewData;
-(void) toLogResults;
-(void) toGoalRes;
-(void) toReview;
-(void) toNewDep;
-(void) toDailyReminders;

@end
