//
//  SignupViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/25/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Firebase/Firebase.h>

@interface SignupViewController : UIViewController

@property (strong, nonatomic) Firebase *firebaseRootRef;
@property (strong, nonatomic) Firebase *firebaseUserRef;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end
