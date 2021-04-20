//
//  AboutViewController.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController <UITextViewDelegate> {
    
    UIImageView *about;
    UIImageView *url;
    UITextView *textView3;
}
@property (nonatomic, retain) UITextView *textView3;
-(IBAction) url;

@end
