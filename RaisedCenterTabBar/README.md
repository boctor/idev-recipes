Blog post: [http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button][]

## Problem:

Apps like [Instagram][], [DailyBooth][] and [Path™][] have what
looks like a standard UITabBarController, but the center tab bar is
raised or colored. How do we recreate this look?

![image][]
![image][1]
![image][2]

## Solution:

These tab bars look pretty standard with the exception of the
center item, so we’ll start out with a standard UITabBarController
which contains a UITabBar.

Looking at [the images][] inside each app, it is quickly apparent
that the middle tab bar is simply a custom UIButton.

A UITabBar contains an array of UITabBarItems, which inherit from
UIBarItem. But unlike UIBarButtonItem that also inherits from
UIBarItem, there is no API to create a UITabBarItem with a
customView.

So instead of trying to create a custom UITabBarItem, we’ll just
create a regular one and then put the custom UIButton on top of the
UITabBar.

Our basic recipe is then to create a subclass of UITabBarController
and add a custom UIButton on top of the UITabBar.

If the button is the same height as the UITabBar, then we set the
center of the button to the center of the UITabBar. If the button
is slightly higher, then we do the the same thing except we adjust
the center’s y value to account for the difference in height.

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
      button.center = self.tabBar.center;
    else
    {
      CGPoint center = self.tabBar.center;
      center.y = center.y - heightDifference/2.0;
      button.center = center;
    }
    
    [self.view addSubview:button];

You might notice that in the code we don’t add the button as a
subview in viewDidLoad. This is because we have our
UITabBarControllers within a UINavigationController. When
viewDidLoad is called, our UITabBarController’s view is the entire
height of the screen. If we add the button as a subview in
viewDidLoad we’d have to manually account for the navigation bar or
properly setup the button’s autoresizingMask both of which
complicate the code. But after the UITabBarController is pushed
onto the UINavigationController stack, the UITabBarController’s
view is auto resized to account for the navigation bar. So we delay
adding the button as a subview until the UITabBarController’s has
been pushed onto the UINavigationController stack. We do this by
registering for the navigationController’s willShowViewController
callback.

Blog post: [http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button][]

  [http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button]: http://idevrecipes.com/2010/12/16/raised-center-tab-bar-button
  [Instagram]: http://p.appju.mp/389801252&t=i
  [DailyBooth]: http://p.appju.mp/381470756&t=i
  [Path™]: http://p.appju.mp/403639508&t=i
  [image]: http://idevrecipes.files.wordpress.com/2010/12/path.png?w=460&h=70 "Path™"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/instagram.png?w=460&h=84 "Instagram"
  [2]: http://idevrecipes.files.wordpress.com/2010/12/dailybooth.png?w=460&h=94 "DailyBooth"
  [the images]: http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore/
