//
//  CustomTabBarViewController.m
//  WordPressReimagined
//
//  Created by Peter Boctor on 3/17/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "CustomTabBarViewController.h"
#import "FreshlyPressedViewController.h"

@interface CustomTabBarViewController (PrivateMethods)
-(UILabel*)labelWithDescription:(NSString*)text;
@end

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

static NSArray* viewControllers = nil;
static NSUInteger selectedIndex = 0;

@implementation CustomTabBarViewController
@synthesize tabBar;

- (void) awakeFromNib
{
  FreshlyPressedViewController *freshlyPressedViewController = [[[FreshlyPressedViewController alloc] initWithNibName:@"FreshlyPressedViewController" bundle:nil] autorelease];

  UIViewController *detailController2 = [[[UIViewController alloc] init] autorelease];
  [detailController2.view addSubview:[self labelWithDescription:@"Tags would mirror wordpress.com/tags, letting you choose from a list of tags and then letting you explore blogs posts within each tag."]];
  detailController2.view.backgroundColor = [UIColor greenColor];

  UIViewController *detailController3 = [[[UIViewController alloc] init] autorelease];
  [detailController3.view addSubview:[self labelWithDescription:@"Posts I Like would show you the posts you've liked, either on wordpress.com or inside the app."]];
  detailController3.view.backgroundColor = [UIColor blueColor];

  UIViewController *detailController4 = [[[UIViewController alloc] init] autorelease];
  [detailController4.view addSubview:[self labelWithDescription:@"Subscriptions would show you the posts for the sites you've subscribed to, either on wordpress.com or inside the app."]];
  detailController4.view.backgroundColor = [UIColor cyanColor];

  UIViewController *detailController5 = [[[UIViewController alloc] init] autorelease];
  [detailController5.view addSubview:[self labelWithDescription:@"My Blogs would contain the existing WordPress iOS app, listing your blog and letting you manage the posts, comments and pages."]];
  detailController5.view.backgroundColor = [UIColor purpleColor];

  viewControllers = [[NSArray arrayWithObjects:
              [NSDictionary dictionaryWithObjectsAndKeys:@"34-coffee.png", @"image", freshlyPressedViewController, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"15-tags.png", @"image", detailController2, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"28-star.png", @"image", detailController3, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"Subscriptions.png", @"image", detailController4, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"111-user.png", @"image", detailController5, @"viewController", nil], nil] retain];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Back" style:UIBarButtonItemStyleBordered target: nil action: nil] autorelease];

  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
  self.tabBar = [[[CustomTabBar alloc] initWithItemCount:viewControllers.count itemSize:CGSizeMake(self.view.frame.size.width/viewControllers.count, tabBarGradient.size.height*2) tag:0 delegate:self] autorelease];
  
  // Place the tab bar at the bottom of our view
  tabBar.frame = CGRectMake(0,self.view.frame.size.height-(tabBarGradient.size.height*2),self.view.frame.size.width, tabBarGradient.size.height*2);
  [self.view addSubview:tabBar];
  
  // Select the first tab
  [self performSelector:@selector(selectFirstTab) withObject:nil afterDelay:0];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void) selectFirstTab
{
  [tabBar selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0];
}

- (UIViewController*) selectedViewController
{
  NSDictionary* data = [viewControllers objectAtIndex:selectedIndex];
  UIViewController* viewController = [data objectForKey:@"viewController"];
  return viewController;
}

#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
  // Get the right data
  NSDictionary* data = [viewControllers objectAtIndex:itemIndex];
  // Return the image for this tab bar item
  return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (UIImage*) backgroundImage
{
  // The tab bar's width is the same as our width
  CGFloat width = self.view.frame.size.width;
  // Get the image that will form the top of the background
  UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a new image context
  if (UIGraphicsBeginImageContextWithOptions)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
  else
    UIGraphicsBeginImageContext(CGSizeMake(width, topImage.size.height*2));
  
  // Create a stretchable image for the top of the background and draw it
  UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
  
  // Draw a solid black color for the bottom of the background
  [[UIColor blackColor] set];
  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
  
  // Generate a new image
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
  return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage*) glowImage
{
  UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
  
  // Create a new image using the TabBarGlow image but offset 4 pixels down
  if (UIGraphicsBeginImageContextWithOptions)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
  else
    UIGraphicsBeginImageContext(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0));

  // Draw the image
  [tabBarGlow drawAtPoint:CGPointZero];

  // Generate a new image
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/viewControllers.count, tabBarGradient.size.height*2);
  if (UIGraphicsBeginImageContextWithOptions)
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
  else
    UIGraphicsBeginImageContext(tabBarItemSize);

  // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
  [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)];  

  // Generate a new image
  UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return selectedItemImage;
}

- (UIImage*) tabBarArrowImage
{
  return [UIImage imageNamed:@"TabBarNipple.png"];
}

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
  selectedIndex = itemIndex;
  
  // Remove the current view controller's view
  UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
  [currentView removeFromSuperview];
  
  // Get the right view controller
  NSDictionary* data = [viewControllers objectAtIndex:itemIndex];
  UIViewController* viewController = [data objectForKey:@"viewController"];

  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];

  // Set the view controller's frame to account for the tab bar
  viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-(tabBarGradient.size.height*2));

  // Se the tag so we can find it later
  viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
  
  // Add the new view controller's view
  [self.view insertSubview:viewController.view belowSubview:tabBar];
  
  [viewController viewWillAppear:NO];
  // In 1 second glow the selected tab
  // [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
  
}

// - (void)addGlowTimerFireMethod:(NSTimer*)theTimer
// {
//   // Remove the glow from all tab bar items
//   for (NSUInteger i = 0 ; i < viewControllers.count ; i++)
//   {
//     [tabBar removeGlowAtIndex:i];
//   }
//   
//   // Then add it to this tab bar item
//   [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
// }

-(UILabel*)labelWithDescription:(NSString*)text
{
  CGRect labelFrame = CGRectMake(20,60, 280, 400);

  UILabel* label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
  label.numberOfLines = 0;
  // label.textAlignment = UITextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  label.text = text;
  [label sizeToFit];
  return label;
  
}
- (void)dealloc
{
  [super dealloc];
  [tabBar release];
}

@end
