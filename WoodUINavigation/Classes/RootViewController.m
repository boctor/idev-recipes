//
//  RootViewController.m
//  WoodUINavigation
//
//  Created by Peter Boctor on 12/13/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "RootViewController.h"

#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 5.0

typedef enum {
   CapLeft          = 0,
   CapMiddle        = 1,
   CapRight         = 2,
   CapLeftAndRight  = 3
} CapLocation;

@interface RootViewController (PrivateMethods)
-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location;
-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText;
@end

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.navigationItem.rightBarButtonItem = [self woodBarButtonItemWithText:@"Store"];
  UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  [rightButton addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];

  self.navigationItem.leftBarButtonItem = [self woodBarButtonItemWithText:@"Edit"];
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];

  segmentControlTitles = [[NSArray arrayWithObjects:@"Books", @"PDFs", nil] retain];
  UIImage* dividerImage = [UIImage imageNamed:@"view-control-divider.png"];
  self.navigationItem.titleView = [[[CustomSegmentedControl alloc] initWithSegmentCount:segmentControlTitles.count segmentsize:CGSizeMake(BUTTON_SEGMENT_WIDTH, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self] autorelease];
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
  CapLocation location;
  if (segmentIndex == 0)
    location = CapLeft;
  else if (segmentIndex == segmentControlTitles.count - 1)
    location = CapRight;
  else
    location = CapMiddle;

  UIButton* button = [self woodButtonWithText:[segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
  if (segmentIndex == 0)
    button.selected = YES;
  return button;
}

- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
  [[[[UIAlertView alloc] initWithTitle:[segmentControlTitles objectAtIndex:segmentIndex]
    message:nil
    delegate:nil
    cancelButtonTitle:nil 
    otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease] show];
}

-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText
{
  return [[[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:buttonText stretch:CapLeftAndRight]] autorelease];
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

-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location
{
  UIImage* buttonImage = nil;
  UIImage* buttonPressedImage = nil;
  NSUInteger buttonWidth = 0;
  if (location == CapLeftAndRight)
  {
    buttonWidth = BUTTON_WIDTH;
    buttonImage = [[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    buttonPressedImage = [[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
  }
  else
  {
    buttonWidth = BUTTON_SEGMENT_WIDTH;
    
    buttonImage = [self image:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    buttonPressedImage = [self image:[[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
  }


  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
  button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
  button.titleLabel.textColor = [UIColor whiteColor];
  button.titleLabel.shadowOffset = CGSizeMake(0,-1);
  button.titleLabel.shadowColor = [UIColor darkGrayColor];

  [button setTitle:buttonText forState:UIControlStateNormal];
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
  button.adjustsImageWhenHighlighted = NO;

  return button;
}

- (void)storeAction:(id)sender
{
  [[[[UIAlertView alloc] initWithTitle:@"Store"
    message:nil
    delegate:nil
    cancelButtonTitle:nil 
    otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease] show];
}

- (void)editAction:(id)sender
{
  [[[[UIAlertView alloc] initWithTitle:@"Edit"
    message:nil
    delegate:nil
    cancelButtonTitle:nil 
    otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease] show];
}

- (void)dealloc
{
  [super dealloc];

  [segmentControlTitles release];
}


@end

