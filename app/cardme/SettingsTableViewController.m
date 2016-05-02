//
//  SettingsTableViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "SettingsTableViewController.h"

static 

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labels = @[@"Account", @"General"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.cardCount.text = [NSString stringWithFormat:@"%@", [self.appdelegate retrieveCardCt]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.cardCount.text = [NSString stringWithFormat:@"%@", [self.appdelegate retrieveCardCt]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case (0) : [self changePassword]; break;                                                                           //change password
    }
}

- (void) changePassword {
    NSLog(@"Changing password\n");
    UIAlertController* changePWAlert = [UIAlertController alertControllerWithTitle: @"Enter your old password, and the password you want to change it to" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __block NSString *alertTitle;
    
    [changePWAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Old Password";
        textField.secureTextEntry = YES;
        textField.tag = 100;
    }];
    [changePWAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"New Password";
        textField.secureTextEntry = YES;
        textField.tag = 200;
    }];
    [changePWAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"Confirm New Password";
        textField.secureTextEntry = YES;
        textField.tag = 300;
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* changePW = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Setting up change password action \n");

        //Create a reference to the Firebase Database
        Firebase *update_password = [[Firebase alloc] initWithUrl:@"https://cardmebusinesscard.firebaseio.com"];
        NSString *email_account = self.appdelegate.myCard.email;
        NSLog(@"for user: %@\n", email_account);

        
        NSString *old_password = changePWAlert.textFields[0].text;
        NSString *new_password = changePWAlert.textFields[1].text;
        NSString *confirm_password = changePWAlert.textFields[2].text;
        NSLog(@"old pw: %@, new pw: %@, conf pw: %@ \n", old_password, new_password, confirm_password);

        if ([new_password isEqualToString:confirm_password]) {
            NSLog(@"new passwords are equal\n");
            //Update the password the user has inputted
            [update_password changePasswordForUser:email_account fromOld:old_password toNew:new_password withCompletionBlock: ^(NSError *error){
                if(error) {
                    NSLog(@"Error changing password : %@\n%@\n", [error localizedDescription], [error userInfo]);

                    alertTitle = @"There was an error changing your password!";
//                    UIAlertController* postAttemptAlert = [UIAlertController alertControllerWithTitle: @"There was an error changing your password" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:nil];
//                    [postAttemptAlert addAction:ok];
//                    [self presentViewController:postAttemptAlert animated:YES completion: nil];
                }
                else {
                    NSLog(@"Password successfully change\n");

                    alertTitle = @"Your password was successfully changed!";

//                    UIAlertController* successAlert = [UIAlertController alertControllerWithTitle: @"Your password was successfully changed!" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:nil];
//                    [successAlert addAction:ok];
//                    [self presentViewController:successAlert animated:YES completion: nil];
                }
            }];
        }
        else {                          //pws not equal
            NSLog(@"new passwords are unequal\n");
            alertTitle = @"New passwords don't match";
//            UIAlertController* pwNotEqual = [UIAlertController alertControllerWithTitle:@"New passwords don't match" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:nil];
//            [pwNotEqual addAction:ok];
//            [self presentViewController:pwNotEqual animated:YES completion:nil];
        }
    }];
    
    [changePWAlert addAction:changePW];
    [changePWAlert addAction:cancel];
    
    [self presentViewController:changePWAlert animated:YES completion:^{
        NSLog(@"alert controller completion block with own alert controller post-attemp\n");

        UIAlertController* postAttemptAlert = [UIAlertController alertControllerWithTitle: alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSLog(@"alert title added to completion block alert\n");

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:nil];
        [postAttemptAlert addAction:ok];
        [self presentViewController:postAttemptAlert animated:YES completion: nil];
    }];
}




//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCellReuse" forIndexPath:indexPath];
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
