//
//  ViewController.h
//  Stockd
//
//  Created by Sebastian Cain on 9/4/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalHeader.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property UIScrollView *tabScrollView;
@property UIView *menuIndicator;

@property UIView *advisors;
@property UITableView *advisorsTableView;

@property UIView *trends;
@property UIView *trendsScrollView;

@end

