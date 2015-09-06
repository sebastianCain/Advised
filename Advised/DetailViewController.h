//
//  DetailViewController.h
//  Advised
//
//  Created by Sebastian Cain on 9/5/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalHeader.h"
#import "Advisor.h"
#import "TimelineView.h"
@interface DetailViewController : UIViewController <UIScrollViewDelegate, PNChartDelegate>

@property int index;
@property Advisor *advisor;

@property UIScrollView *content;
@property NSMutableArray *conversation;
@property BOOL firstLineHasAnimated;
@property BOOL secondLineHasAnimated;
@property BOOL thirdLineHasAnimated;
@property BOOL fouthLineHasAnimated;
@property PNScatterChart *scatterPlot;

@property PNCircleChart *secondCircle;

@end
