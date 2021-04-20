//
//  WillPowerAppDelegate.h
//  WillPower
//
//  Created by Andrew on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavigationController;

@interface WillPowerAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UITabBarController *rootController;
    IBOutlet NavigationController *navController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet NavigationController *navController;

@end
