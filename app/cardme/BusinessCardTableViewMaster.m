//
//  BusinessCardTableViewMaster.m
//  cardme
//
//  Created by Turner Mandeville on 4/28/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "BusinessCardTableViewMaster.h"
#define INTRO_MESSAGE (-1)
#define MY_CARD (0)
#define BUSINESS_CARD (1)
#define MESSAGE_CARD (2)

static NSString* cardEntityName = @"Card";
static NSString* msgTypeKey = @"cardType";   //plain messages have key -1, card carrying messages have key 1
static NSString* companyKey = @"company";
static NSString* emailKey = @"email";
static NSString* firstNameKey = @"firstName";
static NSString* lastNameKey = @"lastName";
static NSString* positionKey = @"position";
static NSString* templateIDKey = @"templateID";
static NSString* userIDKey = @"userID";
static NSString* versionKey = @"version";
static NSString* cardImageKey = @"cardImage";
static NSString* sharedWithKey = @"sharedWith";

static NSString* firebaseAppURL = @"https://cardmebusinesscard.firebaseio.com/";
@interface BusinessCardTableViewMaster ()

@end

@implementation BusinessCardTableViewMaster

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appdelegate managedObjectContext];
    [self initializeFetchedResultsController];
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.cardct.text = [NSString stringWithFormat: @"%@", [self.appdelegate retrieveCardCt]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appdelegate managedObjectContext];
    [self initializeFetchedResultsController];
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.cardct.text = [NSString stringWithFormat: @"%@", [self.appdelegate retrieveCardCt]];
    
}


- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
   return self.fetchedResultsController.fetchedObjects.count;
}

-(void) initializeFetchedResultsController {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:cardEntityName];
    NSPredicate* fetchPredicate = [NSPredicate predicateWithFormat:@"cardType == 1 AND sharedWith == %@", self.appdelegate.myCard.userID];
    NSSortDescriptor* nameSort = [NSSortDescriptor sortDescriptorWithKey:lastNameKey ascending:YES];
    
    [fetchRequest setPredicate: fetchPredicate];
    [fetchRequest setSortDescriptors:@[nameSort]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate: self];
    
    NSError* err = nil;
    [self.fetchedResultsController performFetch:&err];
    if (err) {
        NSLog(@"There was an error performing the fetch for business card: %@\n%@", [err localizedDescription], [err userInfo]);
        abort();
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    businessCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"businessCardReuse" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell: (businessCardTableViewCell*) cell atIndexPath:(NSIndexPath*)indexPath {
    
    
//    if (indexPath.row == 0) {
//
//        UIImageView* image =[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"BSCard.jpg"]];
//        [cell addSubview: image];
//    }
    NSLog(@"configuring cell\n\n");
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        NSLog(@"No objects were fetched by the fetched results controller\n\n");
        return;
    }
    else if ([indexPath row] >= self.fetchedResultsController.fetchedObjects.count) {
        NSLog(@"Cell index path exceeds fetched results count; doing nothing\n\n");
        return;
    }
    
    //get message from fetched results controller
    Card* businessCard = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    NSLog(@"card retrieved\n\n");
    
    //set card elements from corresponding business card object
    cell.cellData = businessCard;
    cell.name.text = [NSString stringWithFormat: @"%@ %@", businessCard.firstName, businessCard.lastName];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Card* businessCard = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    //setup the correct card template
    self.textV1.text = [NSString stringWithFormat: @"%@ %@", businessCard.firstName, businessCard.lastName];
    
    //create popover view controller with modal presentation style as popover
    UIViewController* popoverVC = [[UIViewController alloc] init];
    popoverVC.view = self.view1;
    
    popoverVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //present the view controller to instantiate the actual popover controller, and get that controller
    [self presentViewController:popoverVC animated:YES completion:nil];
    UIPopoverPresentationController* popoverController = [popoverVC popoverPresentationController];
    
    //configure the controller
    popoverController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
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


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
////     Get the new view controller using [segue destinationViewController].
////     Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString: @"detailView"]) {                    //if segue to detail vc
//        
//        if ([[segue destinationViewController] conformsToProtocol: @protocol(BusinessCardSelectionProtocol)]) {         //if destination vc conforms to businesscard selection protocol, i.e. detail vc
//            
//            self.detailDelegate = [segue destinationViewController];                        //set self detail delegate to destination vc
//            
//            businessCardTableViewCell* cell = [self.tableView cellForRowAtIndexPath: [self.tableView indexPathForSelectedRow]];                                       //get index path of currently selected row, get card at that row
//            Card* businessCard = cell.cellData;
//            NSLog(@"business card is null : %d\n", (businessCard == NULL));
//            [self.detailDelegate loadSelectedBusinessCard: businessCard];                     //pass card to detailDelegate
//        }
//    }
//}


@end














