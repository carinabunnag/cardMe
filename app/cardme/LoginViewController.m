//
//  ViewController.m
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

@synthesize username, password, usernameError, passwordError, login;

-(void) viewDidLoad {
    [super viewDidLoad];
    [usernameError setAlpha:0];
    [passwordError setAlpha:0];
    self.password.secureTextEntry = YES;
    self.appdelegate = [[UIApplication sharedApplication] delegate];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [usernameError setAlpha:0];
    [passwordError setAlpha:0];
}

- (IBAction)loginButton:(id)sender {
    [login setEnabled: NO];
    NSString *username_given = username.text;
    NSString *password_given = password.text;
    
    //Create a reference to a Firebase database URL
    Firebase *check_login = [[Firebase alloc] initWithUrl:@"https://cardmebusinesscard.firebaseio.com"];
    
    //Determine
    [check_login authUser:username_given password:password_given withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error != nil) {
            switch(error.code) {
                case FAuthenticationErrorUserDoesNotExist:
                    [passwordError setAlpha:0];
                    [usernameError setText: @"user does not exist"];
                    [usernameError setAlpha:1];
                    break;
                case FAuthenticationErrorInvalidEmail:
                    [passwordError setAlpha:0];
                    [usernameError setText: @"invalid email address"];
                    [usernameError setAlpha:1];
                    break;
                case FAuthenticationErrorInvalidPassword:
                    [usernameError setAlpha:0];
                    [passwordError setText: @"incorrect password entered"];
                    [passwordError setAlpha:1];
                    break;
                default:
                    NSLog(@"NEW ERROR TYPE: %@", [error description]); break;
            }
            [login setEnabled: YES];
            return;
        }
        else {
            if (self.appdelegate.myCard == NULL || self.appdelegate.myCard.email != username_given) {
                NSLog(@"Reading in my card via login screen, for username : %@", username_given);
                [self.appdelegate readMyCardFromCoreDataWithUsername: username_given];
                NSLog(@"card name: %@\n", self.appdelegate.myCard.email);
            }
//            [self.appdelegate readInMessagesFromFirebase];
            //segue
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        }
    }];
}


- (IBAction)forgotYourPasswordButton:(id)sender {
    //outer alert controller
    UIAlertController* forgotPassword = [UIAlertController alertControllerWithTitle:@"Forgot your password?" message:@"Enter your email, and we'll send you a temporary password" preferredStyle:UIAlertControllerStyleAlert];
    //add text field to alert controller
    [forgotPassword addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"Email", @"Email");
    }];
    
    //outer action
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //get email and firebase ref
        UITextField* email = forgotPassword.textFields.firstObject;
        Firebase* ref = [[Firebase alloc] initWithUrl:@"https://cardmebusinesscard.firebaseio.com/"];
        //reset password, log any errors, and display email sent alert
        [ref resetPasswordForUser:email.text withCompletionBlock:^(NSError *error) {
            if (error) {
                NSLog(@"Error : %@, userinfo : %@", [error localizedDescription], [error userInfo]);
            }
            //inner alert controller
            UIAlertController* emailSent = [UIAlertController alertControllerWithTitle:@"Email sent" message: nil preferredStyle:UIAlertControllerStyleAlert];
            //inner action
            UIAlertAction* oklev2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [emailSent addAction:oklev2];
            [self presentViewController:emailSent animated:YES completion:nil];
        }];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [forgotPassword addAction: ok];
    [forgotPassword addAction: cancel];
    [self presentViewController:forgotPassword animated:YES completion:nil];
}

@end

