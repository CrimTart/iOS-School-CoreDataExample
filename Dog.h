//
//  Dog.h
//  CoreDataDemo
//
//  Created by iOS-School-1 on 30.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Person;

@interface Dog : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet<Person *> *persons;

@end
