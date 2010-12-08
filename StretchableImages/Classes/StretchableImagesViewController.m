//
//  StretchableImagesViewController.m
//  StretchableImages
//
//  Created by Peter Boctor on 12/8/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "StretchableImagesViewController.h"

#define VERTICAL_OFFSET 10.0
#define HORIZONTAL_OFFSET 10.0
#define VERTICAL_SPACING 5.0
#define VERTICAL_HEIGHT 50.0

@interface StretchableImagesViewController (PrivateMethods)
-(void)addView:(UIView*)subView verticalOffset:(NSUInteger)verticalOffset title:(NSString*)title;
@end

@implementation StretchableImagesViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // An image with no caps
  UIImage* image1 = [[UIImage imageNamed:@"1-pixel-image.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
  UIImageView* imageView1 = [[UIImageView alloc] initWithImage:image1];
  imageView1.frame = CGRectMake(0, 0, 300.0, image1.size.height);
  [self addView:imageView1 verticalOffset:0 title:@"Stretchable Image Without Caps"];

  // An image with caps stretched
  UIImage* image2 = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
  UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
  imageView2.frame = CGRectMake(0, 0, 300.0, image2.size.height);
  [self addView:imageView2 verticalOffset:1 title:@"Stretchable Image With Caps"];

  UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
  UIImage* buttonPressedImage = [[UIImage imageNamed:@"button-press.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
  
  // A button stretched with separate images for normal and highlighted states
  UIButton* shortButton = [UIButton buttonWithType:UIButtonTypeCustom];
  shortButton.frame = CGRectMake(0.0, 0.0, 100.0, buttonImage.size.height);
  [shortButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [shortButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [shortButton setTitle:@"Button" forState:UIControlStateNormal];
  [self addView:shortButton verticalOffset:2 title:@"Short Button"];

  // A longer button
  UIButton* longButton = [UIButton buttonWithType:UIButtonTypeCustom];
  longButton.frame = CGRectMake(0.0, 0.0, 200.0, buttonImage.size.height);
  [longButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [longButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [longButton setTitle:@"Button" forState:UIControlStateNormal];
  [self addView:longButton verticalOffset:3 title:@"Long Button"];
}

-(void)addView:(UIView*)subView verticalOffset:(NSUInteger)verticalOffset title:(NSString*)title
{
  // Figure out the vertical location based on the offset and heights
  CGFloat elementVerticalLocation = (VERTICAL_HEIGHT + (VERTICAL_SPACING * 2)) * verticalOffset;
  
  // Add a label
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_OFFSET, elementVerticalLocation + VERTICAL_OFFSET, 0, 0)] autorelease];
  label.backgroundColor = [UIColor clearColor];
  label.text = title;
  [label sizeToFit];
  
  [self.view addSubview:label];

  // Adjust location of new subView and add it
  subView.frame = CGRectMake(HORIZONTAL_OFFSET, elementVerticalLocation + label.frame.size.height + 2 + VERTICAL_OFFSET, subView.frame.size.width, subView.frame.size.height);
  [self.view addSubview:subView];
}

@end
