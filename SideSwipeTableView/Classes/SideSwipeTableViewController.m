//
//  SideSwipeTableViewController.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "SideSwipeTableViewController.h"

// By setting this to YES, you'll use gesture recognizers under 4.x and use the table's swipe to delete under 3.x
// By setting it to NO, you'll be using the table's swipe to delete under both 3.x and 4.x. This is what version 3 of the Twitter app does
// Swipe to delete on a table doesn't expose the direction of the swipe, so the animation will always be left to right
#define USE_GESTURE_RECOGNIZERS YES
// Bounce pixels define how many pixels the view is moved during the bounce animation
#define BOUNCE_PIXELS 5.0
// The first implemenation of this animated both the cell and the sideSwipeView.
// But this isn't exactly how the Twitter app does it. Instead it keeps the sideSwipeView behind the cell at x-offset of 0
// then animates in and out the cell content. The code has been updated to do it this way. If you preferred the old way
// set PUSH_STYLE_ANIMATION to YES and you'll get the older push style animation
#define PUSH_STYLE_ANIMATION NO

@interface SideSwipeTableViewController (PrivateStuff)
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction;
- (void) setupGestureRecognizers;
- (void) swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation SideSwipeTableViewController
@synthesize tableView, sideSwipeView, sideSwipeCell, sideSwipeDirection, animatingSideSwipe;

- (void)viewDidLoad
{
  [super viewDidLoad];
  animatingSideSwipe = NO;
  [self setupGestureRecognizers];
}

#pragma mark Side Swiping under iOS 4.x
- (BOOL) gestureRecognizersSupported
{
  if (!USE_GESTURE_RECOGNIZERS) return NO;
  
  // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
  // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
  return [[[[UISwipeGestureRecognizer alloc] init] autorelease] respondsToSelector:@selector(locationInView:)];
}

- (void) setupGestureRecognizers
{
  // Do nothing under 3.x
  if (![self gestureRecognizersSupported]) return;
  
  // Setup a right swipe gesture recognizer
  UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] autorelease];
  rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [tableView addGestureRecognizer:rightSwipeGestureRecognizer];

  // Setup a left swipe gesture recognizer
  UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] autorelease];
  leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [tableView addGestureRecognizer:leftSwipeGestureRecognizer];
}

// Called when a left swipe occurred
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
  [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
  [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}

// Handle a left or right swipe
- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
  if (recognizer && recognizer.state == UIGestureRecognizerStateEnded)
  {
    // Get the table view cell where the swipe occured
    CGPoint location = [recognizer locationInView:tableView];
    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:location];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // If we are already showing the swipe view, remove it
    if (cell.frame.origin.x != 0)
    {
      [self removeSideSwipeView:YES];
      return;
    }
    
    // Make sure we are starting out with the side swipe view and cell in the proper location
    [self removeSideSwipeView:NO];
    
    // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
    // then start animating in the the side swipe view
    if (cell!= sideSwipeCell && !animatingSideSwipe)
      [self addSwipeViewTo:cell direction:direction];
  }
}

#pragma mark Side Swiping under iPhone 3.x
- (void)tableView:(UITableView *)theTableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  // If we are using gestures, then don't do anything
  if ([self gestureRecognizersSupported]) return;
  
  // Get the table view cell where the swipe occured
  UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];

  // Make sure we are starting out with the side swipe view and cell in the proper location
  [self removeSideSwipeView:NO];
  
  // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
  // then start animating in the the side swipe view. We don't have access to the direction, so we always assume right
  if (cell!= sideSwipeCell && !animatingSideSwipe)
    [self addSwipeViewTo:cell direction:UISwipeGestureRecognizerDirectionRight];
}

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // If we are using gestures, then don't allow editing
  if ([self gestureRecognizersSupported])
    return NO;
  else
    return YES;
}

#pragma mark Adding the side swipe view
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{
  // Change the frame of the side swipe view to match the cell
  sideSwipeView.frame = cell.frame;

  // Add the side swipe view to the table below the cell
  [tableView insertSubview:sideSwipeView belowSubview:cell];
  
  // Remember which cell the side swipe view is displayed on and the swipe direction
  self.sideSwipeCell = cell;
  sideSwipeDirection = direction;

  CGRect cellFrame = cell.frame;
  if (PUSH_STYLE_ANIMATION)
  {
    // Move the side swipe view offscreen either to the left or the right depending on the swipe direction
    sideSwipeView.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? -cellFrame.size.width : cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
  }
  else
  {
    // Move the side swipe view to offset 0
    sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
  }

  // Animate in the side swipe view
  animatingSideSwipe = YES;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStopAddingSwipeView:finished:context:)];
  if (PUSH_STYLE_ANIMATION)
  {
    // Move the side swipe view to offset 0
    // While simultaneously moving the cell's frame offscreen
    // The net effect is that the side swipe view is pushing the cell offscreen
    sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
  }
  cell.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? cellFrame.size.width : -cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
  [UIView commitAnimations];
}

// Note that the animation is done
- (void)animationDidStopAddingSwipeView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  animatingSideSwipe = NO;
}

#pragma mark Removing the side swipe view
// UITableViewDelegate
// When a row is selected, animate the removal of the side swipe view
- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self removeSideSwipeView:YES];
  return indexPath;
}

// UIScrollViewDelegate
// When the table is scrolled, animate the removal of the side swipe view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self removeSideSwipeView:YES];
}

// When the table is scrolled to the top, remove the side swipe view
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
  [self removeSideSwipeView:NO];
  return YES;
}

// Remove the side swipe view.
// If animated is YES, then the removal is animated using a bounce effect
- (void) removeSideSwipeView:(BOOL)animated
{
  // Make sure we have a cell where the side swipe view appears and that we aren't in the middle of animating
  if (!sideSwipeCell || animatingSideSwipe) return;
  
  if (animated)
  {
    // The first step in a bounce animation is to move the side swipe view a bit offscreen
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
      if (PUSH_STYLE_ANIMATION)
        sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
      sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
      if (PUSH_STYLE_ANIMATION)
        sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
      sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    animatingSideSwipe = YES;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopOne:finished:context:)];
    [UIView commitAnimations];
  }
  else
  {
    [sideSwipeView removeFromSuperview];
    sideSwipeCell.frame = CGRectMake(0,sideSwipeCell.frame.origin.y,sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    self.sideSwipeCell = nil;
  }
}

#pragma mark Bounce animation when removing the side swipe view
    // The next step in a bounce animation is to move the side swipe view a bit on screen
- (void)animationDidStopOne:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
  {
    if (PUSH_STYLE_ANIMATION)
      sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
  }
  else
  {
    if (PUSH_STYLE_ANIMATION)
      sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
  }
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStopTwo:finished:context:)];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  [UIView commitAnimations];
}

  // The final step in a bounce animation is to move the side swipe completely offscreen
- (void)animationDidStopTwo:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  [UIView commitAnimations];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
  {
    if (PUSH_STYLE_ANIMATION)
      sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
  }
  else
  {
    if (PUSH_STYLE_ANIMATION)
      sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
  }
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStopThree:finished:context:)];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  [UIView commitAnimations];
}

// When the bounce animation is completed, remove the side swipe view and reset some state
- (void)animationDidStopThree:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  animatingSideSwipe = NO;
  self.sideSwipeCell = nil;
  [sideSwipeView removeFromSuperview];
}

- (void)viewDidUnload
{
  self.tableView = nil;
  self.sideSwipeView = nil;
}

- (void)dealloc
{
  [tableView release];
  [sideSwipeView release];
  [sideSwipeCell release];
  [super dealloc];
}

@end
