//
//  ViewController.m
//  Stockd
//
//  Created by Sebastian Cain on 9/4/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.view setBackgroundColor:[UIColor whiteColor]];
	GradientView *gradientView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
	[self.view addSubview:gradientView];
	
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
	[title setFont:[UIFont fontWithName:@"Panton-Thin" size:42]];
	[title setText:@"advised"];
	[title setTextColor:[UIColor whiteColor]];
	[title setCenter:CGPointMake(WIDTH/2, 40)];
	[title setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:title];
	
	UIButton *advisorsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, WIDTH/2, 50)];
	[advisorsButton.titleLabel setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	[advisorsButton.titleLabel setTextColor:[UIColor whiteColor]];
	[advisorsButton setTitle:@"ADVISORS" forState:UIControlStateNormal];
	[advisorsButton addTarget:self action:@selector(advisorsTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:advisorsButton];
	
	UIButton *trendsButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 80, WIDTH/2, 50)];
	[trendsButton.titleLabel setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	[trendsButton.titleLabel setTextColor:[UIColor whiteColor]];
	[trendsButton setTitle:@"TRENDS" forState:UIControlStateNormal];
	[trendsButton addTarget:self action:@selector(trendsTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:trendsButton];
	
	
	self.tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, WIDTH, HEIGHT-130)];
	[self.tabScrollView setDelegate:self];
	[self.tabScrollView setContentSize:CGSizeMake(WIDTH*2, HEIGHT-130)];
	[self.tabScrollView setPagingEnabled:YES];
	[self.tabScrollView setShowsHorizontalScrollIndicator: NO];
	[self.view addSubview:self.tabScrollView];
	
	self.advisors = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-130)];
	[self.tabScrollView addSubview:self.advisors];
	
	self.trends = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-130)];
	[self.tabScrollView addSubview:self.trends];
	
	self.menuIndicator = [[UIView alloc]initWithFrame:CGRectMake(0, 130, WIDTH/2, 1)];
	[self.menuIndicator setBackgroundColor:[UIColor colorWithWhite:1 alpha:.3]];
	[self.menuIndicator setClipsToBounds:YES];
	[self.view addSubview:self.menuIndicator];
	
	
}

#pragma mark - Advisors

-(void)loadAdvisors {
	self.advisorsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-130) style:UITableViewStylePlain];
	[self.advisorsTableView setDelegate:self];
	[self.advisorsTableView setDataSource:self];
	[self.advisors addSubview:self.advisorsTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"advisor"];
	
	UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, cell.frame.size.width-80, cell.frame.size.height)];
	[name setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	NSString *nameText = @"John Smith";//[NSString stringWithFormat:@""];
	[name setText:nameText];
	[name setTextAlignment:NSTextAlignmentLeft];
	[cell addSubview:name];
	
	UILabel *risk = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, cell.frame.size.width-80, cell.frame.size.height)];
	[risk setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	NSString *riskText = @"HIGH RISK";//[NSString stringWithFormat:@""];
	[risk setText:riskText];
	[risk setTextAlignment:NSTextAlignmentRight];
	[cell addSubview:risk];
	
	return cell;
}

#pragma mark - Trends

-(void)loadTrends {
	
}

# pragma mark - Universal

-(void)advisorsTapped {
	[self.tabScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)trendsTapped {
	[self.tabScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.menuIndicator.layer setPosition:CGPointMake(self.tabScrollView.contentOffset.x/2+WIDTH/4, 130)];
	[self.menuIndicator setNeedsDisplay];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
