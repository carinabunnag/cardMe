//
//  MessageBoxViewController.h
//  cardme
//
//  Created by Turner Mandeville on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "swipeableMessageCell.h"


@interface MessageBoxViewController : UITableViewController <NSFetchedResultsControllerDelegate, swipeableMessageCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *request;
@property (nonatomic, strong) NSPredicate *messageTypePred;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSManagedObjectContext* moc;
@property (nonatomic, strong) AppDelegate *appdelegate;
@property (nonatomic, strong) NSNumber* didFetch;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *msgct;

extern NSInteger numberOfMessages;
-(void) initializeFetchedResultsController;
- (IBAction)signout:(id)sender;


@end
