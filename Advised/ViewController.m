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
	
	
	[self initializeDatabaseFromHTTP];
	
	
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
	
	self.menuIndicator = [[UIView alloc]initWithFrame:CGRectMake(20, 80, WIDTH/2-40, 1)];
	[self.menuIndicator setBackgroundColor:[UIColor colorWithWhite:1 alpha:.3]];
	[self.menuIndicator setClipsToBounds:YES];
	[self.view addSubview:self.menuIndicator];
	
	[self loadAdvisors];
	[self loadTrends];
	
}

#pragma mark - Advisors

-(void)loadAdvisors {
	self.advisorsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-130) style:UITableViewStylePlain];
	[self.advisorsTableView setDelegate:self];
	[self.advisorsTableView setDataSource:self];
	[self.advisorsTableView setBackgroundColor:[UIColor clearColor]];
	[self.advisorsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.advisors addSubview:self.advisorsTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"%ld", (long)indexPath.row);
	Advisor *advisorObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"advisor"];
	[cell setBackgroundColor:[UIColor clearColor]];
	
	UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, cell.frame.size.width-80, 60)];
	[name setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	[name setTextColor:[UIColor whiteColor]];
	NSString *nameText = advisorObject.name;
	[name setText:nameText];
	[name setTextAlignment:NSTextAlignmentLeft];
	[cell addSubview:name];
	
	UILabel *risk = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, cell.frame.size.width-80, 60)];
	[risk setFont:[UIFont fontWithName:@"Panton-ExtraLight" size:13]];
	[risk setTextColor:[UIColor whiteColor]];
	NSString *riskText = [advisorObject.riskValue stringValue];
	[risk setText:riskText];
	[risk setTextAlignment:NSTextAlignmentRight];
	[cell addSubview:risk];
	
	UIView *betterSeperator = [[UIView alloc]initWithFrame:CGRectMake(20, 59, WIDTH-40, 1)];
	[betterSeperator setBackgroundColor:[UIColor colorWithWhite:1 alpha:.3]];
	[betterSeperator setClipsToBounds:YES];
	[cell addSubview:betterSeperator];
	
	return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
//	return [sectionInfo numberOfObjects];
	return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailViewController *dvc = [[DetailViewController alloc]init];
	dvc.advisor = [self.fetchedResultsController objectAtIndexPath:indexPath];
	dvc.index = indexPath.row;
	[self presentViewController:dvc animated:YES completion:nil];
}

#pragma mark - CoreData Methods

- (NSFetchedResultsController *)fetchedResultsController
{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Advisor" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"lmao"];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _fetchedResultsController;
}

- (void)initializeDatabaseFromXML {
	
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
	
	[self.advisorsTableView reloadData];
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
	[self.menuIndicator.layer setPosition:CGPointMake(self.tabScrollView.contentOffset.x/2+WIDTH/4, 80)];
	[self.menuIndicator setNeedsDisplay];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
