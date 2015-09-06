//
//  DetailFirmViewController.m
//  Advised
//
//  Created by Sebastian Cain on 9/6/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import "DetailFirmViewController.h"

@interface DetailFirmViewController ()

@end

@implementation DetailFirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	GradientView *gradientView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
	[self.view addSubview:gradientView];
	
	UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	[back setFrame:CGRectMake(0, 0, 80, 80)];
	UIImage *backImage = [UIImage imageNamed:@"back"];
	[back setImage:backImage forState:UIControlStateNormal];
	[back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:back];

    // Do any additional setup after loading the view.
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, WIDTH-130, 160)];
	[title setFont:[UIFont fontWithName:@"Panton-Thin" size:18]];
	[title setText:[self.firmData valueForKey:@"firmName"]];
	[title setTextColor:[UIColor whiteColor]];
	[title setCenter:CGPointMake(WIDTH/2, 40)];
	[title setTextAlignment:NSTextAlignmentCenter];
	[title setNumberOfLines:3];
	[self.view addSubview:title];
	
	self.content = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, WIDTH, HEIGHT-80)];
	[self.content setContentSize:CGSizeMake(WIDTH, 5*(HEIGHT-80))];
	[self.content setPagingEnabled:YES];
	[self.content setDelegate:self];
	[self.view addSubview:self.content];
	
	UILabel *calcRiskTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 50)];
	[calcRiskTitle setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[calcRiskTitle setText:@"Comparative Risk Analysis"];
	[calcRiskTitle setTextAlignment:NSTextAlignmentCenter];
	[calcRiskTitle setTextColor:[UIColor whiteColor]];
	[self.content addSubview:calcRiskTitle];
	
	PNCircleChart *calcRisk = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 50, 150)
															 total:[NSNumber numberWithInt:100]
														   current:[NSNumber numberWithInt:([[self.firmData valueForKey:@"avgRisk"] floatValue]*100)]
														 clockwise:YES
															shadow:YES
													   shadowColor:[UIColor colorWithWhite:1 alpha:.3]
											  displayCountingLabel:YES
												 overrideLineWidth:[NSNumber numberWithInt:1]];
	calcRisk.backgroundColor = [UIColor clearColor];
	[calcRisk setStrokeColor:[UIColor whiteColor]];
	[calcRisk setCenter:CGPointMake(self.view.center.x, self.view.center.y-70)];
	[self.content addSubview:calcRisk];
	[calcRisk strokeChart];
	
	UILabel *employeeNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
	[employeeNumber setText:[@"Number of Employees: " stringByAppendingString:[[self.firmData valueForKey:@"firmEmployeeNumber"] stringValue]]];
	[employeeNumber  setFont:[UIFont fontWithName:@"Panton-Thin" size:20]];
	[employeeNumber setTextAlignment:NSTextAlignmentCenter];
	[employeeNumber setTextColor:[UIColor whiteColor]];
	[employeeNumber setCenter:CGPointMake(self.view.center.x, self.view.center.y+90)];
	[self.content addSubview:employeeNumber];
	
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
