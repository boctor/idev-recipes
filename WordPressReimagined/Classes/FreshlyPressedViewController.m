//
//  FreshlyPressedViewController.m
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

#import "FreshlyPressedViewController.h"
#import "FreshlyPressedTableViewCell.h"
#import "ModelObject.h"
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"
#import "WordPressReimaginedAppDelegate.h"

@interface FreshlyPressedViewController (PrivateMethods)
- (void) loadImageForCell:(BaseTableViewCell*)cell;
@end

@interface BaseTableViewController (PrivateMethods)
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation FreshlyPressedViewController
@synthesize tableHeaderView;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  tableView.tableHeaderView = tableHeaderView;
}

- (NSString*) getCollectionURL
{
  return [NSString stringWithFormat:@"http://wordpressreimagined.s3.amazonaws.com/freshlypressed/%d.json", nextPage];
}

- (void) populate:(FreshlyPressedTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
  ModelObject* modelObject = [collection objectAtIndex:indexPath.row];
  cell.modelObject = modelObject;
  cell.title.text = [modelObject objectForKey:@"title"];
  cell.subtitle.text = [modelObject objectForKey:@"subtitle"];

  CGFloat titleHeight = [cell.title.text sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(cell.title.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height;
  CGRect titleFrame = cell.title.frame;
  titleFrame.size.height = titleHeight;
  cell.title.frame = titleFrame;
  
  CGRect subtitleFrame = cell.subtitle.frame;
  subtitleFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + 2.0;
  cell.subtitle.frame = subtitleFrame;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isMoreCell:indexPath])
    return [super tableView:theTableView cellForRowAtIndexPath:indexPath];
  FreshlyPressedTableViewCell *cell = (FreshlyPressedTableViewCell*)[theTableView dequeueReusableCellWithIdentifier:kFreshlyPressedTableViewCellId];
  if (cell == nil)
  {
    [[NSBundle mainBundle] loadNibNamed:@"FreshlyPressedTableViewCell" owner:self options:nil];
    cell = (FreshlyPressedTableViewCell*)self.tableViewCell;
    self.tableViewCell = nil;
    
    cell.imageView.superview.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    cell.imageView.superview.layer.borderWidth = 1.0;
  }

  [self populate:cell atIndexPath:indexPath];
  [self loadImageForCell:cell];
  
  return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isMoreCell:indexPath])
    return [super tableView:theTableView didSelectRowAtIndexPath:indexPath];
  
  ModelObject* modelObject = [collection objectAtIndex:indexPath.row];
  WebViewController* webViewController =  [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
  webViewController.url = [modelObject objectForKey:@"url"];
  
  UINavigationController *navigationController = ((WordPressReimaginedAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController;
  [navigationController pushViewController:webViewController animated:YES];
}

- (void)viewDidUnload
{
  self.tableHeaderView = nil;
}

- (void)dealloc
{
  [tableHeaderView release];
  [super dealloc];
}

@end
