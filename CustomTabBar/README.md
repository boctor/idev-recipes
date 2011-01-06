Blog post: [http://idevrecipes.com/2011/01/04/how-does-the-twitter-iphone-app-implement-a-custom-tab-bar][]

## Problem:

The [Twitter iPhone App][] has a custom tab bar that is shorter
than the standard tab bar, doesn’t have titles for the tab bar
items and has a blue glow indicating when a section has new
content. We want to recreate this custom tab bar.

![image][]

## Solution:

Just like segmented controls, the best way to customize the tab bar
is to build it from scratch. In fact we’re going to start by using
recipe similar to what we used for [custom segment controls][]:

-   Create a button for every tab bar item.
-   Manage the touches on the buttons so when one is selected, the
    others are deselected.

But how do we recreate the look of the buttons and how about that
nice background for the tab bar?

#### The tab bar background

Looking at the [images of the Twitter app][], we find the
TabBarGradient.png image which is 22px, exactly half the 44px
height of this custom tab bar.

Taking a screenshot of the Twitter app and looking at it carefully
reveals how the background is built:

-   The top half is a [stretchable image][] of TabBarGradient.png
-   The bottom half is simply solid black

The custom tab bar asks its delegate for the background image and
here is how we build it:

    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Create a new image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
    
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

#### The buttons

The buttons have the following visual states:

-   Drawn in gray when unselected
-   Drawn with blue gradient when selected
-   Embossed border is drawn around the selected item

A button has both an image and a background image and they can both
be set for the various control states. When a button is selected,
the blue gradient appears to be on top and the embossed border is
behind it. So here is how we’ll setup the button:

-   The button’s image for the normal state will be gray
-   The button’s image for the selected/highlighted state will be
    blue
-   The button’s background image for the selected/highlighted
    state will be the embossed border

**The images for the tab bar items**

A standard UITabBar only uses the alpha values of the tab bar item
images. It doesn’t matter what color the images are, they will
always appear in gray and blue. For our custom tab bar to be truly
reusable, it will need to do the same thing.

But how exactly do we do this? It takes several steps:

1.  First we take the image and use CGContextClipToMask to generate
    a new image that has a white background and black content:  
    ![image][1]
2.  Next we take this black and white image and use
    CGImageMaskCreate to create an image mask.
3.  Finally we combine the image mask with a background color.

For every tab bar item we generate two images: one with a solid
gray background and another with a blue gradient background.

**The blue glow**

The blue glow is an image that is simply added to each button as a
subview. In the Twitter app, a tab bar item will get a blue glow
after the app has downloaded new content. It is a visual cue that
there is more content in that section.

Our custom tab bar asks its delegate for the glowImage and it
exposes a couple of methods to manage the glow: glowItemAtIndex and
removeGlowAtIndex.

**The current tab bar indicator**

When a tab bar item is selected, a triangle at the top of the tab
bar animates into place. We covered this animation in an
[earlier post][]. We use the code from that post to get the same
animation for the custom tab bar.

Blog post: [http://idevrecipes.com/2011/01/04/how-does-the-twitter-iphone-app-implement-a-custom-tab-bar][]

  [http://idevrecipes.com/2011/01/04/how-does-the-twitter-iphone-app-implement-a-custom-tab-bar]: http://idevrecipes.com/2011/01/04/how-does-the-twitter-iphone-app-implement-a-custom-tab-bar
  [Twitter iPhone App]: http://p.appju.mp/333903271&t=i
  [image]: http://idevrecipes.files.wordpress.com/2011/01/customtabbar.png?w=460&h=70 "Custom Tab Bar"
  [custom segment controls]: http://idevrecipes.com/2010/12/11/custom-segmented-controls/
  [images of the Twitter app]: http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore/
  [stretchable image]: http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons/
  [1]: http://idevrecipes.files.wordpress.com/2011/01/black_and_white_mask_image.png?w=64&h=16 "Black and White Mask Image"
  [earlier post]: http://idevrecipes.com/2010/12/17/twitter-app-tab-bar-animation/
