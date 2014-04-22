//
//  SettingsTableViewCell.h
//  Created by Tom Schoffelen on 22-04-14.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell


// SimpleAccountItem
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UIImageView *userPicture;
@property (nonatomic, weak) IBOutlet UIButton *logoutButton;
- (IBAction)logoutTapped:(id)sender;

// SimpleToggleSwitch
@property (nonatomic, weak) IBOutlet UILabel *switchLabel;

// SimpleLink
@property (nonatomic, weak) IBOutlet UILabel *linkLabel;


@end
