//
//  WebViewController.h
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//


@interface WebViewController : UIViewController
{
  IBOutlet UIWebView* webView;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
