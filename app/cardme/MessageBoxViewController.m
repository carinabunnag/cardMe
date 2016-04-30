//
//  MessageBoxViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "MessageBoxViewController.h"
#define INTRO_MESSAGE (-1)
#define MY_CARD (0)
#define BUSINESS_CARD (1)
#define MESSAGE_CARD (2)

static int lastmsgct;

@interface MessageBoxViewController ()

@end

static NSString* cardEntityName = @"Card";
static NSString* cardTypeKey = @"cardType";
static NSString* companyKey = @"company";
static NSString* emailKey = @"email";
static NSString* firstNameKey = @"firstName";
static NSString* lastNameKey = @"lastName";
static NSString* positionKey = @"position";
static NSString* templateIDKey = @"templateID";
static NSString* userIDKey = @"userID";
static NSString* versionKey = @"version";
static NSString* firebaseAppURL = @"https://cardmebusinesscard.firebaseio.com/";

@implementation MessageBoxViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"view did load\n\n");
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"app delegate set\n"); //reading in messages from firebase\n
    [self.appdelegate readInMessagesFromFirebase];
    NSLog(@"initializing fetched results controller\n");//messages from firebase read\n
    [self initializeFetchedResultsController];
    NSLog(@"fetched results controller set\n\n");
    self.didFetch = [NSNumber numberWithBool: YES];
    
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.msgct.text = [NSString stringWithFormat:@"%lu", self.fetchedResultsController.fetchedObjects.count];
    
    if ([self.msgct.text integerValue] > lastmsgct) {
        [self youHaveNewMessagesAlert];
    }

    //add a header
//    UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0,50,self.tableView.frame.size.width, 50)];
//   // UIImageView* headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,30,self.tableView.frame.size.width, 30)];
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20,self.tableView.frame.size.width, 30)];
//    headerLabel.text = @"Swipe to accept or deny message";
//    headerLabel.textAlignment = NSTextAlignmentCenter;
//    [header addSubview:headerLabel];
//    self.tableView.tableHeaderView = header;
//    self.definesPresentationContext = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.didFetch = [NSNumber numberWithBool: NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //make sure this isn't the viewWillAppear that is called right after viewDidLoad
    //should only do all the fetch setup if view is appearing anew, but not being loaded again
    if ([self.didFetch boolValue] == NO) {
        NSLog(@"view will appear refetching messages");
        self.appdelegate = [[UIApplication sharedApplication] delegate];
        [self.appdelegate readInMessagesFromFirebase];
        [self initializeFetchedResultsController];
        if ([self.msgct.text integerValue] > lastmsgct) {
            [self youHaveNewMessagesAlert];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

- (void) youHaveNewMessagesAlert {
    UIAlertController *newMessagesAlert = [UIAlertController alertControllerWithTitle:@"You have new messages!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [newMessagesAlert addAction:ok];
    [self presentViewController:newMessagesAlert animated:YES completion:^{
        lastmsgct = (int)self.fetchedResultsController.fetchedObjects.count;
    }];
}

//swipeable message cell protocol methods
- (void) yesButtonActionForMessage: (Card*) message{
    NSLog(@"Yes button action from delegate\n");
    
    NSString* alertMessage;
    if ([message.cardType integerValue] == MESSAGE_CARD) {        //card, just change card type
        message.cardType = [NSNumber numberWithInt:BUSINESS_CARD];
        alertMessage = @"Card was successfully added to your collection!";
    }
    else {                                                                  //intro message, just remove from core data
        [self.appdelegate deleteCardFromCoreData : message];
        [self.appdelegate saveContext];
        alertMessage = @"Welcome message was successfully removed from your collection!";
    }
    
    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [confirmAlert addAction:ok];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
    
    //reset fetchedResults and table view data
    [self fetchModifiedResults];
    [self.tableView reloadData];
}

/*1) alert confirming that person wants to remove element
 2) if no, return
 3) if yes, remove managedObject from context, update tableView as needed
 */
- (void) noButtonActionForMessage: (Card*) message {
    NSLog(@"No button action from delegate\n");
    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to remove this card?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert action yes selected\n");
        NSLog(@"in message box vc: message null : %d\n", (message == NULL));

        [self.appdelegate deleteCardFromCoreData:message];
        [self.appdelegate saveContext];
        
        //reset fetchedResults and table view data
        [self fetchModifiedResults];
        [self.tableView reloadData];
    }];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No! Take me back!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert action no selected\n");
        NSLog(@"in message box vc: message null : %d\n", (message == NULL));
    } ];
    
    [confirmAlert addAction:yes];
    [confirmAlert addAction:no];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
}

-(void) initializeFetchedResultsController {
    
    //create request with sort descriptor
    self.request = [[NSFetchRequest alloc] initWithEntityName:cardEntityName];
    self.messageTypePred = [NSPredicate predicateWithFormat: @"(cardType == -1) OR (cardType == 2)"];       //predicate based on card being either a card message or an intro message
    self.sort = [NSSortDescriptor sortDescriptorWithKey: lastNameKey ascending:YES];
    
    [self.request setSortDescriptors:@[self.sort]];
    [self.request setPredicate: self.messageTypePred];
    
    //get managed object context from appdelegate
    self.moc = [self.appdelegate managedObjectContext];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

-(void) fetchModifiedResults {

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to fetch modified FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Setting number of rows to fetched results count : %lu\n\n", self.fetchedResultsController.fetchedObjects.count);
    return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    swipeableMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageBoxCell" forIndexPath:indexPath];
    
    NSLog(@"dequeued cell\n\n");

    [self configureCell:cell atIndexPath:indexPath];
    
    NSLog(@"configured cell\n\n");

    return cell;
}



- (void)configureCell: (swipeableMessageCell*) cell atIndexPath:(NSIndexPath*)indexPath
{
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
    Card* message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    NSLog(@"message retrieved\n\n");
    NSString* title;
    if ([message.cardType integerValue] == INTRO_MESSAGE) {       //intro message
        title = @"Welcome to cardMe! Swipe me left to either accept me or reject me!";
    }
    else {                                                                  //card message
        title = [NSString stringWithFormat:@"%@ %@ wants to share their business card with you! Do you want to accept it?", message.firstName, message.lastName];
    }
    
    NSLog(@"title element set\n\n");

    //set cell's and cell's title with name from corresponding managedObject
    [cell.messageLabel setText:title];
    [cell.messageLabel setAlpha: 1.0];
    cell.messageData = message;
    cell.delegate = self;
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
