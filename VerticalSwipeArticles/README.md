Blog post:
[http://idevrecipes.com/2010/12/28/how-does-the-reeder-iphone-app-swipe-up-and-down-between-articles][]

## Problem:

The [Reeder iPhone App][] lets you pull up to see the title of the
next article. If you pull up far enough the arrow rotates and the
next article animates into view. We want to recreate this UI.

![image][]

## Solution:

If you don’t pull up far enough, the article bounces back into view
and that is a very strong clue that we are dealing with a
UIScrollView.

A UIScrollView is used to display content that is larger than the
application’s window. You tell it the contentSize of your content
and it manages scrolling within the content. When you get to the
edge of the content, the scroll view bounces to let you know you’ve
reached the edge.

#### The header and footer views

Normally when you pull up at the edge of a scroll view empty space
appears, but in the Reeder app, the title of the next article
appears along with an arrow. To recreate this we’ll create a scroll
view with a contentSize that is the same as the scroll view. Then
we’ll tell the scroll view to alwaysBounceVertical. This causes a
view that bounces vertically when you pull up or down.

Next we’ll add a header view as the subview of the scroll view and
set it’s frame to be right above the scroll view and we’ll add a
footer view as the subview of the scroll view and set it’s frame to
be right below the scroll view. The header and footer are offscreen
but when you pull up or down, they get pulled into view.

#### Subclassing UIScrollView

In addition to trying to figure out how to recreate the feature, we
need to also figure out how to structure our code. The most
reusable part of this feature is the ability to swipe up and down
to see another article while seeing a preview of the previous/next
article. We’ve already determined that we’ll be using a scroll view
that we’ve customized so it seems logical that we would create a
subclass of UIScrollView.

#### Animating the header and footer views

The arrows in the header and footer rotate to let the user know
that when they lift their finger, the previous/next article will be
shown. When the view has been scrolled past some distance we need
to trigger this arrow rotation.

To accomplish this we will listen to the UIScrollViewDelegate’s
scrollViewDidScroll message and check the scroll view’s
contentOffset. This means that our UIScrollView subclass will have
itself as its delegate. This sounds odd but works just fine.

Our subclass will send out 4 messages:

-   headerLoadedInScrollView
-   headerUnloadedInScrollView
-   footerLoadedInScrollView
-   footerUnloadedInScrollView

A header/footer is loaded when the user pulls down or up past the
height of the header/footer. It is unloaded when they pull back and
hide part of the header/footer. So with one arrow image, this is
how we animate the arrow rotation:

    - (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
    {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.2];
      imageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(angle));
      [UIView commitAnimations];
    }
    -(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
    {
      [self rotateImageView:headerImageView angle:0];
    }
    
    -(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
    {
      [self rotateImageView:headerImageView angle:180];
    }
    
    -(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
    {
      [self rotateImageView:footerImageView angle:180];
    }
    
    -(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
    {
      [self rotateImageView:footerImageView angle:0];
    }

#### Animating the previous and next page

The UIScrollViewDelegate’s scrollViewDidEndDragging message lets us
know when the user has lifted their finger after dragging. To
animate the next page, we place the page below the footer and
inside of an animation block place it on screen. This results in a
nice up animation.

    if (_footerLoaded) // If the footer is loaded, then the user wants to go to the next page
    {
      // Ask the delegate for the next page
      UIView* nextPage = [externalDelegate viewForScrollView:self atPage:currentPageIndex+1];
      // We want to animate this new page coming up, so we first
      // Set its frame to the bottom of the scroll view
      nextPage.frame = CGRectMake(0, nextPage.frame.size.height + self.contentOffset.y, self.frame.size.width, self.frame.size.height);
      [self addSubview:nextPage];
    
      // Start the page up animation
      [UIView beginAnimations:nil context:nextPage];
      [UIView setAnimationDuration:0.2];
      [UIView setAnimationDelegate:self];
      [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
      // When the animation is done, we want the next page to be front and center
      nextPage.frame = self.frame;
      // We also want the existing page to animate to the top of the scroll view
      currentPageView.frame = CGRectMake(0, -(self.frame.size.height + headerView.frame.size.height), self.frame.size.width, self.frame.size.height);
      // And we also animate the footer view to animate off the top of the screen
      footerView.frame = CGRectMake(0, -footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
      [UIView commitAnimations];
    
      // Increment our current page
      currentPageIndex++;
    }

We also register a callback for when this animation is done and
make sure our header and footer are in place for the next time the
user pulls the scroll view up or down.

#### UIWebViews are unique

Our UIScrollView subclass calls the delegate’s
viewForScrollView:atPage to get the actual pages. Life would be
simple if we could return a static page like say an image, but in
the real world it is more likely that you will be returning a
UIWebView to accommodate things like titles that may wrap.

[The sample app][] uses a JSON feed of the top paid apps in the App
Store and uses a UIWebView to display each page.

No matter how simple the html that you are displaying in a
UIWebView, the rendering will not be instantaneous and there will
always be an overhead of setting up the UIWebView. If every time
viewForScrollView:atPage is called you created a new UIWebView with
html, then as this page is getting animated into view, the
rendering will not have completed. The net result will be that the
scroll animation will show a blank white page instead of the actual
content.

To deal with this the sample app keeps around a previousPage and
nextPage UIWebViews. When asked for page 1, the sample preloads
previousPage with page 0 and nextPage with page 2. If there are
other caching techniques you think would work here, please share
your thoughts in the comments.

Blog post:
[http://idevrecipes.com/2010/12/28/how-does-the-reeder-iphone-app-swipe-up-and-down-between-articles][]

  [Reeder iPhone App]: http://p.appju.mp/325502379&t=i
  [image]: http://idevrecipes.files.wordpress.com/2010/12/reeder_app.jpg?w=460&h=690 "Reeder App"
  [The sample app]: https://github.com/boctor/idev-recipes/tree/master/VerticalSwipeArticles
  [http://idevrecipes.com/2010/12/28/how-does-the-reeder-iphone-app-swipe-up-and-down-between-articles]: http://idevrecipes.com/2010/12/28/how-does-the-reeder-iphone-app-swipe-up-and-down-between-articles
