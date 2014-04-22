//
//  LoginViewController.m
//  Created by Tom Schoffelen on 21-04-14.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // TODO: remove this (DEBUGGING)
    //[self loginButtonTapped:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginButtonTapped:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    Scholica* scholica = appDelegate.scholica;
    
    [scholica loginInViewController:self
                            success:^(ScholicaLoginStatus status){
                                [appDelegate.controller dismissViewControllerAnimated:YES completion:nil];
                                [[NSUserDefaults standardUserDefaults] setObject:scholica.accessToken forKey:@"ScholicaAccessToken"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [appDelegate getUser];
                            }
                            failure:^(ScholicaLoginStatus status){
                                NSLog(@"Login failure...");
                                
                                if(status == ScholicaLoginStatusInvalidConsumer){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Login error"
                                                                                    message: @"The application is not correctly configured for logging in with Scholica."
                                                                                   delegate: nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil
                                                          ];
                                    [alert show];
                                }
                                if(status == ScholicaLoginStatusNetworkError){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Login error"
                                                                                    message: @"Please check your internet connection and try logging in again."
                                                                                   delegate: nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil
                                                          ];
                                    [alert show];
                                }
                                if(status == ScholicaLoginStatusUnknown){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Login error"
                                                                                    message: @"An unknown error occurred. Please try logging in again."
                                                                                   delegate: nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil
                                                          ];
                                    [alert show];
                                }
                                
                            }
     ];
    
    NSLog(@"Logging in...");
    
}

@end
