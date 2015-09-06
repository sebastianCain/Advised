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
	[self.content setContentSize:CGSizeMake(WIDTH, HEIGHT*2)];
	[self.view addSubview:self.content];
	
	UILabel *currentPosition = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[currentPosition setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	if (self.advisor.currentFirm != nil) {
		[currentPosition setText:[@"Currently At " stringByAppendingString:self.advisor.currentFirm]];
	}
	[currentPosition setTextAlignment:NSTextAlignmentCenter];
	[currentPosition setTextColor:[UIColor whiteColor]];
	[self.content addSubview:currentPosition];
	
	UILabel *workHistoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[workHistoryLabel setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[workHistoryLabel setText:@"Has worked at:"];
	[workHistoryLabel setTextAlignment:NSTextAlignmentCenter];
	[workHistoryLabel setTextColor:[UIColor whiteColor]];
	[self.content addSubview:workHistoryLabel];
	
	self.left = YES;
	
	NSArray *workHistory = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:self.advisor.workHistory];
	
	NSMutableArray *times = [[NSMutableArray alloc]init];
	NSMutableArray *descriptions = [[NSMutableArray alloc]init];
	for (NSDictionary *i in workHistory) {
		if (self.left) {
			[times addObject:[i objectForKey:@"fromDt"]];
			[descriptions addObject:[i objectForKey:@"orgNm"]];
			self.left = NO;
		} else {
			[descriptions addObject:[i objectForKey:@"fromDt"]];
			[times addObject:[i objectForKey:@"orgNm"]];
			self.left = YES;
		}
	}
	TimelineView *timeline = [[TimelineView alloc] initWithTimeArray:(NSArray *)times andTimeDescriptionArray:(NSArray *)descriptions andCurrentStatus:0 andFrame:CGRectMake(0, 75, WIDTH, 150)];
	
	[self.content addSubview:timeline];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"Comparative Risk Analysis"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[self.content addSubview:calcRiskTitle];
	
	PNCircleChart *calcRisk = [[PNCircleChart alloc] initWithFrame:CGRectMake(WIDTH/2-75, HEIGHT, 150, 150)
																	   total:[NSNumber numberWithInt:100]
																	 current:[NSNumber numberWithInt:([self.advisor.riskPercent floatValue]*100)]
																   clockwise:YES
																	  shadow:YES
																 shadowColor:[UIColor clearColor]
														displayCountingLabel:YES
														   overrideLineWidth:[NSNumber numberWithInt:1]];
	calcRisk.backgroundColor = [UIColor clearColor];
	[calcRisk setStrokeColor:[UIColor whiteColor]];
	[self.content addSubview:calcRisk];
	[calcRisk strokeChart];
}


-(void)back {
	[self.navigationController popViewControllerAnimated:YES];
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
