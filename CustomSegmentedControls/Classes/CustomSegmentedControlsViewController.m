//
//  CustomSegmentedControlsViewController.m
//  CustomSegmentedControls
//
//  Created by Peter Boctor on 12/10/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "CustomSegmentedControlsViewController.h"

#define VERTICAL_OFFSET 10.0
#define HORIZONTAL_OFFSET 10.0
#define VERTICAL_SPACING 5.0
#define VERTICAL_HEIGHT 70.0

#define TAG_VALUE 9000

static NSArray* buttons = nil;

typedef enum {
   CapLeft          = 0,
   CapMiddle        = 1,
   CapRight         = 2,
   CapLeftAndRight  = 3
} CapLocation;

@interface CustomSegmentedControlsViewController (PrivateMethods)
-(void)addView:(UIView*)subView verticalOffset:(NSUInteger)verticalOffset title:(NSString*)title;
@end

@implementation CustomSegmentedControlsViewController

- (void) awakeFromNib
{
  buttons = [[NSArray arrayWithObjects:
              [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"One", @"Two", @"Three", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(80,47)], @"size", @"bottombarblue.png", @"button-image", @"bottombarblue_pressed.png", @"button-highlight-image", @"blue-divider.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"One", @"Two", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(80,47)], @"size", @"bottombarblue.png", @"button-image", @"bottombarblue_pressed.png", @"button-highlight-image", @"blue-divider.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"One", @"Two", @"Three", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(100,47)], @"size", @"bottombarredfire.png", @"button-image", @"bottombarredfire_pressed.png", @"button-highlight-image", @"red-divider.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], 
              [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"1", @"2", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(47,47)], @"size", @"bottombarredfire.png", @"button-image", @"bottombarredfire_pressed.png", @"button-highlight-image", @"red-divider.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], nil] retain];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // A blue segment control with 3 values
  NSDictionary* blueSegmentedControlData = [buttons objectAtIndex:0];
  NSArray* blueSegmentedControlTitles = [blueSegmentedControlData objectForKey:@"titles"];
  CustomSegmentedControl* blueSegmentedControl = [[[CustomSegmentedControl alloc] initWithSegmentCount:blueSegmentedControlTitles.count segmentsize:[[blueSegmentedControlData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[blueSegmentedControlData objectForKey:@"divider-image"]] tag:TAG_VALUE delegate:self] autorelease];
  [self addView:blueSegmentedControl verticalOffset:0 title:@"Blue segmented control"];

  // A blue segment control with 2 values
  NSDictionary* anotherBlueSegmentedControlData = [buttons objectAtIndex:1];
  NSArray* anotherBlueSegmentedControlTitles = [anotherBlueSegmentedControlData objectForKey:@"titles"];
  CustomSegmentedControl* anotherBlueSegmentedControl = [[[CustomSegmentedControl alloc] initWithSegmentCount:anotherBlueSegmentedControlTitles.count segmentsize:[[anotherBlueSegmentedControlData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[anotherBlueSegmentedControlData objectForKey:@"divider-image"]] tag:TAG_VALUE + 1 delegate:self] autorelease];
  [self addView:anotherBlueSegmentedControl verticalOffset:1 title:@"Another blue segmented control"];

  // A red segment control with 3 values
  NSDictionary* redSegmentedControlData = [buttons objectAtIndex:2];
  NSArray* redSegmentedControlTitles = [redSegmentedControlData objectForKey:@"titles"];
  CustomSegmentedControl* redSegmentedControl = [[[CustomSegmentedControl alloc] initWithSegmentCount:redSegmentedControlTitles.count segmentsize:[[redSegmentedControlData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[redSegmentedControlData objectForKey:@"divider-image"]] tag:TAG_VALUE + 2 delegate:self] autorelease];
  [self addView:redSegmentedControl verticalOffset:2 title:@"Red segmented control"];

  // A red segment control with 2 values
  NSDictionary* anotherRedSegmentedControlData = [buttons objectAtIndex:3];
  NSArray* anotherRedSegmentedControlTitles = [anotherRedSegmentedControlData objectForKey:@"titles"];
  CustomSegmentedControl* anotherRedSegmentedControl = [[[CustomSegmentedControl alloc] initWithSegmentCount:anotherRedSegmentedControlTitles.count segmentsize:[[anotherRedSegmentedControlData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[anotherRedSegmentedControlData objectForKey:@"divider-image"]] tag:TAG_VALUE + 3 delegate:self] autorelease];
  [self addView:anotherRedSegmentedControl verticalOffset:3 title:@"Another red segmented control"];
}

-(void)addView:(UIView*)subView verticalOffset:(NSUInteger)verticalOffset title:(NSString*)title
{
  // Figure out the vertical location based on the offset and heights
  CGFloat elementVerticalLocation = (VERTICAL_HEIGHT + (VERTICAL_SPACING * 2)) * verticalOffset;
  
  // Add a label
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_OFFSET, elementVerticalLocation + VERTICAL_OFFSET, 0, 0)] autorelease];
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.text = title;
  [label sizeToFit];
  
  [self.view addSubview:label];

  // Adjust location of new subView and add it
  subView.frame = CGRectMake(HORIZONTAL_OFFSET, elementVerticalLocation + label.frame.size.height + 5 + VERTICAL_OFFSET, subView.frame.size.width, subView.frame.size.height);
  [self.view addSubview:subView];
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);

  if (location == CapLeft)
    // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
    [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
  else if (location == CapRight)
    // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
    [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
  else if (location == CapMiddle)
    // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
    [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];

  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
  NSUInteger dataOffset = segmentedControl.tag - TAG_VALUE ;
  NSDictionary* data = [buttons objectAtIndex:dataOffset];
  NSArray* titles = [data objectForKey:@"titles"];

  CapLocation location;
  if (segmentIndex == 0)
    location = CapLeft;
  else if (segmentIndex == titles.count - 1)
    location = CapRight;
  else
    location = CapMiddle;

  UIImage* buttonImage = nil;
  UIImage* buttonPressedImage = nil;
  
  CGFloat capWidth = [[data objectForKey:@"cap-width"] floatValue];
  CGSize buttonSize = [[data objectForKey:@"size"] CGSizeValue];
  
  if (location == CapLeftAndRight)
  {
    buttonImage = [[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    buttonPressedImage = [[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
  }
  else
  {
    buttonImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
    buttonPressedImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
  }
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);

  [button setTitle:[titles objectAtIndex:segmentIndex] forState:UIControlStateNormal];
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
  button.adjustsImageWhenHighlighted = NO;

  if (segmentIndex == 0)
    button.selected = YES;
  return button;
}

@end
