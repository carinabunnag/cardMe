//
//  UserSearchTableViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/26/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "UserSearchTableViewController.h"

static NSString* companyKey = @"company";
static NSString* emailKey = @"email";
static NSString* firstNameKey = @"firstName";
static NSString* lastNameKey = @"lastName";
static NSString* positionKey = @"position";
static NSString* templateIDKey = @"templateID";
static NSString* userIDKey = @"userID";
static NSString* versionKey = @"version";
@interface UserSearchTableViewController ()

@end

@implementation UserSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonName", @"Name"), NSLocalizedString(@"ScopeButtonUsername", @"Username")];
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Firebase queries
//searching for person and getting their username
- (BOOL)queryFirebaseUsersForPerson: (NSString*) name {
    //get reference to site
    if (self.firebaseRootRef == NULL) {
        self.firebaseRootRef = [self.appDelegate getFirebaseRootRef];
    }
    //get reference for user list
    Firebase* userListRef = [self.firebaseRootRef childByAppendingPath:@"users"];
    
    //query by child - last name;limit query to last names beginning with the same letter as name
    self.firebaseSearchQuery = [[[userListRef queryOrderedByChild:lastNameKey] queryStartingAtValue:name] queryLimitedToFirst:10];
    
    [self setupQueryResultsArray];
    return true;
}

//searching for person and getting their username
- (BOOL)queryFirebaseUsersForUser: (NSString*) username {
    //get reference to site
    if (self.firebaseRootRef == NULL) {
        self.firebaseRootRef = [self.appDelegate getFirebaseRootRef];
    }
    //get reference for user list
    Firebase* userListRef = [self.firebaseRootRef childByAppendingPath:@"users"];
    
    //query by child - last name;limit query to last names beginning with the same letter as name
     self.firebaseSearchQuery = [[[userListRef queryOrderedByKey] queryStartingAtValue:username] queryLimitedToFirst:10];
    [self setupQueryResultsArray];
     return true;
}

- (void) setupQueryResultsArray {
    if (self.firebaseQueryResults == NULL) {
        self.firebaseQueryResults = [[NSMutableArray alloc] initWithCapacity:10];
    }
    else {              //clear objects currently in array
        [self.firebaseQueryResults removeAllObjects];
    }
    
    [self.firebaseSearchQuery observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        for (FDataSnapshot* child in snapshot.children) {
            //each child of the snapshot is a user, create an array with lastname, firstname, and username - which ends up just being the key
            NSMutableArray*  nextUser = [[NSMutableArray alloc] initWithObjects:child.key,child.value[lastNameKey], child.value[firstNameKey]];
            [self.firebaseQueryResults addObject: nextUser];
        }
        
    }];
}


#pragma mark - Search Controller stuff
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    //determine if search should be done by username or by lastname
    
    //perform search query, and place results in firebaseSearchQuery property
    //if by lastname:
    [self queryFirebaseUsersForPerson:searchString];
    
    //if by username:
    [self queryFirebaseUsersForUser:searchString];
    
    [self.tableView reloadData];
}




- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.firebaseQueryResults == NULL) {
        return 0;
    }
    else {
        return self.firebaseQueryResults.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    searchResultsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    NSMutableArray *user = [self.firebaseQueryResults objectAtIndex:indexPath];
    if (user == NULL) {
        [cell.username setText: user[0]];
        [cell.lastname setText: user[1]];
        [cell.firstname setText: user[2]];
    }
    
    
    return cell;
}

- (void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //user selected a cell
    //show alert message saying that by clicking ok, will share own card with someone else
    //for ok in alert message, add my card information to other users message box
    //for cancel, return to main storyboard
    
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
