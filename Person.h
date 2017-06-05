//
//  Person.h
//  CoreDataDemo
//
//  Created by iOS-School-1 on 30.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Dog;

@interface Person : NSManagedObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) uint16_t age;

@property (nonatomic, strong) Dog *dog;

@end
