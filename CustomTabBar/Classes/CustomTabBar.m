//
//  CustomTabBar.m
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
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

#import "CustomTabBar.h"

#define GLOW_IMAGE_TAG 2394858
#define TAB_ARROW_IMAGE_TAG 2394859
#define SELECTED_ITEM_TAG 2394860

@interface CustomTabBar (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex;
-(UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;
-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
@end

@implementation CustomTabBar
@synthesize buttons;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTabBarDelegate>*)customTabBarDelegate
{
  if (self = [super init])
  {
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    // The tag allows callers withe multiple controls to distinguish between them
    self.tag = objectTag;
    
    // Set the delegate
    delegate = customTabBarDelegate;
    
    // Add the background image
    UIImage* backgroundImage = [delegate backgroundImage];
    UIImageView* backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:backgroundImageView];

    // Adjust our width based on the number of items & the width of each item
    self.frame = CGRectMake(0, 0, itemSize.width * itemCount, itemSize.height);

    // Initalize the array we use to store our buttons
    self.buttons = [[NSMutableArray alloc] initWithCapacity:itemCount];

    // horizontalOffset tracks the proper x value as we add buttons as subviews
    CGFloat horizontalOffset = 0;
    
    // Iterate through each item
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
      // Create a button
      UIButton* button = [self buttonAtIndex:i width:self.frame.size.width/itemCount];

      // Register for touch events
      [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
      [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
      [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
      [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
      [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
      
      // Add the button to our buttons array
      [buttons addObject:button];

      // Set the button's x offset
      button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);

      // Add the button as our subview
      [self addSubview:button];
      
      // Advance the horizontal offset
      horizontalOffset = horizontalOffset + itemSize.width;
    }
  }

  return self;
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
  for (UIButton* button in buttons)
  {
    if (button == selectedButton)
    {
      button.selected = YES;
      button.highlighted = button.selected ? NO : YES;
      button.tag = SELECTED_ITEM_TAG;
      
      UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
      NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
      if (tabBarArrow)
      {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect frame = tabBarArrow.frame;
        frame.origin.x = [self horizontalLocationFor:selectedIndex];
        tabBarArrow.frame = frame;
        [UIView commitAnimations];
      }
      else
      {
        [self addTabBarArrowAtIndex:selectedIndex];
      }
    }
    else
    {
      button.selected = NO;
      button.highlighted = NO;
      button.tag = 0;
    }
  }
}

- (void)touchDownAction:(UIButton*)button
{
  [self dimAllButtonsExcept:button];
  
  if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
    [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton*)button
{
  [self dimAllButtonsExcept:button];

  if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
    [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
  [self dimAllButtonsExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
  // Get the right button to select
  UIButton* button = [buttons objectAtIndex:index];
  
  [self dimAllButtonsExcept:button];
}

// Add a glow at the bottom of the specified item
- (void) glowItemAtIndex:(NSInteger)index
{
  // Get the right button. We'll use to calculate where to put the glow
  UIButton* button = [buttons objectAtIndex:index];
  
  // Ask the delegate for the glow image
  UIImage* glowImage = [delegate glowImage];
  
  // Create the image view that will hold the glow image
  UIImageView* glowImageView = [[[UIImageView alloc] initWithImage:glowImage] autorelease];
  
  // Center the glow image at the center of the button horizontally and at the bottom of the button vertically
  glowImageView.frame = CGRectMake(button.frame.size.width/2.0 - glowImage.size.width/2.0, button.frame.origin.y + button.frame.size.height - glowImage.size.height, glowImage.size.width, glowImage.size.height);

  // Set the glow image view's tag so we can find it later when we want to remove the glow
  glowImageView.tag = GLOW_IMAGE_TAG;
  
  // Add the glow image view to the button
  [button addSubview:glowImageView];
}

// Remove the glow at the bottom of the specified item
- (void) removeGlowAtIndex:(NSInteger)index
{
  // Find the right button
  UIButton* button = [buttons objectAtIndex:index];
  // Find the glow image view
  UIImageView* glowImageView = (UIImageView*)[button viewWithTag:GLOW_IMAGE_TAG];
  // Remove it from the button
  [glowImageView removeFromSuperview];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
  UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
  
  // A single tab item's width is the same as the button's width
  UIButton* button = [buttons objectAtIndex:tabIndex];
  CGFloat tabItemWidth = button.frame.size.width;

  // A half width is tabItemWidth divided by 2 minus half the width of the arrow
  CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
  
  // The horizontal location is the index times the width plus a half width
  return button.frame.origin.x + halfTabItemWidth;
}

- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
  UIImage* tabBarArrowImage = [delegate tabBarArrowImage];
  UIImageView* tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
  tabBarArrow.tag = TAB_ARROW_IMAGE_TAG;
  // To get the vertical location we go up by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
  CGFloat verticalLocation = -tabBarArrowImage.size.height + 2;
  tabBarArrow.frame = CGRectMake([self horizontalLocationFor:itemIndex], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);

  [self addSubview:tabBarArrow];
}

// Create a button at the provided index
- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
  // Create a new button with the right dimensions
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);

  // Ask the delegate for the button's image
  UIImage* rawButtonImage = [delegate imageFor:self atIndex:itemIndex];
  // Create the normal state image by converting the image's background to gray
  UIImage* buttonImage = [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:nil];
  // And create the pressed state image by converting the image's background to the background image we get from the delegate
  UIImage* buttonPressedImage = [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:[delegate selectedItemBackgroundImage]];

  // Set the gray & blue images as the button states
  [button setImage:buttonImage forState:UIControlStateNormal];
  [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setImage:buttonPressedImage forState:UIControlStateSelected];

  // Ask the delegate for the highlighted/selected state image & set it as the selected background state
  [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateHighlighted];
  [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateSelected];
  
  button.adjustsImageWhenHighlighted = NO;
  
  return button;
}

// Create a tab bar image
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource
{
  // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
  UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
  
  // Convert the passed in image to a white backround image with a black fill
  UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
  
  // Create an image mask
  CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
    CGImageGetHeight(bwImage.CGImage),
    CGImageGetBitsPerComponent(bwImage.CGImage),
    CGImageGetBitsPerPixel(bwImage.CGImage),
    CGImageGetBytesPerRow(bwImage.CGImage),
    CGImageGetDataProvider(bwImage.CGImage), NULL, YES);

  // Using the mask create a new image
  CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);

  UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];

  // Cleanup
  CGImageRelease(imageMask);
  CGImageRelease(tabBarImageRef);
  
  // Create a new context with the right size
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);

  // Draw the new tab bar image at the center
  [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
  
  // Generate a new image
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// Convert the image's fill color to black and background to white
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage
{
  // Create the proper sized rect
  CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));

  // Create a new bitmap context
  CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);

  CGContextSetRGBFillColor(context, 1, 1, 1, 1);
  CGContextFillRect(context, imageRect);

  // Use the passed in image as a clipping mask
  CGContextClipToMask(context, imageRect, startImage.CGImage);
  // Set the fill color to black: R:0 G:0 B:0 alpha:1
  CGContextSetRGBFillColor(context, 0, 0, 0, 1);
  // Fill with black
  CGContextFillRect(context, imageRect);

  // Generate a new image
  CGImageRef newCGImage = CGBitmapContextCreateImage(context);
  UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];

  // Cleanup
  CGContextRelease(context);
  CGImageRelease(newCGImage);
  
  return newImage;
}

-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage
{
  // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
  if (backgroundImage)
  {
    // Draw the background image centered
    [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
  }
  else
  {
    [[UIColor lightGrayColor] set];
    UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
  }

  UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalBackgroundImage;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width)/buttons.count;
  // horizontalOffset tracks the x value
  CGFloat horizontalOffset = 0;

  // Iterate through each button
  for (UIButton* button in buttons)
  {
    // Set the button's x offset
    button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);

    // Advance the horizontal offset
    horizontalOffset = horizontalOffset + itemWidth;
  }
  
  // Move the arrow to the new button location
  UIButton* selectedButton = (UIButton*)[self viewWithTag:SELECTED_ITEM_TAG];
  [self dimAllButtonsExcept:selectedButton];
}

- (void)dealloc
{
  [super dealloc];
  [buttons release];
}


@end
