//
//  TransparentUIWebViewsAppDelegate.h
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransparentUIWebViewsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

