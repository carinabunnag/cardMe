//
//  ViewController.h
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>


//issue too many attachments, address later
@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) IBOutlet UITextField *password;



@property (strong, nonatomic) IBOutlet UIButton *login;

@property (strong, nonatomic) IBOutlet UIButton *signUp;




@property (strong, nonatomic) IBOutlet UITextField *Usernew;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *passwordnew;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;


-(IBAction)loggingOn;
-(IBAction)signingUp;
-(void)authUser:(NSString *)email password:(NSString *)password withCompletionBlock:(void ( ^ ) ( NSError *error , FAuthData *authData ))block; 
@end

