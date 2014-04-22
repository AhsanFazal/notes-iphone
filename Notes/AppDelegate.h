//
//  AppDelegate.h
//

#import <UIKit/UIKit.h>
#import <Scholica/Scholica.h>
#import "TableVIewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (retain) Scholica *scholica;
@property (strong, nonatomic) TableVIewController *controller;

@property (retain) NSDictionary *user;

- (void)getUser;
- (void)login:(BOOL)animated;
- (void)logout;

@end
