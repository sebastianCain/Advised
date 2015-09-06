//
//  Firm.h
//  
//
//  Created by Sebastian Cain on 9/6/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Advisor;

@interface Firm : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *advisors;
@end

@interface Firm (CoreDataGeneratedAccessors)

- (void)addAdvisorsObject:(Advisor *)value;
- (void)removeAdvisorsObject:(Advisor *)value;
- (void)addAdvisors:(NSSet *)values;
- (void)removeAdvisors:(NSSet *)values;

@end
