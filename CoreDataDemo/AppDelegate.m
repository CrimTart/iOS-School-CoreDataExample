//
//  AppDelegate.m
//  CoreDataDemo
//
//  Created by iOS-School-1 on 30.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *vc = [[ViewController alloc] init];
    
    UINavigationController *nav = [UINavigationController new];
    nav.viewControllers = @[vc];
    
    window.rootViewController = nav;
    self.window = window;
    [window makeKeyAndVisible];
    return YES;
}

@end
