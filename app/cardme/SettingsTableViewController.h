//
//  SettingsTableViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SettingsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray* labels;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *lastLogin;
@property (weak, nonatomic) IBOutlet UILabel *cardCount;

@property (strong, nonatomic) AppDelegate* appdelegate;

- (IBAction)signout:(id)sender;

@end
