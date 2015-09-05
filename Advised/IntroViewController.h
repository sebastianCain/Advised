//
//  IntroViewController.h
//  Advised
//
//  Created by Sebastian Cain on 9/5/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import "ViewController.h"
#import "UniversalHeader.h"
#import <CoreData/CoreData.h>

@interface IntroViewController : ViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
