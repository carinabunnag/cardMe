//
//  TemplateController.m
//  cardme
//
//  Created by Carina Bunnag on 4/20/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

#import "TemplateController.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TemplateController()
@property (weak, nonatomic) IBOutlet UIButton *template1;
@property (weak, nonatomic) IBOutlet UIButton *template2;
@property (weak, nonatomic) IBOutlet UIButton *template3;
@property (weak, nonatomic) IBOutlet UIButton *template4;
@property (weak, nonatomic) IBOutlet UIButton *template5;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@end

NSString *imageTextFile;

@implementation TemplateController
{
    int imageTag;
    NSString *companyText;
    NSString *nameText;
    NSString *phoneText;
    NSString *emailText;
}

- (IBAction)companyInput:(id)sender {
    
}

- (IBAction)nameInput:(id)sender {
}

- (IBAction)phoneInput:(id)sender {
}

- (IBAction)emailInput:(id)sender {
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.companyField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

- (IBAction)whenOneClicked {
    imageTag = 1;
    NSLog(@"The image tag is: %i", imageTag);
    
}

- (IBAction) whenTwoClicked {
    imageTag = 2;
    NSLog(@"The image tag is: %i", imageTag);
}

- (IBAction) whenThreeClicked {
    imageTag = 3;
    NSLog(@"The image tag is: %i", imageTag);
}

- (IBAction) whenFourClicked {
    imageTag = 4;
    NSLog(@"The image tag is: %i", imageTag);
}

- (IBAction) whenFiveClicked {
    imageTag = 5;
    NSLog(@"The image tag is: %i", imageTag);
}

- (IBAction) whenSubmitted:(id)sender {
    // add data fields
    companyText = _companyField.text;
    NSLog(@"The company field is: %@", companyText);
    nameText = _nameField.text;
    NSLog(@"The name field is: %@", nameText);
    phoneText = _phoneField.text;
    NSLog(@"The phone field is: %@", phoneText);
    emailText = _emailField.text;
    NSLog(@"The email field is: %@", emailText);
    
//    [self getEncryption];
    //Identify location for screen
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    //Size to screenshot to get business card image - maybe change
    UIGraphicsBeginImageContext(CGSizeMake(329,203));
    //View Controller size is 600 by 600; maybe chage
    
    //Take screenshot of business card region and add to phone's camera roll
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(theImage,nil,NULL,NULL);
    
    NSData*theImageData = UIImageJPEGRepresentation(theImage, 1.0 ); //you can use PNG too
    [theImageData writeToFile:@"blue-whiteCropped.jpg" atomically:YES];
    
    //Encode the screenshot image file into text and store into the firebase
    NSData *imageData = UIImagePNGRepresentation(theImage);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    imageTextFile = base64;
    NSLog(@"%@",imageTextFile);
    //    NSLog(@"encoded string: %@", base64);
    //    encryption = base64;
    //    return encryption;
    
//    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNib:@"HomeViewController" bundle:nil];
//    homeViewController.encryption = base64;
//    [self pushViewController:homeViewController animated:YES];
}

//- (void)getEncryption {
//    //Identify location for screen
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    
//    //Size to screenshot to get business card image - maybe change
//    UIGraphicsBeginImageContext(CGSizeMake(329,203));
//    //View Controller size is 600 by 600; maybe chage
//    
//    //Take screenshot of business card region and add to phone's camera roll
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageWriteToSavedPhotosAlbum(theImage,nil,NULL,NULL);
//    
//    NSData*theImageData = UIImageJPEGRepresentation(theImage, 1.0 ); //you can use PNG too
//    [theImageData writeToFile:@"blue-whiteCropped.jpg" atomically:YES];
//    
//    //Encode the screenshot image file into text and store into the firebase
//    NSData *imageData = UIImagePNGRepresentation(theImage);
//    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
////    NSLog(@"encoded string: %@", base64);
////    encryption = base64;
////    return encryption;
//    
//    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNib:@"HomeViewController" bundle:nil];
//    homeViewController.encryption = base64;
//    [self pushViewController:homeViewController animated:YES];
//}



@end
