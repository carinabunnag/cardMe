//
//  UserSearchTableViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/26/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "searchResultsTableCell.h"

@interface UserSearchTableViewController : UITableViewController <UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) FQuery* firebaseSearchQuery;
@property (strong, nonatomic) AppDelegate* appDelegate;         //have to set this up when going to this screen
@property (strong, nonatomic) Firebase* firebaseRootRef;
@property (strong, nonatomic) NSMutableArray* firebaseQueryResults;

@end
