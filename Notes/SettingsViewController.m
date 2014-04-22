//
//  SettingsViewController.m
//  Created by Tom Schoffelen on 22-04-14.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) return @"Account";
    if(section == 1) return @"Options";
    if(section == 2) return @"Links";
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) return 2;
    if(section == 2 && [MFMailComposeViewController canSendMail]) return 2;
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2 && indexPath.row == 1){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setToRecipients:@[@"support@scholica.com"]];
            [composeViewController setSubject:@"Scholica Notes - Feedback"];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return indexPath.row == 0 && indexPath.section == 0 ? 126 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier;
    switch (indexPath.section) {
        case 0:
            simpleTableIdentifier = @"SimpleAccountItem";
            break;
        case 1:
            simpleTableIdentifier = @"SimpleToggleSwitch";
            break;
            
        default:
            simpleTableIdentifier = @"SimpleLink";
            break;
    }
    
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0){
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        cell.userPicture.layer.cornerRadius = 42;
        cell.userPicture.clipsToBounds = YES;
        
        cell.userName.text = [appDelegate.user objectForKey:@"name"];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [appDelegate.user objectForKey:@"picture"]]];
            if ( data2 == nil ) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell) cell.userPicture.image = [UIImage imageWithData: data2];
            });
        });
    }else if(indexPath.section == 1){
        cell.switchLabel.text = !indexPath.row ? @"Sync over 3G/4G" : @"Open web notes";
    }else if(indexPath.section == 2){
        cell.switchLabel.text = !indexPath.row ? @"Go to Scholica" : @"Send feedback";
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
