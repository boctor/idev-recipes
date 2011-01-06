Blog post: [http://idevrecipes.com/2010/12/13/wooduinavigation][]

## Problem:

Recreate the wood themed navigation bar of Apple’s [iBooks][] app.

## Solution:

First we’ll [extract the images][] from the [iBooks][] app and find
the main navigation bar image:

![image][]

Next we’ll add this wood background image as a subview of the
UINavigationBar. We add it at the bottom of the z-order so that the
buttons are drawn on top:

        UIImageView* imageView = [[[UIImageView alloc] initWithFrame:navigationController.navigationBar.frame] autorelease];
        imageView.contentMode = UIViewContentModeLeft;
        imageView.image = [UIImage imageNamed:@"NavBar-iPhone.png"];
        [navigationController.navigationBar insertSubview:imageView atIndex:0];

![image][1]

Then we replace those standard UIBarButtonItems with custom ones.
To do this we create [custom buttons with stretchable images][] we
find in the [iBooks][] app:

![image][2]

and add the custom buttons as the customView of the
UIBarButtonItems:

      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:@"Store" stretch:CapLeftAndRight]] autorelease];
      self.navigationItem.leftBarButtonItem =  [[[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:@"Edit" stretch:CapLeftAndRight]] autorelease];

![image][3]

Finally, we add a [custom segmented control][] as the titleView:

      segmentControlTitles = [[NSArray arrayWithObjects:@"Books", @"PDFs", nil] retain];
      UIImage* dividerImage = [UIImage imageNamed:@"view-control-divider.png"];
      self.navigationItem.titleView = [[[CustomSegmentedControl alloc] initWithSegmentCount:segmentControlTitles.count segmentsize:CGSizeMake(BUTTON_SEGMENT_WIDTH, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self] autorelease];

![image][4]

Our end result is nearly indistinguishable from the original:

![image][5]

Blog post: [http://idevrecipes.com/2010/12/13/wooduinavigation][]

  [http://idevrecipes.com/2010/12/13/wooduinavigation]: http://idevrecipes.com/2010/12/13/wooduinavigation
  [iBooks]: http://p.appju.mp/364709193&t=i
  [extract the images]: http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore/
  [image]: http://idevrecipes.files.wordpress.com/2010/12/navbar-iphone.png?w=320&h=44 "Wood NavBar"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/navbar_wood_bkgd.png?w=320&h=44 "Navigation Bar Wood Background"
  [custom buttons with stretchable images]: http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons/
  [2]: http://idevrecipes.files.wordpress.com/2010/12/nav-button.png?w=11&h=30 "Wood Navigation Button"
  [3]: http://idevrecipes.files.wordpress.com/2010/12/navbar_wood_buttons.png?w=320&h=44 "NavBar Wood Buttons"
  [custom segmented control]: http://idevrecipes.com/2010/12/11/custom-segmented-controls/
  [4]: http://idevrecipes.files.wordpress.com/2010/12/navbar_wood_final1.png?w=320&h=44 "Final Wood NavBar"
  [5]: http://idevrecipes.files.wordpress.com/2010/12/ibooks_navbar.png?w=320&h=44 "iBooks Nav Bar"
