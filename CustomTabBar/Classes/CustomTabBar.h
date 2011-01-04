//
//  CustomTabBar.h
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//  Copyright 2011 Zumobi. All rights reserved.
//

@class CustomTabBar;
@protocol CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage*) backgroundImage;
- (UIImage*) selectedItemBackgroundImage;
- (UIImage*) glowImage;
- (UIImage*) selectedItemImage;
- (UIImage*) tabBarArrowImage;

@optional
- (void) touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end


@interface CustomTabBar : UIView
{
  NSObject <CustomTabBarDelegate> *delegate;
  NSMutableArray* buttons;
}

@property (nonatomic, retain) NSMutableArray* buttons;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTabBarDelegate>*)customTabBarDelegate;

- (void) selectItemAtIndex:(NSInteger)index;
- (void) glowItemAtIndex:(NSInteger)index;
- (void) removeGlowAtIndex:(NSInteger)index;

@end
