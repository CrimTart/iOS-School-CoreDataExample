//
//  CoreDataStack.m
//  CoreDataDemo
//
//  Created by iOS-School-1 on 30.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *coreDataContext;

@end

@implementation CoreDataStack

- (instancetype)initStack {
    self = [super init];
    
    [self setupCoreData];
    
    return self;
}

+ (instancetype)stack{
    return [[CoreDataStack alloc] initStack];
}

- (void)setupCoreData {
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    NSManagedObjectModel *coreDataModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:path];
    
    NSPersistentStoreCoordinator *coreDataPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:coreDataModel];
    NSError *err = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationSupportFolder = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    //NSString *pathToFile = [NSString stringWithFormat:@"%@/db/", applicationSupportFolder];
    if(![fileManager fileExistsAtPath:applicationSupportFolder.path]){
        [fileManager createDirectoryAtPath:applicationSupportFolder.path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSURL *url = [applicationSupportFolder URLByAppendingPathComponent:@"db.sqlite"];
    
    [coreDataPSC addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:url options:nil error:&err];
    
    self.coreDataContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _coreDataContext.persistentStoreCoordinator = coreDataPSC;
}

- (void)save {
    if (_coreDataContext.hasChanges){
        NSError *error = nil;
        [_coreDataContext save:&error];
        NSLog(@"%@", error.description);
    }
}

@end
