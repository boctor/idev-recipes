//
//  RootViewController.h
//  WoodUINavigation
//
//  Created by Peter Boctor on 12/13/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "CustomSegmentedControl.h"

@interface RootViewController : UIViewController <CustomSegmentedControlDelegate>
{
  NSArray* segmentControlTitles;
}

@end
