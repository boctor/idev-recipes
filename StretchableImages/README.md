Blog post: [http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons][]

## Problem:

Images for your iOS apps are too big. You’re creating variations of
the same image that only differ in width.

## Solution:

A great way to reduce the size of images and reuse images is to use
stretchable images.

Smaller image sizes reduce the app size and users will have to wait
less for the app to download from the AppStore.

Smaller images also <a   >reduce your app’s memory footprint</a>:

> Make resource files as small as possible.  
> Files reside on the disk but must be loaded into memory before they
> can be used; compress all image files to make them as small as
> possible.

A stretchable image has 3 parts: A left cap, a one pixel
stretchable area and a right cap.  
Keith Peters over at [Bit-101][] has a great
[image showing this in action][]:

![image][]

These images when scaled or resized will draw both caps on either
side and repeat the middle pixel.

The most common ways to use stretchable images are:

**An entire image stretched by using a 1 pixel wide source image**

For example this simple 1 pixel wide image:

![image][1]

    UIImage* image = [[UIImage imageNamed:@"1-pixel-image.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]

If we then use this image in a 300 pixel wide image view:

    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.frame = CGRectMake(0, 0, 300.0, image.size.height);

we get this image:

![image][2]

**An image stretched with equal right and left caps**

The source image needs to contain both caps with an extra pixel in
the middle. So for example this image is 11 pixels wide, 5 pixels
for each cap and a 1 pixel stretchable area in the middle:

![image][3]

    UIImage* buttonImage =[[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0]

results in this image when used in a 300 pixel wide image view:

    UIImageView* imageView = [[UIImageView alloc] initWithImage:buttonImage];
    imageView.frame = CGRectMake(0, 0, 300.0, buttonImage.size.height);

![image][4]

If we create two images then we can set the background image of a
button for the normal and highlighted states and get some very nice
looking buttons using very small images.

Blog post: [http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons][]

  [http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons]: http://idevrecipes.com/2010/12/08/stretchable-images-and-buttons
  [Bit-101]: http://www.bit-101.com/
  [image showing this in action]: http://www.bit-101.com/blog/?p=2275
  [image]: http://idevrecipes.files.wordpress.com/2010/12/stretchable.png?w=300&h=300 "stretchableImageWithLeftCapWidth"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/1-pixel-image.png?w=1&h=30 "1 pixel wide image"
  [2]: http://idevrecipes.files.wordpress.com/2010/12/stretched_image.png?w=300&h=30 "Stretched Image"
  [3]: http://idevrecipes.files.wordpress.com/2010/12/button.png?w=11&h=30 "button"
  [4]: http://idevrecipes.files.wordpress.com/2010/12/stretched_button.png?w=300&h=30 "Stretched Button"
