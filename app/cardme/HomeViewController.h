//
//  HomeViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TemplateController.h"
@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *lastlogin;
@property (weak, nonatomic) IBOutlet UILabel *cardct;

@property (weak, nonatomic) AppDelegate* appdelegate;
@property (weak, nonatomic) Card* myCard;

@property (nonatomic) NSString *encryption;

- (IBAction)signout:(id)sender;

@end
