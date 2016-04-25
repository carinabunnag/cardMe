//
//  TemplateController.m
//  cardme
//
//  Created by Carina Bunnag on 4/20/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import "TemplateController.h"

@interface TemplateController()
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@end


@implementation TemplateController

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

@end
