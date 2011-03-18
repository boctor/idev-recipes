//
//  BaseTableViewController.m
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

#import "BaseTableViewController.h"
#import "JSONKit.h"
#import "ModelObject.h"
#import "BaseTableViewCell.h"
#import "WordPressReimaginedAppDelegate.h"
#import "CustomTabBarViewController.h"
#import "MorePagesTableViewCell.h"

@interface BaseTableViewController (PrivateMethods)
- (void) parseJSONResult;
- (void) populateTable;
- (void) loadCollection;
- (NSString*) getCollectionURL;
- (void) populate:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@end

@implementation BaseTableViewController
@synthesize tableView, tableViewCell;
@synthesize collection, collectionConnection, collectionData;
@synthesize nextPage;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
  {
    self.nextPage = 1;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (collection.count == 0)
  {
    [self showLoading];
    [self loadCollection];
  }
}

- (void) loadCollection
{
  NSString* collectionURL = [self getCollectionURL];

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:collectionURL]];
  self.collectionConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
  if (self.collectionConnection)
    self.collectionData = [NSMutableData data];
  else
    [self defaultErrorMessage];
}

#pragma mark BaseLoadingViewController
- (CGPoint) centerForLoading
{
  CustomTabBarViewController *customTabBarViewController = [((WordPressReimaginedAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController.viewControllers objectAtIndex:0];
  return CGPointMake(self.view.frame.size.width/2,  (self.view.frame.size.height - customTabBarViewController.tabBar.frame.size.height)/2);
}

- (void) prepareForLoadingOrMessage
{
  tableView.hidden = YES;
}

#pragma mark NSURLConnectionDelegate
- (void) cancelConnection:(NSURLConnection*) connection
{
  if (connection == collectionConnection)
  {
    [collectionConnection cancel];
    self.collectionConnection = nil;
    self.collectionData = nil;
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSInteger status = [(NSHTTPURLResponse*)response statusCode];

  if (status != 200)
  {
    if (connection == collectionConnection)
    {
      [self defaultErrorMessage];
      [self cancelConnection:connection];
    }
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if (connection == collectionConnection)
    [collectionData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  if (connection == collectionConnection)
  {
    [self defaultErrorMessage];
    [self cancelConnection:connection];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  if (connection == collectionConnection)
  {
    [self parseJSONResult];
    [self cancelConnection:connection];
  }
}

- (void) populateTable
{
  [self hideLoading];
  tableView.hidden = NO;
  [tableView reloadData];
}

- (void) parseJSONResult
{
  NSString* resultString = [[[NSString alloc] initWithData:collectionData encoding:NSUTF8StringEncoding] autorelease];

  NSArray* result = nil;
  @try {
    result = [resultString objectFromJSONString];
  }
  @catch (NSException * e) {
  }

  if (!result)
  {
    [self defaultErrorMessage];
    return;
  }

  NSMutableArray* modelObjectResults = [[[NSMutableArray alloc] init] autorelease];
  for (NSDictionary* attributes in result)
  {
    ModelObject* modelObject = [[[ModelObject alloc] initWithAttributes:attributes] autorelease];
    modelObject.uniqueIdentifierKey = @"url";
    modelObject.imageURLKey = @"image";
    modelObject.verticalOffsetKey = @"y_offset";
    
    [modelObjectResults addObject:modelObject];

    NSNumber* nextPageObject = [modelObject objectForKey:@"next_page"];
    if (nextPageObject)
      nextPage = [nextPageObject integerValue];
  }

  self.collection = collection && collection.count > 0 ? [[collection subarrayWithRange:NSMakeRange(0, collection.count -1)] arrayByAddingObjectsFromArray:modelObjectResults] : modelObjectResults;

  if (collection.count == 0)
    [self defaultErrorMessage];
  else
    [self populateTable];
}

- (void) loadImageForCell:(BaseTableViewCell*)cell
{
  if (cell.modelObject.image)
  {
    cell.imageView.image = cell.modelObject.image;
    [cell.modelObject adjustImageVerticallyUsing:cell.imageView];
  }
  else
  {
    cell.imageView.image = nil;
    [cell.modelObject startDownloadingImageIfNeeded];
  }
}

#pragma mark Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return collection.count;
}

- (BOOL) isMoreCell:(NSIndexPath*) indexPath
{
  if (indexPath.row == collection.count -1)
  {
    ModelObject* modelObject = [collection objectAtIndex:indexPath.row];
    NSNumber* nextPageObject = [modelObject objectForKey:@"next_page"];
    if (nextPageObject)
      return YES;
  }
  return NO;
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self isMoreCell:indexPath] ? 44 : theTableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MorePagesTableViewCell* moreCell = (MorePagesTableViewCell*)[theTableView dequeueReusableCellWithIdentifier:kMorePagesTableViewCellId];
  if (moreCell == nil)
  {
    [[NSBundle mainBundle] loadNibNamed:@"MorePagesTableViewCell" owner:self options:nil];
    moreCell = (MorePagesTableViewCell*)tableViewCell;
    self.tableViewCell = nil;
  }
  moreCell.loadingLabel.textColor = [UIColor darkGrayColor];
  moreCell.loading.hidden = YES;
  
  return moreCell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isMoreCell:indexPath])
    [self loadCollection];
}

- (UITableView*) visibleTable
{
  return tableView;
}

- (void)viewDidUnload
{
  self.tableView = nil;
  self.tableViewCell = nil;
}

- (void)dealloc
{
  [tableView release];
  [tableViewCell release];

  [collection release];
  [collectionConnection release];
  [collectionData release];

  [super dealloc];
}

@end
