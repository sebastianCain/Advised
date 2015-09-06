//
//  Advisor.h
//  
//
//  Created by Sebastian Cain on 9/6/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Firm;

@interface Advisor : NSManagedObject

@property (nonatomic, retain) NSString * currentFirm;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * riskValue;
@property (nonatomic, retain) id workHistory;
@property (nonatomic, retain) NSNumber * riskPercent;
@property (nonatomic, retain) id drp;
@property (nonatomic, retain) NSNumber * numFirms;
@property (nonatomic, retain) NSNumber * yearsWorked;
@property (nonatomic, retain) NSSet *firms;
@end

@interface Advisor (CoreDataGeneratedAccessors)

- (void)addFirmsObject:(Firm *)value;
- (void)removeFirmsObject:(Firm *)value;
- (void)addFirms:(NSSet *)values;
- (void)removeFirms:(NSSet *)values;

@end
