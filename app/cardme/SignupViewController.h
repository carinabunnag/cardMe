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
#import "AppDelegate.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Firebase *firebaseRootRef;
@property (strong, nonatomic) Firebase *firebaseUserRef;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *passwordnew;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *position;

@property (weak, nonatomic) IBOutlet UIButton *signUp;


@property (weak, nonatomic) IBOutlet UILabel *emailError;
@property (weak, nonatomic) IBOutlet UILabel *passwordsError;
@property (weak, nonatomic) IBOutlet UILabel *lastnameError;
@property (weak, nonatomic) IBOutlet UILabel *firstnameError;

@property (weak, nonatomic) AppDelegate* delegate;

-(IBAction)signingUp;
@end
