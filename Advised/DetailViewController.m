//
//  DetailViewController.m
//  Advised
//
//  Created by Sebastian Cain on 9/5/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import "DetailViewController.h"

#import "PNChart.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view setBackgroundColor:[UIColor whiteColor]];
	GradientView *gradientView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
	[self.view addSubview:gradientView];
	
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
	[title setFont:[UIFont fontWithName:@"Panton-Thin" size:24]];
	[title setText:@"John Smith"];
	[title setTextColor:[UIColor whiteColor]];
	[title setCenter:CGPointMake(WIDTH/2, 40)];
	[title setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:title];
	
	//For Line Chart
	PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
	[lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
	
	[self.view addSubview:lineChart];
	
	// Line Chart No.1
	NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
	PNLineChartData *data01 = [PNLineChartData new];
	data01.color = PNFreshGreen;
	data01.itemCount = lineChart.xLabels.count;
	data01.getData = ^(NSUInteger index) {
		CGFloat yValue = [data01Array[index] floatValue];
		return [PNLineChartDataItem dataItemWithY:yValue];
	};
	// Line Chart No.2
	NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
	PNLineChartData *data02 = [PNLineChartData new];
	data02.color = PNTwitterColor;
	data02.itemCount = lineChart.xLabels.count;
	data02.getData = ^(NSUInteger index) {
		CGFloat yValue = [data02Array[index] floatValue];
		return [PNLineChartDataItem dataItemWithY:yValue];
	};
	
	lineChart.chartData = @[data01, data02];
	[lineChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
