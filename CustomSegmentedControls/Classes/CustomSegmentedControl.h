//
//  CustomSegmentedControl.h
//  CustomSegmentedControls
//
//  Created by Peter Boctor on 12/10/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

@class CustomSegmentedControl;
@protocol CustomSegmentedControlDelegate

- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;

@optional
- (void) touchUpInsideSegmentIndex:(NSUInteger)segmentIndex;
- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex;
@end

@interface CustomSegmentedControl : UIView
{
  NSObject <CustomSegmentedControlDelegate> *delegate;
  NSMutableArray* buttons;
}

@property (nonatomic, retain) NSMutableArray* buttons;

- (id) initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage*)dividerImage tag:(NSInteger)objectTag delegate:(NSObject <CustomSegmentedControlDelegate>*)customSegmentedControlDelegate;

@end
