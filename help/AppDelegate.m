//
//  AppDelegate.m
//  helpSky
//
//  Created by peters on 15/12/24.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器

    self.window.rootViewController=tb;
    //b.创建子控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ViewController" bundle:nil];
    ViewController *c1=[storyboard instantiateViewControllerWithIdentifier:@"ViewCS"];
    c1.tabBarItem.image=[UIImage imageNamed:@"icon-I"];

    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"SecondView" bundle:nil];
    SecondViewController *c2=[storyboard2 instantiateViewControllerWithIdentifier:@"SecondCS"];
    
    c2.tabBarItem.image=[UIImage imageNamed:@"icon-love"];
    
    
    UIStoryboard *storyboard3 = [UIStoryboard storyboardWithName:@"ThirdView" bundle:nil];
    ThirdViewController *c3=[storyboard3 instantiateViewControllerWithIdentifier:@"ThirdCS"];
    c3.tabBarItem.image=[UIImage imageNamed:@"icon-U"];
    
    tb.viewControllers=@[c1,c2,c3];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:c3];
    [self.window.rootViewController addChildViewController:nav];
    [self.window makeKeyAndVisible];
    

    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
        
        if (status == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络已断开,请检查网络设置";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1];
        }
        
    }];
    
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
