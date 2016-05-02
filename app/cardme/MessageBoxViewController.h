//
//  MessageBoxViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FirebaseUI/FirebaseTableViewDataSource.h>
#import <FirebaseUI/FirebaseArray.h>
#import "AppDelegate.h"
#import "swipeableMessageCell.h"

@interface MessageBoxViewController : UITableViewController <NSFetchedResultsControllerDelegate, swipeableMessageCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext* privateMoc;

@property (strong, nonatomic) FQuery* firebaseSearchQuery;
@property (strong, nonatomic) Firebase* firebaseRootRef;
@property (strong, nonatomic) FirebaseTableViewDataSource* datasource;

@property (nonatomic, strong) AppDelegate *appdelegate;
@property (nonatomic, strong) NSNumber* didFetch;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *msgct;



-(void) initializeFetchedResultsController;
- (IBAction)signout:(id)sender;


@end
