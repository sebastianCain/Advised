
//
//  IntroViewController.m
//  Advised
//
//  Created by Sebastian Cain on 9/5/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"WTF");
	[self initializeDatabaseFromHTTP];
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	ViewController *vc = [[ViewController alloc] init];
//	[self presentViewController:vc animated:YES completion:nil];
	
}

- (void)initializeDatabaseFromHTTP {
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"100feed" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	//	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//	NSLog(@"%@",string);
	NSError *err = [[NSError alloc] init];
	NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
	
	NSArray *advisors = [json valueForKey:@"adviserArray"];
	
	NSLog(@"looping through advisors");
	
	for (NSDictionary *i in advisors) {
		Advisor *newAdvisor = [NSEntityDescription insertNewObjectForEntityForName:@"Advisor" inManagedObjectContext:self.managedObjectContext];
		
		newAdvisor.name = [[[i valueForKey:@"firstNm"] stringByAppendingString:@" "] stringByAppendingString: [i valueForKey:@"lastNm"]];
		newAdvisor.riskValue = [i valueForKey:@"risk"];
		newAdvisor.riskPercent =[i valueForKey:@"riskPercent"];
		newAdvisor.currentFirm = [i valueForKey:@"orgNm"];
		newAdvisor.drp = [NSKeyedArchiver archivedDataWithRootObject:[i valueForKey:@"DRP"]];
		newAdvisor.workHistory = [NSKeyedArchiver archivedDataWithRootObject:[i valueForKey:@"EmpHs"]];
		
	}
	
	[self.managedObjectContext save:nil];
	
	NSLog(@"finished saving");
	
	//	[self.advisorsTableView reloadData];
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
