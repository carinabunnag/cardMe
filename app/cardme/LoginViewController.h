//
//  ViewController.h
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "AppDelegate.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *usernameError;
@property (weak, nonatomic) IBOutlet UILabel *passwordError;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) AppDelegate *appdelegate;

-(IBAction)forgotYourPasswordButton:(id)sender;
-(IBAction)loginButton: (id) sender;

@end


