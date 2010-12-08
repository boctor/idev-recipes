//
//  StretchableImagesAppDelegate.h
//  StretchableImages
//
//  Created by Peter Boctor on 12/8/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

@class StretchableImagesViewController;

@interface StretchableImagesAppDelegate : NSObject <UIApplicationDelegate>
{
  UIWindow *window;
  StretchableImagesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StretchableImagesViewController *viewController;

@end

