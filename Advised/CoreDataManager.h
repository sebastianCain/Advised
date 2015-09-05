//
//  CoreDataManager.h
//  Advised
//
//  Created by Sebastian Cain on 9/5/15.
//  Copyright (c) 2015 Sebastian Cain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
										   sortDescriptors:(NSArray *)sortDescriptors
										sectionNameKeyPath:(NSString *)sectionNameKeypath
												 predicate:(NSPredicate *)predicate;

- (id)createEntityWithClassName:(NSString *)className
		   attributesDictionary:(NSDictionary *)attributesDictionary;
- (void)deleteEntity:(NSManagedObject *)entity;
- (BOOL)uniqueAttributeForClassName:(NSString *)className
					  attributeName:(NSString *)attributeName
					 attributeValue:(id)attributeValue;

@end
