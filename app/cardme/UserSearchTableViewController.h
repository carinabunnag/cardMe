//
//  UserSearchTableViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/26/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <FirebaseUI/FirebaseTableViewDataSource.h>
#import "AppDelegate.h"
#import "searchResultsTableCell.h"


@interface UserSearchTableViewController : UITableViewController <UISearchBarDelegate>
//UISearchControllerDelegate, UISearchResultsUpdating

//@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) AppDelegate* appdelegate;         //have to set this up when going to this screen
@property (strong, nonatomic) FQuery* firebaseSearchQuery;
@property (strong, nonatomic) Firebase* firebaseRootRef;
@property (strong, nonatomic) Firebase* firebaseUserRef;
@property (strong, nonatomic) FirebaseTableViewDataSource* datasource;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *ct;


- (IBAction)signout:(id)sender;

@end
