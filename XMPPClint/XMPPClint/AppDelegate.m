//
//  AppDelegate.m
//  XMPPClint
//
//  Created by qingyun on 16/7/11.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AppDelegate.h"
#import "BCNetConnect.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BOOL connect = [[BCNetConnect shareNetConnect] connect];
    UIViewController *vc;
    //根据连接情况初始化控制器
    if (connect) {
        //显示首页
        vc = [sb instantiateViewControllerWithIdentifier:@"homenav"];
    }else{
        vc = [sb instantiateViewControllerWithIdentifier:@"loginnav"];
    }
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    //得到Delegate对象,判断连接情况
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
