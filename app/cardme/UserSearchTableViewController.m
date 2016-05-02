//
//  UserSearchTableViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/26/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "UserSearchTableViewController.h"

#define INTRO_MESSAGE (-1)
#define MY_CARD (0)
#define BUSINESS_CARD (1)
#define MESSAGE_CARD (2)

static NSString* cardEntityName = @"Card";
static NSString* msgTypeKey = @"cardType";   //plain messages have key -1, card carrying messages have key 1
static NSString* companyKey = @"company";
static NSString* sharedWithKey = @"sharedWith";
static NSString* cardImageKey = @"cardImage";
static NSString* emailKey = @"email";
static NSString* firstNameKey = @"firstName";
static NSString* lastNameKey = @"lastName";
static NSString* positionKey = @"position";
static NSString* templateIDKey = @"templateID";
static NSString* userIDKey = @"userID";
static NSString* versionKey = @"version";
static NSString* firebaseAppURL = @"https://cardmebusinesscard.firebaseio.com/";


@interface UserSearchTableViewController ()

@end

@implementation UserSearchTableViewController

@synthesize appdelegate,firebaseSearchQuery,firebaseRootRef,firebaseUserRef,datasource;
//searchController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
////    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonName", @"Name"), NSLocalizedString(@"ScopeButtonUsername", @"Username")];
//    self.searchController.searchBar.delegate = self;
//    [self.searchController.searchBar sizeToFit];
//    
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.searchBar.delegate = self;
    self.username.text = appdelegate.myCard.email;
    self.today.text = [appdelegate getToday];

}

- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    //    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonName", @"Name"), NSLocalizedString(@"ScopeButtonUsername", @"Username")];
//    self.searchController.searchBar.delegate = self;
//    [self.searchController.searchBar sizeToFit];
//    
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self updateSearchResults];
}


#pragma mark - Firebase queries
//searching for person and getting their username
- (BOOL)queryFirebaseUsersForUser: (NSString*) username {
    NSLog(@"Query for user beginning");
    //get reference to site
    if (self.firebaseRootRef == NULL) {
        self.firebaseRootRef = [self.appdelegate getFirebaseRootRef];
    }
    NSLog(@"root ref attached");
    
    //get reference for user list
    Firebase* userListRef = [self.firebaseRootRef childByAppendingPath:@"users"];
    
    //query by child - last name;limit query to last names beginning with the same letter as name
    self.firebaseSearchQuery = [[[userListRef queryOrderedByChild:emailKey] queryStartingAtValue:username] queryLimitedToFirst:10];
    NSLog(@"Query for user ended");
    
    NSLog(@"Setup query results array beginning");
    self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery prototypeReuseIdentifier:@"searchCellReuse" view:self.tableView];
    
    // self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery nibNamed: @"" cellReuseIdentifier:@"searchCellReuse" view:self.tableView];
    
    [self.datasource populateCellWithBlock:^(searchResultsTableCell* cell, FDataSnapshot* snapshot) {
//        NSLog(@"snapshot key: %@ == user id: %@ : %d\n", snapshot.key, appdelegate.myCard.userID, ([snapshot.key isEqualToString: appdelegate.myCard.userID]));
//        if (![snapshot.key isEqualToString: appdelegate.myCard.userID) {
            UILabel *label = (UILabel*)[cell.contentView viewWithTag:100];
            [label setText: snapshot.value[emailKey]];
            
            label = (UILabel*)[cell.contentView viewWithTag:200];
            [label setText: snapshot.value[lastNameKey]];
            
            label = (UILabel*)[cell.contentView viewWithTag:300];
            [label setText: snapshot.value[firstNameKey]];
            
            cell.userID = snapshot.key;
            
            [cell.shared setAlpha: 0.0];
            [cell.shared setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
            NSLog(@"cell user id : %@, snapshot key: %@\n\n", cell.userID, snapshot.key);
//        }
    }];
    [self.tableView setDataSource:self.datasource];
    
    NSLog(@"Setup query results array ending");
    return true;
}

//- (void) setupQueryResultsArray {
//    
//    NSLog(@"Setup query results array beginning");
//    self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery prototypeReuseIdentifier:@"searchCellReuse" view:self.tableView];
//    
//   // self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery nibNamed: @"" cellReuseIdentifier:@"searchCellReuse" view:self.tableView];
//    
//    [self.datasource populateCellWithBlock:^(searchResultsTableCell* cell, FDataSnapshot* snapshot) {
//        if (snapshot.key != appdelegate.myCard.userID) {
//            UILabel *label = (UILabel*)[cell.contentView viewWithTag:100];
//            [label setText: snapshot.value[emailKey]];
//        
//            label = (UILabel*)[cell.contentView viewWithTag:200];
//            [label setText: snapshot.value[lastNameKey]];
//
//            label = (UILabel*)[cell.contentView viewWithTag:300];
//            [label setText: snapshot.value[firstNameKey]];
//        
//            cell.userID = snapshot.key;
//        
//            [cell.shared setAlpha: 0.0];
//            [cell.shared setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
//            NSLog(@"cell user id : %@, snapshot key: %@\n\n", cell.userID, snapshot.key);
//        }
//    }];
//    [self.tableView setDataSource:self.datasource];
//    
//    NSLog(@"Setup query results array ending");
//}


#pragma mark - Search Controller stuff
- (void)updateSearchResults
{
    NSString *searchString = self.searchBar.text;
    
    [self queryFirebaseUsersForUser:searchString];
//    [self setupQueryResultsArray];
    [self.tableView reloadData];
}



//
//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
////    [self updateSearchResultsForSearchController:self.searchController];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.datasource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.datasource == NULL) {
        return 0;
    }
    else {
        return [self.datasource tableView:self.tableView numberOfRowsInSection:section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.datasource tableView:self.tableView cellForRowAtIndexPath:indexPath];
}

- (void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //user selected a cell
    searchResultsTableCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"User selected row with info : user id %@, first %@, last %@", cell.userID, cell.firstname.text, cell.lastname.text);

    //show alert message saying that by clicking ok, will share own card with someone else
    NSString* alertMessage = [NSString stringWithFormat:@"Please confirm that you want to share your business card with %@ %@", cell.firstname.text, cell.lastname.text];
    
    UIAlertController *confirmShareAlert = [UIAlertController alertControllerWithTitle:@"Confirm share" message: alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    //for ok in alert message, add my card information to other users message box
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.appdelegate == NULL) {
            self.appdelegate = [[UIApplication sharedApplication] delegate];
        }
        //sample card for testing:
        Card* myCard = [appdelegate myCard];
        
        if (([appdelegate shareCard: myCard WithUser:cell.userID]) == FALSE) {
           //share failed
            UIAlertController* failAlert = [UIAlertController alertControllerWithTitle:@"Share failed!" message:@"An error occurred while sharing your card. Please try again later" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:failAlert animated:YES completion:nil];
        }
        else {
        //SHOW ALERT SAYING THAT SHARE SUCCEEDED
            UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Share succeeded!" message:@"Your card was successfully shared!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [successAlert addAction: ok];
            [self presentViewController:successAlert animated:YES completion:nil];
            [cell.shared setAlpha:1.0];
            [cell.shared setBackgroundColor:[UIColor greenColor]];
        }
        
    }];
    
    //for cancel, return to main storyboard
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler: nil];
    
    
    [confirmShareAlert addAction:yesAction];
    [confirmShareAlert addAction: noAction];
    
    [self presentViewController:confirmShareAlert animated:YES completion:nil];
}


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
