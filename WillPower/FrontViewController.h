//
//  FrontViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChooseActionViewController;

@interface FrontViewController : UIViewController {
    
    ChooseActionViewController *chooseActionView;
    UIImageView *earth;
    UIButton *btnCreate;
}

@property (nonatomic, retain) ChooseActionViewController *chooseActionView; 

-(void) start;

@end
