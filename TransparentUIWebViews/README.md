Blog post: [http://idevrecipes.com/2010/12/03/transparent-uiwebviews][]

## Problem:

UIWebViews have a built in gradient at the top and bottom.

If you set the UIWebView’s background color to clearColor, this
gradient is still visible.

![image][]

How can we turn off this gradient to make the UIWebView completely
transparent?

## Solution:

The UIWebView API doesn’t expose this gradient, but we can be
sneaky and look at it’s view hierarchy.

If we put a breakpoint in the debugger where we have access to a
UIWebView then in the console’s gdb prompt, we can take a look at
the view hierarchy:

    (gdb) po [webView recursiveDescription]
    <UIWebView: 0x68220e0; frame = (0 0; 320 460); >
    | <UIScrollView: 0x4b2bee0; frame = (0 0; 320 460); >
    |    | <UIImageView: 0x4b2dca0; frame = (0 0; 54 54); >
    |    | <UIImageView: 0x4b2da20; frame = (0 0; 54 54); >
    |    | <UIImageView: 0x4b2d9c0; frame = (0 0; 54 54); >
    |    | <UIImageView: 0x4b12030; frame = (0 0; 54 54) >
    |    | <UIImageView: 0x4b11fd0; frame = (-14.5 14.5; 30 1); >
    |    | <UIImageView: 0x4b11f70; frame = (-14.5 14.5; 30 1); >
    |    | <UIImageView: 0x4b11f10; frame = (0 0; 1 30); >
    |    | <UIImageView: 0x4b11eb0; frame = (0 0; 1 30); >
    |    | <UIImageView: 0x4b11e50; frame = (0 430; 320 30); >
    |    | <UIImageView: 0x4b2d0c0; frame = (0 0; 320 30);  >
    |    | <UIWebBrowserView: 0x6005800; frame = (0 0; 320 460); >

So a UIScrollView contains a UIBrowserView filling up the UIWebView
which we can assume is the actual web view and then a bunch of
UIImageViews at the top and bottom are used to show the gradients.
So how do we hide them?

This hierarchy may well change in future iOS versions, so the less
assumptions we make the better. We shouldn’t assume that there is a
UIScrollView with embedded UIImageViews, but we do have to make at
least one assumption: That the only UIImageViews are the ones used
for the gradients.

So how do we find all the UIImageViews and hide them? A view can
contain any number of subviews, so we need to walk the view
hierarchy and hide any UIImageViews we find. To be safe, we should
do this before we load the UIWebView with any content.

    - (void)viewDidLoad
    {
      [super viewDidLoad];
      [webView setBackgroundColor:[UIColor clearColor]];
      [self hideGradientBackground:webView];
    }
    
    - (void) hideGradientBackground:(UIView*)theView
    {
      for (UIView* subview in theView.subviews)
      {
        if ([subview isKindOfClass:[UIImageView class]])
          subview.hidden = YES;
    
        [self hideGradientBackground:subview];
    }

![image][1]

If you think think this is something that Apple should provide an
API for, then please fill out an enhancement request at
[http://bugreport.apple.com][]

Blog post: [http://idevrecipes.com/2010/12/03/transparent-uiwebviews][]

  [http://idevrecipes.com/2010/12/03/transparent-uiwebviews]: http://idevrecipes.com/2010/12/03/transparent-uiwebviews
  [image]: http://idevrecipes.files.wordpress.com/2010/12/uiwebview_gradient11.png?w=320&h=222 "UIWebView with gradient"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/uiwebview_no_gradient11.png?w=320&h=222 "UIWebView without gradient"
  [http://bugreport.apple.com]: http://bugreport.apple.com
