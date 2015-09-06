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
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loaded"] == YES) {
		NSLog(@"saved space");
	} else {
		[self initializeDatabaseFromHTTP];
		NSLog(@"loaded");
	}
	
	UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, 25, 30, 30)];
	[searchButton setBackgroundImage:[UIImage imageNamed:@"search-icon"] forState:UIControlStateNormal];
	[searchButton addTarget:self action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:searchButton];
	
	self.resultSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	[self.resultSearchController.searchBar setBackgroundColor:[UIColor redColor]];
	[self.resultSearchController setDelegate:self];
	[self.resultSearchController setSearchResultsUpdater:self];
	[self.resultSearchController setDimsBackgroundDuringPresentation:NO];
	[self.resultSearchController.searchBar setFrame:CGRectMake(0, -40, WIDTH, 40)];
	[self.resultSearchController.searchBar setDelegate:self];

	[self.view addSubview:self.resultSearchController.searchBar];
//	self.advisorsTableView.tableHeaderView = self.resultSearchController.searchBar;
	[self.advisorsTableView reloadData];
	[self.advisorsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

	
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
	[trendsButton setTitle:@"FIRMS" forState:UIControlStateNormal];
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
	
	
	//+++++++++++++++++++++++++++++++++++++++ SCATTER PLOT
	
	self.scatterPlot = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
	[self.scatterPlot setAxisXWithMinimumValue:5 andMaxValue:45 toTicks:10];
	[self.scatterPlot setAxisYWithMinimumValue:1 andMaxValue:10 toTicks:10];
	
	NSArray* data01Array = [self getScatterData];
	PNScatterChartData *data01 = [PNScatterChartData new];
	data01.strokeColor = [UIColor clearColor];
	data01.fillColor = [UIColor whiteColor];
	data01.size = 1;
	data01.itemCount = [[data01Array objectAtIndex:0] count];
	data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
	__block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
	__block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
	data01.getData = ^(NSUInteger index) {
		CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
		CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
		return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
	};
	
	[self.scatterPlot setup];
	self.scatterPlot.chartData = @[data01];
	/***
	 this is for drawing line to compare
	 CGPoint start = CGPointMake(20, 35);
	 CGPoint end = CGPointMake(80, 45);
	 [scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
	 ***/
	
	
}

-(NSArray *)getScatterData {
	NSMutableArray *x = [[NSMutableArray alloc]init];
	NSMutableArray *y = [[NSMutableArray alloc]init];
	
	for (Advisor *a in self.fetchedResultsController.fetchedObjects) {
		if (a.yearsWorked != nil){
			[x addObject:a.yearsWorked];
		}
		if (a.numFirms != nil) {
			[y addObject:a.numFirms];
		}
	}
	return @[x, y];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"%ld", (long)indexPath.row);
	Advisor *advisorObject = [[Advisor alloc] initWithEntity:[NSEntityDescription entityForName:@"Advisor" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
	if (self.resultSearchController.active) {
		advisorObject = self.filteredResults[indexPath.row];
	} else {
		advisorObject = self.fetchedResultsController.fetchedObjects[indexPath.row];
	}
	
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
	NSString *riskText;
	if ([advisorObject.riskPercent floatValue] < .25) {
		[risk setTextColor:[UIColor greenColor]];
		riskText = @"VERY SAFE";
	} else if ([advisorObject.riskPercent floatValue] < .5) {
		[risk setTextColor:[UIColor greenColor]];
		riskText = @"SAFE";
	} else if ([advisorObject.riskPercent floatValue] < .75) {
		[risk setTextColor:[UIColor redColor]];
		riskText = @"RISKY";
	} else {
		[risk setTextColor:[UIColor redColor]];
		riskText = @"HIGH RISK";
	}
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
	if (self.resultSearchController.active) {
		return [self.filteredResults count];
	} else {
		return 100;
	}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailViewController *dvc = [[DetailViewController alloc]init];
	if (self.resultSearchController.active) {
		dvc.advisor = [self.filteredResults objectAtIndex:indexPath.row];
	} else {
		dvc.advisor = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
	
	dvc.index = indexPath.row;
	dvc.scatterPlot = self.scatterPlot;
	[self.resultSearchController.searchBar endEditing:YES];
	[self.resultSearchController setActive:NO];
	[UIView animateWithDuration:0.3f animations:^{
		[self.resultSearchController.searchBar setFrame:CGRectMake(0, -40, WIDTH, 40)];
	}];
	[self.advisorsTableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController pushViewController:dvc animated:YES];
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
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loaded"];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"new100feed" ofType:@"json"];
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
		newAdvisor.currentFirm = [[[i valueForKey:@"EmpHs"] lastObject] valueForKey:@"orgNm"];
		newAdvisor.drp = [NSKeyedArchiver archivedDataWithRootObject:[i valueForKey:@"DRP"]];
		newAdvisor.workHistory = [NSKeyedArchiver archivedDataWithRootObject:[i valueForKey:@"EmpHs"]];
		newAdvisor.numFirms = [i valueForKey:@"numFirms"];
		newAdvisor.yearsWorked = [i valueForKey:@"yearsWorked"];
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

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	[self.filteredResults removeAllObjects];
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchController.searchBar.text];
	NSArray *array = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:searchPredicate];
	self.filteredResults = [NSMutableArray arrayWithArray:array];
	[self.advisorsTableView reloadData];
}

-(BOOL)searchBarDidEndEditing:(UISearchBar *)searchBar {
	[UIView animateWithDuration:0.3f animations:^{
		[self.resultSearchController.searchBar setFrame:CGRectMake(0, -40, WIDTH, 40)];
	}];
	return NO;
}

-(void)didDismissSearchController:(UISearchController *)searchController {
	[UIView animateWithDuration:0.3f animations:^{
		[self.resultSearchController.searchBar setFrame:CGRectMake(0, -40, WIDTH, 40)];
	}];
}

-(void)searchButtonTapped {
	[UIView animateWithDuration:0.3f animations:^{
		[self.resultSearchController.searchBar setFrame:CGRectMake(0, 0, WIDTH, 40)];
	} completion:^(BOOL finished) {
		[self.resultSearchController setActive:YES];
		[self.resultSearchController setEditing:YES animated:YES];
		[self.resultSearchController.searchBar becomeFirstResponder];
	}];
	[self.resultSearchController.searchBar becomeFirstResponder];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
