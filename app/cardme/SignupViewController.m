//
//  SignupViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/25/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

#define INTRO_MESSAGE (-1)
#define MY_CARD (0)
#define BUSINESS_CARD (1)
#define MESSAGE_CARD (2)

static NSString* cardEntityName = @"Card";
static NSString* msgTypeKey = @"cardType";   //plain messages have key -1, card carrying messages have key 1
static NSString* companyKey = @"company";
static NSString* emailKey = @"email";
static NSString* firstNameKey = @"firstName";
static NSString* lastNameKey = @"lastName";
static NSString* positionKey = @"position";
static NSString* templateIDKey = @"templateID";
static NSString* userIDKey = @"userID";
static NSString* versionKey = @"version";
static NSString* firebaseAppURL = @"https://cardmebusinesscard.firebaseio.com/";
@implementation SignupViewController
@synthesize email, passwordnew, confirmPassword, emailError,passwordsError, lastname, firstname, lastnameError, firstnameError, delegate, company, position;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [passwordsError setAlpha:0];
    [emailError setAlpha:0];
    [lastnameError setAlpha: 0];
    [firstnameError setAlpha: 0];
    self.passwordnew.secureTextEntry = YES;
    self.confirmPassword.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Firebase *)setFirebaseRootRef {
    if (self.firebaseRootRef == NULL) {
        self.firebaseRootRef = [[Firebase alloc] initWithUrl:firebaseAppURL];
    }
    return self.firebaseRootRef;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100 : [firstnameError setAlpha:0]; break;
        case 200 : [lastnameError setAlpha:0]; break;
        case 300 : [emailError setAlpha:0]; break;
        case 400 : ;
        case 500 : [passwordsError setAlpha: 0]; break;
        default : break;
    }
}

//- (void) textFieldDidEndEditing:(UITextField *)textField {
//    switch (textField.tag) {
//        case 100 : [firstnameError setAlpha:0]; break;
//        case 200 : [lastnameError setAlpha:0]; break;
//        case 300 : [emailError setAlpha:0]; break;
//        case 400 : ;
//        case 500 : [passwordsError setAlpha: 0]; break;
//        default : break;
//    }
//    
//}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)signingUp {
    NSLog(@"signing up\n\n");

    NSString *email_given = email.text;
    NSString *pass_given = passwordnew.text;
    NSString *pass_given2 = confirmPassword.text;
    NSString *lastname_given = lastname.text;
    NSString *firstname_given = firstname.text;
//    NSString *lastname_given = [[NSString alloc]stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: lastname.text]];
//    NSString *firstname_given = [[NSString alloc] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: firstname.text]];
    NSLog(@"created strings\n\n");

    
    if ([lastname_given isEqualToString:@""]) {
        [lastnameError setAlpha:1];
        return;
    }
    else if ([firstname_given isEqualToString:@""]) {
        [firstnameError setAlpha:1];
        return;
    }
    NSLog(@"checked first/last for errors\n\n");

    
    //Create a reference to the Firebase Database
    Firebase *create_account = [[Firebase alloc] initWithUrl:firebaseAppURL];
    NSLog(@"created account ref\n\n");

    //Determine passwords are equal & create a new account
    if ( [pass_given isEqualToString:pass_given2]) {
        [passwordsError setAlpha:0];
        
        [create_account createUser:email_given password:pass_given
          withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
              if (error) {
                  NSLog(@"there was an error creating user");
                  if ([error code] == -9) {
                      [emailError setAlpha:1];
                      [emailError setText:@"Email is already taken"];
                  }
                  else if ([error code] == -5) {
                      [emailError setAlpha:1];
                      [emailError setText:@"Email is invalid. Please use a valid email address."];
                  }
//                  NSLog([NSString stringWithFormat:@"Canonical: %ld", (long)[error code]]);
              }
              else {
                  NSLog(@"account was created\n\n");

                  NSString *uid = [result objectForKey:@"uid"];
                  [self writeNewUserData : uid];
                  NSLog(@"user data was written\n\n");

                  UIAlertController* accountCreatedAlert = [UIAlertController alertControllerWithTitle:@"Account created!" message:@"Your account was successfully created!" preferredStyle: UIAlertControllerStyleActionSheet];
                  
                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                      [self performSegueWithIdentifier:@"toLoginScreen" sender:self];
                  }];
                  
                  NSLog(@"alert was created\n\n");

                  
                  [accountCreatedAlert addAction:defaultAction];
                  
                  NSLog(@"action was added\n\n");
                [self presentViewController:accountCreatedAlert animated:NO completion:nil];

                  
                                                  
                  NSLog(@"Successfully created user account with uid: %@", uid);
              }
          }];
        
    } else {
        [passwordsError setAlpha:1];
        return;
    }
    
    
}

- (void) writeNewUserData: (NSString*) uid {
    NSLog(@"writing user data\n\n");
    [self setFirebaseRootRef];
    
    
    //write to user data
    NSLog(@"writing to firebase\n\n");
    NSLog(@"writing to users\n\n");
    NSString *path = [NSString stringWithFormat:@"users/%@", uid];
    Firebase* userRef = [self.firebaseRootRef childByAppendingPath:path];
    NSDictionary *userInfo = @{lastNameKey : lastname.text, firstNameKey : firstname.text, emailKey : email.text};
    [userRef setValue: userInfo];
    
    NSLog(@"writing to messages\n\n");

    //write to message data
    path = [NSString stringWithFormat:@"messages/%@", uid];
    userRef = [self.firebaseRootRef childByAppendingPath:path];
//    [[userRef childByAutoId] setValue:@"Welcome to cardMe!"];
    [[userRef childByAutoId] setValue: @{ lastNameKey : @"Welcome to cardMe!", firstNameKey : @"", msgTypeKey : [NSNumber numberWithInt: INTRO_MESSAGE]}];           //msg type key signifies that it is not a card-carrying message

    
    NSLog(@"writing to core data\n\n");
    //write to core data
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:cardEntityName inManagedObjectContext:context];
    Card* myCard = [[Card alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    NSLog(@"object created in core data context\n\n");
    
    myCard.cardType = [NSNumber numberWithInt: MY_CARD];
    myCard.templateID = [NSNumber numberWithInt: -1];
    myCard.version = [NSNumber numberWithInt: -1];
    myCard.userID = uid;
    NSLog(@"user id set in core data context\n\n");
    myCard.firstName = firstname.text;
    NSLog(@"firstname set in core data context\n\n");
    myCard.email = email.text;
    NSLog(@"email set in core data context\n\n");
    myCard.lastName = lastname.text;
    NSLog(@"lastname set in core data context\n\n");
    myCard.company = company.text;
    NSLog(@"company set in core data context\n\n");
    myCard.position = position.text;
    NSLog(@"position set in core data context\n\n");



    NSError *err = nil;
    if ([context save:&err] == NO) {
        NSLog(@"Error saving user info to core data");
        exit(-1);
    }
    NSLog(@"core data context successfully saved\n\n");
    //have appdelegate read my card in from card data, since it now exists
    [delegate readMyCardFromCoreData];
}


#pragma mark - Table view data source


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
