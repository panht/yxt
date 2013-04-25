//
//  yxtAppDelegate.m
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtAppDelegate.h"
#import "yxtIndex.h"
#import "yxtLogin.h"

@implementation yxtAppDelegate

@synthesize window;
@synthesize index;
@synthesize login;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 默认打开tab视图
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     //Override point for customization after application launch.
//    [[NSBundle mainBundle] loadNibNamed:@"yxtIndex" owner:self options:nil];
//    [self.window addSubview:self.index.view];
//    self.window.rootViewController = self.index;
//    self.window.backgroundColor = [UIColor whiteColor];
    
    // 默认打开登录视图
    self.login = [[yxtLogin alloc] initWithNibName:@"yxtLogin" bundle:nil];
    self.window.rootViewController = self.login;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) showIndex
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSBundle mainBundle] loadNibNamed:@"yxtIndex" owner:self options:nil];
    self.window.rootViewController = self.index;
    [self.window addSubview:self.index.view];
    [self.window makeKeyAndVisible];
}

//- (void)dealloc {
//    [self.window release];
//    [self.login release];
//    [super dealloc];
//}

@end
