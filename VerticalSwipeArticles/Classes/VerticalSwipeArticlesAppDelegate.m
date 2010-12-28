//
//  VerticalSwipeArticlesAppDelegate.m
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "VerticalSwipeArticlesAppDelegate.h"
#import "RootViewController.h"
#import "JSON.h"

#define TOP_APPS_URL @"http://itunes.apple.com/us/rss/toppaidapplications/limit=25/json"

@implementation VerticalSwipeArticlesAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize loadingView, topAppsData;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  navigationController.delegate = self;

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:TOP_APPS_URL]];
  NSURLConnection* topAppsConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
  if (topAppsConnection)
    self.topAppsData = [NSMutableData data];

  [self.window addSubview:loadingView];
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if ([viewController respondsToSelector:@selector(willAppearIn:)])
    [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void) cancel:(NSURLConnection *)connection
{
  [connection cancel];
  self.topAppsData = nil;
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSInteger status = [(NSHTTPURLResponse*)response statusCode];

  if (status != 200)
    [self cancel:connection];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [topAppsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [self cancel:connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString* topAppsString = [[[NSString alloc] initWithData:topAppsData encoding:NSUTF8StringEncoding] autorelease]; 
  self.topAppsData = nil;

  @try {
    RootViewController* rootViewController = (RootViewController*)[navigationController.viewControllers objectAtIndex:0];
    rootViewController.topApps = [[[topAppsString JSONValue] objectForKey:@"feed"]objectForKey:@"entry"];
    [self.window addSubview:navigationController.view];
  }
  @catch (NSException * e) {
  }
}

- (void)dealloc {
  [topAppsData release];
  [loadingView release];
  [navigationController release];
  [window release];
  [super dealloc];
}


@end

