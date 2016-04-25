//
//  ViewController.m
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>

@interface ViewController ()

@end

@implementation ViewController 

@synthesize username, password, Usernew, email, passwordnew, confirmPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
//    // Do any additional setup after loading the view, typically from a nib.

//    // Write data to Firebase
//    [myRootRef setValue:@"Do you have data? You'll love Firebase."];
//    
//    // Read data and react to changes
//    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
//    }];

    
}



- (void) loggingOn {
    
    NSString *username_given = username.text;
    NSString *password_given = password.text;
    
    //Create a reference to a Firebase database URL
    Firebase *check_login = [[Firebase alloc] initWithUrl:@"https://cardmebusinesscard.firebaseio.com"];
    
    //Determine
    [check_login authUser:username_given password:password_given withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            //There was an error finding the account: non-existed or typed incorrectly
        } else {
            //transition to their account
        }
    }];

    

}
- (void) signingUp {
    
    NSString *email_given = Usernew.text;
    NSString *pass_given = passwordnew.text;
    NSString *pass_given2 = confirmPassword.text;
    
    [_signUp setEnabled:NO];
    //Create a reference to the Firebase Database
    Firebase *create_account = [[Firebase alloc] initWithUrl:@"https://cardmebusinesscard.firebaseio.com"];
    
    //Determine passwords are equal & create a new account
    if ( [pass_given isEqualToString:pass_given2]) {
        [_signUp setEnabled:YES];
        [create_account createUser:email_given password:pass_given
          withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
              if (error) {
                  // There was an error creating the account
              } else {
                  NSString *uid = [result objectForKey:@"uid"];
                  NSLog(@"Successfully created user account with uid: %@", uid);
                  printf("New account has been created");
              }
          }];

    } else {
        [_signUp setEnabled:NO];
        printf("Retype password");
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
