Blog post: [http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore][]

To recreate features of existing apps, we can use a big clue: the
images an app uses. This will often give us insight into how the
feature was built.

You can right click on an App in iTunes and see the app’s .ipa
file.

![image][]

An .ipa file is just a zip file that is easily expanded resulting
in a Payload folder that has the actual .app.

![image][1]

But we can’t just double click on the images and open them in
something like Preview.app.

![image][2]

During app compilation Xcode optimizes all images so they aren’t
readable by standard tools like Preview.app.

We need to undo the optimization and restore the images back to
their original form.

The tool that the SDK uses to optimize the images is [pngcrush][]
and starting with the 3.2 SDK,
[Apple added the ‘revert-iphone-optimizations’ option to undo this optimization][].

I wrote a quick ruby script called [appcrush][] that automates this
process.

Point appcrush at an .ipa file from the iTunes AppStore and it:

-   expands the zip file
-   finds all the images
-   runs pngcrush with the revert-iphone-optimizations option on
    each image

    `appcrush '/Users/boctor/Music/iTunes/Mobile Applications/iBooks.ipa'`

Blog post: [http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore][]

  [http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore]: http://idevrecipes.com/2010/12/06/extracting-images-from-apps-in-the-appstore
  [image]: http://idevrecipes.files.wordpress.com/2010/12/ibooksfinder.png?w=239&h=119 "Find iBooks app in iTunes"
  [1]: http://idevrecipes.files.wordpress.com/2010/12/ibookspayload.png?w=272&h=250 "iBooks Payload"
  [2]: http://idevrecipes.files.wordpress.com/2010/12/ibooksimages.png?w=300&h=220 "iBooks Optimized Images"
  [pngcrush]: http://pmt.sourceforge.net/pngcrush/index.html
  [Apple added the ‘revert-iphone-optimizations’ option to undo this optimization]: http://developer.apple.com/library/ios/#qa/qa2010/qa1681.html
  [appcrush]: https://github.com/boctor/idev-recipes/tree/master/Utilities/appcrush
