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

@implementation SignupViewController


- (IBAction)signupButton:(id)sender {
    //get firebase reference
    if (_firebaseRootRef == NULL) {
    }
    
    //check if username exists
    
    //if username exists, cancel, return to screen with message saying that username already exists
    
    //otherwise, add the username to firebase db
    //create core data for user
    //show some sort of confirmation alert, go back to main menu
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
