//
//  AppDelegate.m
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // Define styles
    NSDictionary *style = @{
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:16.0f]
                            };
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    [[UITextView appearance] setTintColor:[UIColor colorWithRed:0.000 green:0.753 blue:0.761 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:style];
    [[UIBarButtonItem appearance] setTitleTextAttributes:style forState:UIControlStateNormal];
    
    // Initialize Scholica
    self.scholica = [[Scholica alloc]
                     initWithConsumerKey:@"V44weE1HRXdOVWRXV0d4VVYwZWRWRmw0ZEhk561WcHpWMjFHVjJKR2JETl666Up9"
                     secret:@"qlSMmhXVm14a2IxSkdj7f9a4jBaVVVsUldXbGRyWkc5VWJVVjRZMFZvVjFKc2NGaFdha1poVWpGa2NsZHNVbWxTVlhCdlZtM"
                     ];
    
    // TODO: remove this (DEBUGGING)
#if TARGET_IPHONE_SIMULATOR
    self.scholica.authEndPoint = @"http://secure.scholicabeta.com";
    self.scholica.endPoint = @"http://api.scholicabeta.com";
#else
    self.scholica.authEndPoint = @"http://secure.beta.scholica.com";
    self.scholica.endPoint = @"http://api.beta.scholica.com";
#endif
    
    // Create navigation controller
    self.navController = [[UINavigationController alloc] init];
    
    // Append tableviewcontroller
    self.controller = [[TableVIewController alloc] init];
    [self.navController pushViewController:self.controller animated:NO];
    
    // Window configuration
    CGRect frame  = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    // Get storyboard
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // Check if access token is available
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ScholicaAccessToken"];
    if(!accessToken){
        // Show login screen
        [self login:NO];
    }else{
        // Set access token
        self.scholica.accessToken = accessToken;
        [self getUser];
    }
    
    return YES;
}

- (void)login:(BOOL)animated {
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navController presentViewController:vc animated:NO completion:nil];
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ScholicaAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self login:YES];
}

- (void)getUser {
    [self.scholica request:@"/user/me" callback:^(ScholicaRequestResult *result) {
        if(result.status == ScholicaRequestStatusOK){
            // Got user data, save it and start synchronisation
            NSLog(@"Hey you, %@!", [result.data objectForKey:@"name"]);
            self.user = result.data;
            
            // TODO: synchronize data
            if(self.controller){
                [self.controller sync];
            }
        }else if(result.error.code > 900){
            // Show login dialog, but only if the error is a Scholica error, not a network error
            NSLog(@"Scholica error, present login view.");
            [self login:YES];
        }else{
            // Network error, so try again in a couple of seconds
            NSLog(@"Network error, will try again soon.");
            [NSTimer scheduledTimerWithTimeInterval:5.0
                                             target:self
                                           selector:@selector(getUser)
                                           userInfo:nil
                                            repeats:NO];
        }
    }];
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

@end
