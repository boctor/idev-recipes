Blog post: [http://idevrecipes.com/2011/01/11/how-do-iphone-apps-instagramreederdailybooth-implement-custom-navigationbars-with-variable-width-back-buttons][]

## Problem:

Apps like [Instagram][], [Reeder][] and [DailyBooth][] have a
UINavigationBar with custom background and sometimes custom back
buttons. How do we build a similar custom UINavigationBar?
![image][]![image][1]![image][2]
## Solution:

In our recipe for
**[Recreating the iBooks wood themed navigation bar][]** we added a
wood image as a subview of UINavigationBar. This worked but it
turns out that we were lucky.

If we had tried to push another view controller onto our UINavigationController
we would've ended up with a UINavigationBar that has nothing but our wood image.
This is because as the standard UINavigationBar implementation adds items,
it also then sends them to the back of its view hierarchy. So even
if we add our custom image to the bottom of the
UINavigationBar view hierarchy, the rightBarButtonItem, titleView
and leftBarButtonItem end up below the custom image and out of
sight.

#### The nav bar background

We need a new, more flexible solution: Instead of adding to a
UINavigationBar's view hierarchy we will subclass UINavigationBar.
We'll override UINavigationBar's drawRect and draw our custom
background image directly:

    // If we have a custom background image, then draw it, othwerwise call super and draw the standard nav bar
    - (void)drawRect:(CGRect)rect
    {
      if (navigationBarBackgroundImage)
        [navigationBarBackgroundImage.image drawInRect:rect];
      else
        [super drawRect:rect];
    }

Any time navigationBarBackgroundImage changes we also need to call
[self setNeedsDisplay] so the new background image is properly
drawn.

A couple of methods allow us to set or clear the background image:

    // Save the background image and call setNeedsDisplay to force a redraw
    -(void) setBackgroundWith:(UIImage*)backgroundImage
    {
      self.navigationBarBackgroundImage = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
      navigationBarBackgroundImage.image = backgroundImage;
      [self setNeedsDisplay];
    }

    // clear the background image and call setNeedsDisplay to force a redraw
    -(void) clearBackground
    {
      self.navigationBarBackgroundImage = nil;
      [self setNeedsDisplay];
    }

#### Multiple nav bar backgrounds

In most cases, you'll have a single custom background image that
you'll set once.

If you need to change the custom background more
than once, say every time the user enters a new section, then
simply call setBackgroundWith every time you want the nav bar's
background to change.

The [source code][https://github.com/boctor/idev-recipes/tree/master/CustomBackButton]for this recipe is one app with a single
UINavigationController and a table row for each of the
apps: [Instagram][], [Reeder][] and [DailyBooth][]. When you select a row, we push a view
controller that calls setBackgroundWith to set the background image
for each app.

#### Custom back button

In the [iBooks recipe][Recreating the iBooks wood themed navigation bar] we created a custom
UIBarButtonItem by creating a buttonwith a [stretchable image][] and
adding the button as the customView of UIBarButtonItem.

We do the same thing here except we use an image has an
arrow on the left side and we adjust the button's titleEdgeInsets to center the text properly.

The backButtonWith:highlight:leftCapWidth: convenience method on
our CustomNavigationBar class creates a back button which we can
then add as the leftBarButtonItem. This replaces the built in back
button.

To resize our custom back button to match width of the
text, we use UILabel's sizeWithFont to measure the width of the
text and resize the button appropriately.

#### Trying it out

Just like the standard back bar button implementation,
the CustomNavigationBar will set the title of the back button to
the title of the previous controller on the UINavigationController
stack.

The [source code][] for this recipe also lets you
dynamically change the back button text after a view controller is
pushed onto the UINavigationController stack. The back button
resizes as needed and you get to see and experiment with different
text and button widths.

Blog post: [http://idevrecipes.com/2011/01/11/how-do-iphone-apps-instagramreederdailybooth-implement-custom-navigationbars-with-variable-width-back-buttons][]

  [https://github.com/boctor/idev-recipes/tree/master/CustomBackButton]: https://github.com/boctor/idev-recipes/tree/master/CustomBackButton
  [Instagram]: http://p.appju.mp/389801252&t=i
  [Reeder]: http://p.appju.mp/325502379&t=i
  [DailyBooth]: http://p.appju.mp/381470756&t=i
  [image]: http://idevrecipes.files.wordpress.com/2011/01/instagram.png "Instagram"
  [1]: http://idevrecipes.files.wordpress.com/2011/01/reeder.png "Reeder"
  [2]: http://idevrecipes.files.wordpress.com/2011/01/dailybooth.png "DailyBooth"
  [Recreating the iBooks wood themed navigation bar]: http://idevrecipes.com/2010/12/13/wooduinavigation/
  [stretchable image]: http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons/
  [source code]: https://github.com/boctor/idev-recipes/tree/master/CustomBackButton
