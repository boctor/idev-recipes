Blog post: [http://idevrecipes.com/2011/03/08/how-does-the-instagram-iphone-app-implement-a-custom-tab-bar-notification][]

## Problem:

When the [Instagram][] app wants to let you know that you have new
comments, likes or followers, it doesn’t use standard badge values on
tab bar items: ![image][] Instead it uses a custom tab bar notification
view. How do we build a similar custom notification view? ![image][1]
## Solution:

Just like in our recipe for the **[Twitter app’s current tab bar
indicator][]** we will add a view on top of the tab bar to notify the
user. Instead of a static image, we will add a slightly more complicated
view. This view has the background, icons for each of the activities
(comments, likes, followers), and labels with the number value of each
of these activities. Here is what looks like laid out in the NIB:
![image][2]
#### Vertical/Horizontal Location

Again we need to figure out the horizontal and vertical location of our
custom view and we essentially do the same thing we did in our Twitter
tab bar indicator recipe: To calculate the vertical location, we start
at the bottom of the window, go up by height of the tab bar, go up again
by the height of the notification view and then go up another 2 pixels
so our view is slightly above the tab bar. For the horizontal location
we divide the width of the tab bar by the number of items to calculate
the width of a single item. We then multiply the index by the width of
single item and add half the width of an item to land in the middle.
#### Showing/Hiding the custom notification view

In a real app we would hit a web service, get the data and then notify
the user by showing the custom notification UI. In the sample app we
have a couple of buttons that show and hide the notification view. We
also do a very simple fade in/fade out animation of the notification
view. Showing the custom notification view:

    - (void) showNotificationViewFor:(NSUInteger)tabIndex
    {
      // To get the vertical location we start at the bottom of the window, go up by height of the tab bar and go up again by the notification view
      CGFloat verticalLocation = self.view.window.frame.size.height - self.tabBar.frame.size.height - notificationView.frame.size.height - 2.0;
      notificationView.frame = CGRectMake([self horizontalLocationFor:tabIndex], verticalLocation, notificationView.frame.size.width, notificationView.frame.size.height);

      if (!notificationView.superview)
        [self.view.window addSubview:notificationView];

      notificationView.alpha = 0.0;

      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.5];
      notificationView.alpha = 1.0;
      [UIView commitAnimations];
    }


Hiding the custom notification view:

    - (IBAction)hideNotificationView:(id)sender
    {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.5];
      notificationView.alpha = 0.0;
      [UIView commitAnimations];
    }

In the end the solution is quite simple: A custom view laid out in a NIB, added to the
view hierarchy at the right location. But it definitely looks sexier
that the built in red badge. What do you think? Can you make this code
better? Let us know in the comments of our blog post!

Blog post: [http://idevrecipes.com/2011/03/08/how-does-the-instagram-iphone-app-implement-a-custom-tab-bar-notification][]

  [http://idevrecipes.com/2011/03/08/how-does-the-instagram-iphone-app-implement-a-custom-tab-bar-notification]: http://idevrecipes.com/2011/03/08/how-does-the-instagram-iphone-app-implement-a-custom-tab-bar-notification
  [Instagram]: http://p.appju.mp/389801252?t=i
  [image]: http://idevrecipes.files.wordpress.com/2011/03/uitabbaritem_badgevalue.png
    "UITabBarItem_badgeValue"
  [1]: http://idevrecipes.files.wordpress.com/2011/03/instagram_custom_tabbar_notification.jpg
    "Instagram_Custom_TabBar_Notification"
  [Twitter app’s current tab bar indicator]: http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation/
  [2]: http://idevrecipes.files.wordpress.com/2011/03/instagram_custom_tabbar_notification_nib.png
    "Instagram_Custom_TabBar_Notification_NIB"
