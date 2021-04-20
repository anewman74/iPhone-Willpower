//
//  ReviewViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DailyViewController;
@class WeeklyViewController;
@class MonthlyViewController;

@interface ReviewViewController : UIViewController {
    
    DailyViewController *dailyVC;
    WeeklyViewController *weeklyVC;
    MonthlyViewController *monthlyVC;
    
    UIImageView *iphone4Background;
    UIImageView *iphone5Background;
    UIButton *btnDaily;
    UIButton *btnWeekly;
    UIButton *btnMonthly;
}
@property (nonatomic, retain) DailyViewController *dailyVC;
@property (nonatomic, retain) WeeklyViewController *weeklyVC;
@property (nonatomic, retain) MonthlyViewController *monthlyVC;

-(void) toDaily;
-(void) toWeekly;
-(void) toMonthly;

@end
