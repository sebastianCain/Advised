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
	
	NSLog(@"%@", self.advisor);
	
	self.conversation = [[NSMutableArray alloc]init];
	
	UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	[back setFrame:CGRectMake(0, 0, 80, 80)];
	UIImage *backImage = [UIImage imageNamed:@"back"];
	[back setImage:backImage forState:UIControlStateNormal];
	[back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:back];
	
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
	[title setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[title setText:self.advisor.name];
	[title setTextColor:[UIColor whiteColor]];
	[title setCenter:CGPointMake(WIDTH/2, 40)];
	[title setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:title];
	
	self.content = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, WIDTH, HEIGHT-80)];
	[self.content setContentSize:CGSizeMake(WIDTH, 5*(HEIGHT-80))];
	[self.content setPagingEnabled:YES];
	[self.content setDelegate:self];
	[self.view addSubview:self.content];
	
	[self loadPage1];
	[self loadPage2];
	[self loadPage3];
	[self loadPage4];
	[self loadPage5];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
		[(UILabel *)(self.conversation[0]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
		self.firstLineHasAnimated = YES;
	});
}

-(void)loadPage1 {
	UIView *page1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-80)];
	[self.content addSubview:page1];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"Comparative Risk Analysis"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[page1 addSubview:calcRiskTitle];
	
	PNCircleChart *calcRisk = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)
															 total:[NSNumber numberWithInt:100]
														   current:[NSNumber numberWithInt:([self.advisor.riskPercent floatValue]*100)]
														 clockwise:YES
															shadow:YES
													   shadowColor:[UIColor colorWithWhite:1 alpha:.3]
											  displayCountingLabel:YES
												 overrideLineWidth:[NSNumber numberWithInt:1]];
	calcRisk.backgroundColor = [UIColor clearColor];
	[calcRisk setStrokeColor:[UIColor whiteColor]];
	[calcRisk setCenter:page1.center];
	[page1 addSubview:calcRisk];
	[calcRisk strokeChart];
	
	UILabel *convo1 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-180, WIDTH, 50)];
	[convo1 setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[convo1 setText:@"Find out why below"];
	[convo1 setTextAlignment:NSTextAlignmentCenter];
	[convo1 setTextColor:[UIColor whiteColor]];
	[convo1.layer setOpacity:0];
	[self.conversation addObject:convo1];
	self.firstLineHasAnimated = NO;
	[page1 addSubview:convo1];
}

-(void)loadPage2 {
	UIView *page2 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-80, WIDTH, HEIGHT-80)];
	[self.content addSubview:page2];
	
	UILabel *workHistoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[workHistoryLabel setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[workHistoryLabel setText:@"Has worked at:"];
	[workHistoryLabel setTextAlignment:NSTextAlignmentCenter];
	[workHistoryLabel setTextColor:[UIColor whiteColor]];
	[page2 addSubview:workHistoryLabel];
	
	//	self.left = YES;
	
	NSArray *workHistory = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:self.advisor.workHistory];
	
	NSMutableArray *times = [[NSMutableArray alloc]init];
	NSMutableArray *descriptions = [[NSMutableArray alloc]init];
	
	for (NSDictionary *i in workHistory) {
		[times addObject:[i objectForKey:@"fromDt"]];
		[descriptions addObject:[i objectForKey:@"orgNm"]];
	}
	
	TimelineView *timeline = [[TimelineView alloc] initWithTimeArray:(NSArray *)times andTimeDescriptionArray:(NSArray *)descriptions andCurrentStatus:0 andFrame:CGRectMake(0, 0, WIDTH, 300)];
	[timeline sizeToFit];
	[timeline.superview layoutSubviews];
	[timeline setCenter:CGPointMake(WIDTH/2, HEIGHT/2-40)];
	[page2 addSubview:timeline];
	
	UILabel *currentPosition = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-230, WIDTH, 50)];
	[currentPosition setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	if (self.advisor.currentFirm != nil) {[currentPosition setText:[@"Currently At " stringByAppendingString:self.advisor.currentFirm]];}
	[currentPosition setNumberOfLines:2];
	[currentPosition setTextAlignment:NSTextAlignmentCenter];
	[currentPosition setTextColor:[UIColor whiteColor]];
	[page2 addSubview:currentPosition];
	
	UILabel *convo2 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-180, WIDTH, 50)];
	[convo2 setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	NSString *text = [[[[[self.advisor.name stringByAppendingString: @" has had "] stringByAppendingString:[NSString stringWithFormat:@"%d", [self.advisor.numFirms intValue]]] stringByAppendingString:@" jobs in "] stringByAppendingString: [NSString stringWithFormat:@"%d", [self.advisor.yearsWorked intValue]]] stringByAppendingString:@" years."];
	[convo2 setNumberOfLines:2];
	[convo2 setText:text];
	[convo2 setTextAlignment:NSTextAlignmentCenter];
	[convo2 setTextColor:[UIColor whiteColor]];
	[convo2.layer setOpacity:0];
	[self.conversation addObject:convo2];
	self.secondLineHasAnimated = NO;
	[page2 addSubview:convo2];
	
	UILabel *convo22 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-160, WIDTH, 50)];
	[convo22 setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	NSString *text2 = [[@"That's an average of " stringByAppendingString:[NSString stringWithFormat:@"%d", [self.advisor.yearsWorked intValue]/[self.advisor.numFirms intValue]]] stringByAppendingString: @" years per job."];
	[convo22 setNumberOfLines:2];
	[convo22 setText:text2];
	[convo22 setTextAlignment:NSTextAlignmentCenter];
	[convo22 setTextColor:[UIColor whiteColor]];
	[convo22.layer setOpacity:0];
	[self.conversation addObject:convo22];
	self.secondLineHasAnimated = NO;
	[page2 addSubview:convo22];
}

-(void)loadPage3 {
	UIView *page3 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*2-160, WIDTH, HEIGHT-80)];
	[self.content addSubview:page3];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"Job Endurance Plot"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[page3 addSubview:calcRiskTitle];
	
	[self.scatterPlot setDelegate:self];
	[self.scatterPlot setFrame:CGRectMake(20, 100, WIDTH, HEIGHT-180)];
	[page3 addSubview:self.scatterPlot];
	
	UILabel *convo3 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-180, WIDTH, 50)];
	[convo3 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	[convo3 setText:@"This graph shows years in industry vs # of jobs."];
	[convo3 setTextAlignment:NSTextAlignmentCenter];
	[convo3 setTextColor:[UIColor whiteColor]];
	[convo3.layer setOpacity:0];
	[self.conversation addObject:convo3];
	self.thirdLineHasAnimated = NO;
	[page3 addSubview:convo3];
	
	UILabel *convo33 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-160, WIDTH, 50)];
	[convo33 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	[convo33 setText:[self.advisor.name stringByAppendingString:@"'s position is marked in red."]];
	[convo33 setTextAlignment:NSTextAlignmentCenter];
	[convo33 setTextColor:[UIColor whiteColor]];
	[convo33.layer setOpacity:0];
	[self.conversation addObject:convo33];
	self.thirdLineHasAnimated = NO;
	[page3 addSubview:convo33];
}

-(void)loadPage4 {
	UIView *page4 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*3-240, WIDTH, HEIGHT-80)];
	[self.content addSubview:page4];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"History of Malfeasance"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[page4 addSubview:calcRiskTitle];
	
	NSDictionary *drp = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:self.advisor.drp];
	
	if ([drp objectForKey:@"hasCustComp"] == nil) {
		UILabel *convo4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 50)];
		[convo4 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
		[convo4 setText:@"No data to show"];
		[convo4 setTextAlignment:NSTextAlignmentCenter];
		[convo4 setTextColor:[UIColor whiteColor]];
		[convo4.layer setOpacity:0];
		[self.conversation addObject:convo4];
		self.fouthLineHasAnimated = NO;
		[page4 addSubview:convo4];
		return;
	}
	
	UILabel *convo4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 50)];
	[convo4 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	if ([[drp objectForKey:@"hasCustComp"] isEqualToString:@"N"]) {
		[convo4 setText:@"Has never had a complaint filed against them."];
	} else {
		[convo4 setText:@"HAS had complaints filed against them."];
	}
	[convo4 setTextAlignment:NSTextAlignmentCenter];
	[convo4 setTextColor:[UIColor whiteColor]];
	[convo4.layer setOpacity:0];
	[self.conversation addObject:convo4];
	self.fouthLineHasAnimated = NO;
	[page4 addSubview:convo4];
	
	UILabel *convo41 = [[UILabel alloc]initWithFrame:CGRectMake(0,100, WIDTH, 50)];
	[convo41 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	if ([[drp objectForKey:@"hasRegAction"] isEqualToString:@"N"]) {
		[convo41 setText:@"Has never recieved a regulatory action."];
	} else {
		[convo41 setText:@"HAS recieved a regulatory action."];
	}
	[convo41 setTextAlignment:NSTextAlignmentCenter];
	[convo41 setTextColor:[UIColor whiteColor]];
	[convo41.layer setOpacity:0];
	[self.conversation addObject:convo41];
	self.fouthLineHasAnimated = NO;
	[page4 addSubview:convo41];
	
	UILabel *convo42 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 50)];
	[convo42 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	if ([[drp objectForKey:@"hasBankrupt"] isEqualToString:@"N"]) {
		[convo42 setText:@"Has never gone bankrupt."];
	} else {
		[convo42 setText:@"HAS gone bankrupt."];
	}
	[convo42 setTextAlignment:NSTextAlignmentCenter];
	[convo42 setTextColor:[UIColor whiteColor]];
	[convo42.layer setOpacity:0];
	[self.conversation addObject:convo42];
	self.fouthLineHasAnimated = NO;
	[page4 addSubview:convo42];
	
	UILabel *convo43 = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 50)];
	[convo43 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	if ([[drp objectForKey:@"hasCriminal"] isEqualToString:@"N"]) {
		[convo43 setText:@"Has never committed a crime"];
	} else {
		[convo43 setText:@"HAS been convicted for a crime"];
	}
	[convo43 setTextAlignment:NSTextAlignmentCenter];
	[convo43 setTextColor:[UIColor whiteColor]];
	[convo43.layer setOpacity:0];
	[self.conversation addObject:convo43];
	self.fouthLineHasAnimated = NO;
	[page4 addSubview:convo43];
	
	UILabel *convo44 = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, WIDTH, 50)];
	[convo44 setFont:[UIFont fontWithName:@"Panton-Thin" size:13]];
	if ([[drp objectForKey:@"hasTermination"] isEqualToString:@"N"]) {
		[convo44 setText:@"Has never been forcefully terminated."];
	} else {
		[convo44 setText:@"HAS been forcefully terminated"];
	}
	[convo44 setTextAlignment:NSTextAlignmentCenter];
	[convo44 setTextColor:[UIColor whiteColor]];
	[convo44.layer setOpacity:0];
	[self.conversation addObject:convo44];
	self.fouthLineHasAnimated = NO;
	[page4 addSubview:convo44];
}

-(void)loadPage5 {
	UIView *page5 = [[UIView alloc]initWithFrame:CGRectMake(0, 4*(HEIGHT-80), WIDTH, HEIGHT-80)];
	[self.content addSubview:page5];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"Comparative Risk Analysis"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[page5 addSubview:calcRiskTitle];
	
	self.secondCircle = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)
															 total:[NSNumber numberWithInt:100]
														   current:[NSNumber numberWithInt:([self.advisor.riskPercent floatValue]*100)]
														 clockwise:YES
															shadow:YES
													   shadowColor:[UIColor colorWithWhite:1 alpha:.3]
											  displayCountingLabel:YES
												 overrideLineWidth:[NSNumber numberWithInt:1]];
	self.secondCircle.backgroundColor = [UIColor clearColor];
	[self.secondCircle setStrokeColor:[UIColor whiteColor]];
	[self.secondCircle setCenter:CGPointMake(WIDTH/2, HEIGHT/2-40)];
	[self.secondCircle.layer setOpacity:0];
	[page5 addSubview:self.secondCircle];
	
	UILabel *convo1 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-180, WIDTH, 50)];
	[convo1 setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[convo1 setText:@"Find out why below"];
	[convo1 setTextAlignment:NSTextAlignmentCenter];
	[convo1 setTextColor:[UIColor whiteColor]];
	[convo1.layer setOpacity:0];
	[self.conversation addObject:convo1];
	self.firstLineHasAnimated = NO;
	[page5 addSubview:convo1];
}


-(void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y == HEIGHT-80) {
		if (!self.secondLineHasAnimated) {
			[(UILabel *)(self.conversation[1]) drawOutlineAnimatedWithLineWidth:.5 withDuration:3 fadeToLabel:NO];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[2]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			self.secondLineHasAnimated = YES;
			
		}
	} else if (scrollView.contentOffset.y == 2*HEIGHT-160) {
		if (!self.thirdLineHasAnimated) {
			[(UILabel *)(self.conversation[3]) drawOutlineAnimatedWithLineWidth:.5 withDuration:3 fadeToLabel:NO];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[4]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			self.thirdLineHasAnimated = YES;
		}
	} else if (scrollView.contentOffset.y == 3*HEIGHT-240) {
		if (!self.fouthLineHasAnimated) {
			[(UILabel *)(self.conversation[5]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			if (self.conversation.count == 6) {
				return;
			}
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[6]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[7]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[8]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				[(UILabel *)(self.conversation[9]) drawOutlineAnimatedWithLineWidth:.5 withDuration:2 fadeToLabel:NO];
			});
			self.fouthLineHasAnimated = YES;
		}
	} else if (scrollView.contentOffset.y == 4*(HEIGHT-80)) {
		[self.secondCircle.layer setOpacity:1];
		[self.secondCircle strokeChart];
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
