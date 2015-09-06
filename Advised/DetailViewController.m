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
	[self.content setContentSize:CGSizeMake(WIDTH, HEIGHT*3-240)];
	[self.content setPagingEnabled:YES];
	[self.content setDelegate:self];
	[self.view addSubview:self.content];
	
	[self loadPage1];
	[self loadPage2];
	[self loadPage3];
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
	NSString *text = [[[[[self.advisor.name stringByAppendingString: @" had "] stringByAppendingString:[NSString stringWithFormat:@"%d", [self.advisor.numFirms intValue]]] stringByAppendingString:@" jobs in "] stringByAppendingString: [NSString stringWithFormat:@"%d", [self.advisor.yearsWorked intValue]]] stringByAppendingString:@" years."];
	[convo2 setText:text];
	[convo2 setTextAlignment:NSTextAlignmentCenter];
	[convo2 setTextColor:[UIColor whiteColor]];
	[self.conversation addObject:convo2];
	self.secondLineHasAnimated = NO;
	[page2 addSubview:convo2];
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
	
	UILabel *convo1 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-180, WIDTH, 50)];
	[convo1 setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[convo1 setText:@"Find out why below"];
	[convo1 setTextAlignment:NSTextAlignmentCenter];
	[convo1 setTextColor:[UIColor whiteColor]];
	[self.conversation addObject:convo1];
	self.thirdLineHasAnimated = NO;
	[page3 addSubview:convo1];
}

-(void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y == HEIGHT-80) {
		if (!self.secondLineHasAnimated) {
			[(UILabel *)(self.conversation[1]) drawOutlineAnimatedWithLineWidth:.5 withDuration:3 fadeToLabel:NO];
		}
	} else if (scrollView.contentOffset.y == 2*HEIGHT-160) {
		if (!self.thirdLineHasAnimated) {
			[(UILabel *)(self.conversation[2]) drawOutlineAnimatedWithLineWidth:.5 withDuration:3 fadeToLabel:NO];
		}
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
