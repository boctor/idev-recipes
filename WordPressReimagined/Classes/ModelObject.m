//
//  ModelObject.m
//  WordPressReimagined
//
//  Created by Peter Boctor on 3/17/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "ModelObject.h"
#import "WordPressReimaginedAppDelegate.h"
#import "CustomTabBarViewController.h"
#import "ModelObject.h"

@interface ModelObject (Private)
- (void) updateVisibleCellsWithImage;
- (NSArray*) getCorrespondingVisibleCells;
@end

@implementation ModelObject
@synthesize attributes;
@synthesize image, imageData, imageConnection, imageURLKey, genericImageName, verticalOffsetKey;
@synthesize uniqueIdentifierKey;

- (id) initWithAttributes:(NSDictionary*)theAttributes
{
  if (self = [super init])
  {
    self.attributes = theAttributes;
  }

  return self;
}

- (id)objectForKey:(id)key
{
  return [attributes objectForKey:key];
}

-(void) useGenericImage
{
  self.image = [UIImage imageNamed:genericImageName];
}

-(void) startDownloadingImageIfNeeded
{
  // if we already have an image or are in the middle of downloading the image
  if (image || imageConnection) return;
  
  NSString* imageURL = [attributes objectForKey:imageURLKey];
    
  if ([imageURL isKindOfClass:[NSNull class]])
  {
    [self useGenericImage];
    [self updateVisibleCellsWithImage];
  }
  else if (imageURL.length > 0)
  {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    self.imageConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (imageConnection)
      self.imageData = [NSMutableData data];
  }
}

-(void) cancelDownloadingImage
{
  [imageConnection cancel];
  [imageData release], imageData = nil;
  [imageConnection release], imageConnection = nil;
}

- (void) updateVisibleCellsWithImage
{
  for (UIImageView* imageView in [self getCorrespondingVisibleCells])
  {
    imageView.image = image;
    [self adjustImageVerticallyUsing:imageView];
  }
}

-(void) adjustImageVerticallyUsing:(UIImageView*)imageView
{
  CGFloat yOffset = [[attributes objectForKey:verticalOffsetKey] floatValue];

  imageView.frame = CGRectMake(0,yOffset,image.size.width, image.size.height);
}

- (void)handleFailedImageDownload
{
  [self useGenericImage];
  [self updateVisibleCellsWithImage];
  [self cancelDownloadingImage];
}

-(NSArray*) getCorrespondingVisibleCells
{
  UINavigationController *navigationController = ((WordPressReimaginedAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController;
  CustomTabBarViewController* customTabBarViewController = [navigationController.viewControllers objectAtIndex:0];
  UIViewController* selectedViewController = customTabBarViewController.selectedViewController;
  // if ([customTabBarViewController.selectedViewController isKindOfClass:[UINavigationController class]])
  // {
  //   UINavigationController* navController = (UINavigationController*)customTabBarViewController.selectedViewController;
  //   selectedViewController = navController.topViewController;
  // }
  // else
  //   selectedViewController = customTabBarViewController.selectedViewController;
  
  if ([selectedViewController respondsToSelector:@selector(visibleTable)])
  {
    UITableView* tableView = [(UITableView*)selectedViewController performSelector:@selector(visibleTable)];
  
    NSArray* visibleCells = tableView.visibleCells;
  
    if (!visibleCells)
      return nil;
  
    NSMutableArray* cells = [[[NSMutableArray alloc] init] autorelease];
    for (UITableViewCell* cell in visibleCells)
    {
      if ([cell respondsToSelector:@selector(modelObject)])
      {
        ModelObject* modelObject = [(ModelObject*) cell performSelector:@selector(modelObject)];
        if ([modelObject isEqual:self])
          [cells addObject:cell.imageView];
      }
    }

    if (cells.count > 0)
      return cells;
  }
  
  // if ([navigationController.topViewController respondsToSelector:@selector(defferedDownloadImageView)] && [navigationController.topViewController respondsToSelector:@selector(defferedDownloadModelObject)])
  // {
  //   RailsObject* railsObject = [navigationController.topViewController performSelector:@selector(defferedDownloadModelObject)];
  //   if ([railsObject isEqual:self])
  //     return [NSArray arrayWithObject:[navigationController.topViewController performSelector:@selector(defferedDownloadImageView)]];
  // }
  
  return nil;
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSInteger status = [(NSHTTPURLResponse*)response statusCode];
  
  if (status != 200)
  {
    if (connection == imageConnection)
      [self handleFailedImageDownload];
  }
  
  if (connection == imageConnection)
    [imageData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if (connection == imageConnection)
    [imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  if (connection == imageConnection)
    [self handleFailedImageDownload];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  if (connection == imageConnection)
  {
    UIImage* theImage = [[[UIImage alloc] initWithData:imageData] autorelease];
    [imageData release], imageData = nil;
    [imageConnection release], imageConnection = nil;
    
    if (theImage.size.height > 0 && theImage.size.width > 0)
        self.image = theImage;
    else
      [self useGenericImage];
    
    [self updateVisibleCellsWithImage];
  }
}

- (BOOL)isEqual:(ModelObject*)otherObject
{
  if (![otherObject isKindOfClass:[ModelObject class]]) return NO;
  
  return [[self objectForKey:uniqueIdentifierKey] isEqual:[otherObject objectForKey:uniqueIdentifierKey]];
}

- (void)dealloc
{
  [attributes release];
  [image release];
  [imageData release];
  [imageConnection release];
  [imageURLKey release];
  [genericImageName release];
  [verticalOffsetKey release];
  [uniqueIdentifierKey release];

  [super dealloc];
}

@end

