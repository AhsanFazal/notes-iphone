//
//  SettingsTableViewCell.m
//  Created by Tom Schoffelen on 22-04-14.
//

#import "SettingsTableViewCell.h"
#import "AppDelegate.h"

@implementation SettingsTableViewCell

@synthesize userPicture = _userPicture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)logoutTapped:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate logout];
}

@end
