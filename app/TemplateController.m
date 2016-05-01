//
//  TemplateController.m
//  cardme
//
//  Created by Carina Bunnag on 4/20/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

#import "TemplateController.h"


@interface TemplateController()

@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@end


@implementation TemplateController
{
    int tag;
}

- (void) setTag:(int) i {
    tag = i;
}

- (int) getTag {
    return tag;
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
//    if (tag.name == 1)
    tag = 1;
//    UILabel *label = (UILabel *)[self viewWithTag:1];
//    tag = (UILabel *)[self viewWithTag:1];
//    printf([self.view tag]);
    NSLog(@"%i", tag);
}

- (IBAction) whenTwoClicked {
    tag = 2;
    NSLog(@"%i", tag);
}

- (IBAction) whenThreeClicked {
    tag = 3;
    NSLog(@"%i", tag);
}

- (IBAction) whenFourClicked {
    tag = 4;
    NSLog(@"%i", tag);
}

- (IBAction) whenFiveClicked {
    tag = 5;
    NSLog(@"%i", tag);
}


@end
