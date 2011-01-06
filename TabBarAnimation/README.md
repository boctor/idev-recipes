Blog post: [http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation][]

## Problem:

The [Twitter iPhone App][] has a small arrow indicator above the
tab bar that animates when a tab is selected. We want to recreate
this animation.

![image][]  
![image][1]  
![image][2]  
![image][3]  
![image][4]

## Solution:

The arrow is simply another image added on top of the tab bar which
is animated every time the tab selection changes. So we have two
tasks:

-   Add the arrow on top of the tab bar. This is similar to what we
    did in our [last recipe][].
-   Animate the arrow when a new tab is selected.

To add arrow on top of the tab, we have to figure out the proper
horizontal and vertical locations.

#### Vertical Location

The vertical location is always the same so we’ll figure it out
just once. To calculate the vertical location, we start at the
bottom of the window, go up by height of the tab bar, go up again
by the height of arrow and then come back down 2 pixels so the
arrow is slightly on top of the tab bar:

    CGFloat verticalLocation = self.window.frame.size.height - tabBarController.tabBar.frame.size.height - tabBarArrowImage.size.height + 2;

#### Horizontal Location

The horizontal location will change depending on which tab bar is
currently selected. So we’ll write a method that given a tab index
figures out the horizontal location.  
There is nothing too complicated here: We divide the width of the
tab bar by the number of items to calculate the width of a single
item. We then multiply the index by the width of single item and
add half the width of an item so the arrow lands in the middle:

    - (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
    {
      // A single tab item's width is the entire width of the tab bar divided by number of items
      CGFloat tabItemWidth = tabBarController.tabBar.frame.size.width / tabBarController.tabBar.items.count;
      // A half width is tabItemWidth divided by 2 minus half the width of the arrow
      CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
      // The horizontal location is the index times the width plus a half width
      return (tabIndex * tabItemWidth) + halfTabItemWidth;
    }

#### Add the arrow on top of the tab bar

On app startup we add the arrow on top of the selected tab. Our
sample app doesn’t remember which tab you had selected before you
quit, so we always start at index 0 ([self
horizontalLocationFor:0]):

    - (void) addTabBarArrow
    {
      UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple.png"];
      self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
      // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
      CGFloat verticalLocation = self.window.frame.size.height - tabBarController.tabBar.frame.size.height - tabBarArrowImage.size.height + 2;
      tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    
      [self.window addSubview:tabBarArrow];
    }

#### Animate the arrow when a new tab is selected

A UITabBarController delegate gets notified every time a view
controller was selected. We’ll use this as the trigger for starting
the animation.

The actual animation is very simple. We use animation blocks
available on every view.

If you haven’t used animation blocks before, here is a simple
description:

-   Before you start the animation block set the frame of the item
    you want to animate to the start location.
-   Inside the animation block set the frame of the item you want
    to animate to the end location.

That’s all you have to do. The OS figures out the intermediate
frames and does the actual animation for you. Doesn’t get simpler
than that.

The arrow is already at the location we want it to animate from, so
we don’t have to do anything before we start the animation block.

Inside the animation block block, all we have to do is set the
final location of the arrow. So we take the existing frame of the
arrow and change its horizontal location based on the newly
selected tab index:

    - (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
    {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.2];
      CGRect frame = tabBarArrow.frame;
      frame.origin.x = [self horizontalLocationFor:tabBarController.selectedIndex];
      tabBarArrow.frame = frame;
      [UIView commitAnimations];
    }

There a couple of things you can play around with to customize the
animation:

-   The value you pass to setAnimationDuration will speed up or
    slow down the animation.
-   You can also set an animation curve. The default curve is
    UIViewAnimationCurveEaseInOut which causes the animation to start
    slowly, get faster in the middle and then slow before the animation
    is complete. Other curves like UIViewAnimationCurveEaseIn cause the
    animation to start slowly and then get faster until completion.

Blog post: [http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation][]

  [http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation]: http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation
  [Twitter iPhone App]: http://p.appju.mp/333903271&t=i
  [image]: http://idevrecipes.files.wordpress.com/2010/12/twitter_1.png?w=320&h=48 "First Frame"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/twitter_2.png?w=320&h=48 "Second Frame"
  [2]: http://idevrecipes.files.wordpress.com/2010/12/twitter_3.png?w=320&h=48 "Third Frame"
  [3]: http://idevrecipes.files.wordpress.com/2010/12/twitter_4.png?w=320&h=48 "Fourth Frame"
  [4]: http://idevrecipes.files.wordpress.com/2010/12/twitter_5.png?w=320&h=48 "Fifth Frame"
  [last recipe]: http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button/
