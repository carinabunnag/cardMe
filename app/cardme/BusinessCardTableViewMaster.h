//
//  BusinessCardTableViewMaster.h
//  cardme
//
//  Created by Turner Mandeville on 4/28/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "businessCardTableViewCell.h"
//
//@protocol BusinessCardSelectionProtocol <NSObject>
//-(void) loadSelectedBusinessCard: (Card*) businessCard;
//@end

@interface BusinessCardTableViewMaster : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UILabel *textV2;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *textV1;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *cardct;

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) AppDelegate* appdelegate;
//@property (strong, nonatomic) id <BusinessCardSelectionProtocol> detailDelegate;


- (IBAction)signout:(id)sender;

@end
