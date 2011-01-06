Blog post: [http://idevrecipes.com/2010/12/11/custom-segmented-controls][]

## Problem:

UISegmentedControls have only four styles, each with preset heights and colors that you
can’t change. How do you create a custom segmented control?

![image][]

<span >Solution:</span>

[The Apple docs say][]:

> A UISegmentedControl object is a horizontal control made of
> multiple segments, each segment functioning as a discrete button

In other words a UISegmentedControl is simply a group of buttons.
To create a custom segmented control we can use a simple recipe:

-   Create a custom view that manages a button for each segment.
-   Use a divider image to visually separate segments.
-   Manage the touches on the buttons so when one is selected, the
    others are deselected.

We need to also figure out the proper appearance of each button but
there are at least two ways to make the images for the buttons:

-   Use stretchable images to [create nice looking buttons][].
-   Create fancier static images in Photoshop that are the exact
    width.

Instead of having the implementation dictate one way, we’ll use a
delegate callback so each instance of the custom control can decide
how to build the buttons. The delegate also has optional callbacks
to get notified when a touch up or touch down occurs on one of the
segments. This will be were we takes actions like swapping out
views when a user selects a segment.

[CustomSegmentedControl.h][]

    @protocol CustomSegmentedControlDelegate
    
    - (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
    
    @optional
    - (void) touchUpInsideSegmentIndex:(NSUInteger)segmentIndex;
    - (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex;
    @end
    
    @interface CustomSegmentedControl : UIView
    {
    NSObject <CustomSegmentedControlDelegate> *delegate;
    NSMutableArray* buttons;
    }
    
    @property (nonatomic, retain) NSMutableArray* buttons;
    
    - (id) initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage*)dividerImage tag:(NSInteger)objectTag delegate:(NSObject <CustomSegmentedControlDelegate>*)customSegmentedControlDelegate;

You can see the full source for [CustomSegmentedControl.m][] as
well as a sample app showing the custom control in action.

![image][1]

Blog post: [http://idevrecipes.com/2010/12/11/custom-segmented-controls][]

  [http://idevrecipes.com/2010/12/11/custom-segmented-controls]: http://idevrecipes.com/2010/12/11/custom-segmented-controls
  [image]: http://idevrecipes.files.wordpress.com/2010/12/uisegmentedcontrol.png?w=247&h=277 "UISegmentedControl styles"
  [The Apple docs say]: http://developer.apple.com/library/ios/documentation/uikit/reference/UISegmentedControl_Class/Reference/UISegmentedControl.html
  [create nice looking buttons]: http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons/
  [CustomSegmentedControl.h]: https://github.com/boctor/idev-recipes/blob/master/CustomSegmentedControls/Classes/CustomSegmentedControl.h
  [CustomSegmentedControl.m]: https://github.com/boctor/idev-recipes/blob/master/CustomSegmentedControls/Classes/CustomSegmentedControl.m
  [1]: http://idevrecipes.files.wordpress.com/2010/12/customsegmentedcontrol.png?w=302&h=47 "CustomSegmentedControl"
