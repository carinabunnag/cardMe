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


@implementation MessageBoxViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"VIEW DID LOAD\n\n");
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"app delegate set\n"); //reading in messages from firebase\n
    [self readInMessagesFromFirebase];
    NSLog(@"initializing fetched results controller\n");//messages from firebase read\n
    
    self.privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [self.privateMoc setParentContext:[self.appdelegate managedObjectContext]];
    
    //    [self initializeFetchedResultsController];
    NSLog(@"fetched results controller set\n\n");
    self.didFetch = [NSNumber numberWithBool: YES];
    
    self.username.text = self.appdelegate.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.msgct.text = [NSString stringWithFormat:@"%lu", self.datasource.count];
    
    if (self.datasource.count > lastmsgct) {
        [self youHaveNewMessagesAlert];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.didFetch = [NSNumber numberWithBool: NO];
    
    //save private queue moc stuff to general queue
    [self.privateMoc save: nil];
    
    //now save general queue managed object context
    [self.appdelegate saveContext];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //    NSLog(@"VIEW WILL APPEAR\n\n");
    //make sure this isn't the viewWillAppear that is called right after viewDidLoad
    //should only do all the fetch setup if view is appearing anew, but not being loaded again
    if ([self.didFetch boolValue] == NO) {
        NSLog(@"view will appear refetching messages");
        self.appdelegate = [[UIApplication sharedApplication] delegate];
        self.privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
        [self.privateMoc setParentContext:[self.appdelegate managedObjectContext]];
        [self readInMessagesFromFirebase];
        //        [self.appdelegate readInMessagesFromFirebase];
        //        [self initializeFetchedResultsController];
        self.msgct.text = [NSString stringWithFormat:@"%lu", self.datasource.count];
        if (self.datasource.count > lastmsgct) {
            [self youHaveNewMessagesAlert];
        }
        [self.tableView reloadData];
    }
    
}

- (BOOL) readInMessagesFromFirebase {
    NSLog(@"Query for user beginning");
    //get reference to site
    if (self.firebaseRootRef == NULL) {
        self.firebaseRootRef = [self.appdelegate getFirebaseRootRef];
    }
    NSLog(@"root ref attached");
    
    NSString* messageBoxName = [NSString stringWithFormat:@"messages/%@", self.appdelegate.myCard.userID];
    //get reference for user list
    Firebase* myMessageBox = [self.firebaseRootRef childByAppendingPath:messageBoxName];
    
    //query by child - last name;limit query to last names beginning with the same letter as name
    self.firebaseSearchQuery = [myMessageBox queryOrderedByKey];
    NSLog(@"Query for messages ended");
    
    NSLog(@"Setup query results array beginning");
    self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery prototypeReuseIdentifier:@"messageBoxCell" view:self.tableView];
    
    // self.datasource = [[FirebaseTableViewDataSource alloc] initWithQuery:self.firebaseSearchQuery nibNamed: @"" cellReuseIdentifier:@"searchCellReuse" view:self.tableView];
    
    [self.datasource populateCellWithBlock:^(swipeableMessageCell* cell, FDataSnapshot* snapshot) {
        if ([snapshot.value[msgTypeKey] integerValue] == MESSAGE_CARD) {
            cell.messageLabel.text = [NSString stringWithFormat:@"Message from %@ %@. Would you like to receive it?", snapshot.value[firstNameKey], snapshot.value[lastNameKey]];
            cell.messageRef = snapshot.ref;
        }
        else {      //intro message
            cell.messageLabel.text = [NSString stringWithFormat: @"Welcome to CardMe!"];
            cell.messageRef = snapshot.ref;
        }
        cell.delegate = self;
    }];
    
    [self.tableView setDataSource:self.datasource];
    
    NSLog(@"Setup query results array ending");
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

- (void) yesButtonActionForMessage:(Firebase *)messageRef {
    /*
     1) if normal message,
     a) add it to core data
     b) remove its reference
     2) if intro message, delete it
     */
    [self.privateMoc performBlockAndWait:^{
        __block Card* newCard;
        [messageRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"adding: %@", snapshot.value[emailKey]);
            if ([snapshot.value[msgTypeKey] integerValue] == MESSAGE_CARD) {
                newCard = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:self.privateMoc];
                if (snapshot.value[firstNameKey] != [NSNull null]) {
                    newCard.firstName = snapshot.value[firstNameKey];
                }
                if (snapshot.value[lastNameKey] != [NSNull null]) {
                    newCard.lastName = snapshot.value[lastNameKey];
                }
                if (snapshot.value[companyKey] != [NSNull null]) {
                    newCard.company = snapshot.value[companyKey];
                }
                if (snapshot.value[positionKey] != [NSNull null]) {
                    newCard.position = snapshot.value[positionKey];
                }
                if (snapshot.value[emailKey] != [NSNull null]) {
                    newCard.email = snapshot.value[emailKey];
                }
                if (snapshot.value[sharedWithKey] != [NSNull null]) {
                    newCard.sharedWith = snapshot.value[sharedWithKey];
                }
                if (snapshot.value[userIDKey] != [NSNull null]) {
                    newCard.userID = snapshot.value[userIDKey];
                }
                newCard.cardType = [NSNumber numberWithInt: BUSINESS_CARD];
            }
        }];
        NSError* err = nil;
        [self.privateMoc save:&err];
        if (err) {
            NSLog(@"Error occurred trying to save private moc\n%@\n%@\n", [err localizedDescription], [err userInfo]);
        }
        else {
            NSLog(@"Success!");
        }
    }];
    
    [messageRef removeValue];
}

- (void) noButtonActionForMessage:(Firebase *)messageRef {
    /*
     1) remove its reference
     add confirmation alert later
     */
    NSLog(@"message ref: %@", [messageRef description]);
    [messageRef removeValue];
    
}

- (void) youHaveNewMessagesAlert {
    UIAlertController *newMessagesAlert = [UIAlertController alertControllerWithTitle:@"You have new messages!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [newMessagesAlert addAction:ok];
    [self presentViewController:newMessagesAlert animated:YES completion:^{
        lastmsgct = (int)self.datasource.count;
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 1;
    return [self.datasource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.fetchedResultsController.fetchedObjects.count;
    if (self.datasource == NULL) {
        return 0;
    }
    else {
        return [self.datasource tableView:self.tableView numberOfRowsInSection:section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    swipeableMessageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"messageBoxCell" forIndexPath:indexPath];
    //    return [self.datasource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    //    [self configureCell: cell atIndexPath:indexPath];
    //    return cell;
    
    return [self.datasource tableView:self.tableView cellForRowAtIndexPath:indexPath];
}



//- (void)configureCell: (swipeableMessageCell*) cell atIndexPath:(NSIndexPath*)indexPath
//{
//    //get message from fetched results controller
//    Card* message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    NSLog(@"%ld. configuring for cell with data : %@", (long)indexPath.row, message.email);
//    NSString* title;
//    if ([message.cardType integerValue] == INTRO_MESSAGE) {       //intro message
//        title = @"Welcome to cardMe!";
//    }
//    else {                                                                  //card message
//        title = [NSString stringWithFormat:@"%@ %@ wants to share their business card with you! Do you want to accept it?", message.firstName, message.lastName];
//    }
//
//    //NSLog(@"title element set\n\n");
//
//    //set cell's and cell's title with name from corresponding managedObject
//    [cell.messageLabel setText:title];
//    [cell.messageLabel setAlpha: 1.0];
//    cell.messageData = message;
//    cell.delegate = self;
//}
//

/*
 1)
 
 */

//swipeable message cell protocol methods
//- (void) yesButtonActionForMessage: (Card*) message{
//    if (self.appdelegate == NULL) {
//        self.appdelegate = [[UIApplication sharedApplication] delegate];
//    }
//    NSLog(@"Yes button action from delegate\n");
//    lastmsgct--;
//    NSString* alertMessage;
//
//    if ([message.cardType integerValue] == MESSAGE_CARD) {
//        [self.privateMoc performBlockAndWait:^{
//            message.cardType = [NSNumber numberWithInt:BUSINESS_CARD];
//            [self.privateMoc save:nil];
//        }];
//    }
//    else {
//        [self.privateMoc performBlockAndWait:^{
//            [self.privateMoc deleteObject: message];
//            [self.privateMoc save:nil];
//        }];
//    }
//
////        [message observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
////            if ([snapshot.value[msgTypeKey] integerValue] == MESSAGE_CARD) {      //add card
////                Card* newCard = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:self.moc];
////                newCard.cardType = [NSNumber numberWithInt: BUSINESS_CARD];
////                newCard.firstName = snapshot.value[firstNameKey];
////                newCard.lastName = snapshot.value[lastNameKey];
////                newCard.company = snapshot.value[companyKey];
////                newCard.position = snapshot.value[positionKey];
////
////                [self.appdelegate saveContext];
////                self.msgct.text = [NSString stringWithFormat:@"%ld", ([self.msgct.text integerValue] - 1)];
////                alertMessage = @"Card was successfully added to your collection!";
////            }
////            [message removeValue];
////        }
////    ];
//    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [confirmAlert addAction:ok];
//
//    [self presentViewController:confirmAlert animated:YES completion:nil];
//
//    //reset fetchedResults and table view data
//    [self fetchModifiedResults];
//    [self.tableView reloadData];
//}
//
///*1) alert confirming that person wants to remove element
// 2) if no, return
// 3) if yes, remove managedObject from context, update tableView as needed
// */
//- (void) noButtonActionForMessage: (Card*) message {
//    if (self.appdelegate == NULL) {
//        self.appdelegate = [[UIApplication sharedApplication] delegate];
//    }
//    NSLog(@"No button action from delegate\n");
//    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to remove this card?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"alert action yes selected\n");
//        NSLog(@"in message box vc: message null : %d\n", (message == NULL));
//        lastmsgct--;
//        self.msgct.text = [NSString stringWithFormat:@"%ld", ([self.msgct.text integerValue] - 1)];
//
//        [self.privateMoc performBlockAndWait:^{
//            [self.privateMoc deleteObject: message];
//            [self.privateMoc save:nil];
//        }];
//
//        //reset fetchedResults and table view data
//        [self fetchModifiedResults];
//        [self.tableView reloadData];
//    }];
//
//    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No! Take me back!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"alert action no selected\n");
//        NSLog(@"in message box vc: message null : %d\n", (message == NULL));
//    } ];
//
//    [confirmAlert addAction:yes];
//    [confirmAlert addAction:no];
//
//    [self presentViewController:confirmAlert animated:YES completion:nil];
//}
//


////populates message box with messages from firebase
//- (BOOL) readInMessagesFromFirebase {
//    NSLog(@"Reading in messages from firebase\n");
//
//    //get reference to user's message box on firebase
//    NSString* myMessageBoxName = [[NSString alloc] initWithFormat:@"messages/%@", self.appdelegate.myCard.userID];
//    NSLog(@"message box name: %@\n", myMessageBoxName);
//    Firebase* myMessageBoxRef = [[self.appdelegate getFirebaseRootRef] childByAppendingPath:myMessageBoxName];
//    NSLog(@"message box ref address: %@\n", myMessageBoxRef.description);
//
//
//    //create managed object context reference
//    NSManagedObjectContext *context = [self.appdelegate managedObjectContext];
//
//    //read messages from firebase to managed object - possibly change this to a handle later
//    [myMessageBoxRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"snapshot key: %@, snapshot value for last : %@, snapshot value for first : %@",snapshot.key, snapshot.value[lastNameKey], snapshot.value[firstNameKey]);
//
//        if (snapshot.value == [NSNull null]) {
//            NSLog(@"An error occured reading snapshot values from Firebase");
//            return;
//        }
//        else if ([snapshot.value[msgTypeKey] integerValue] == INTRO_MESSAGE) {           //welcome message
//            NSLog(@"Adding intro welcome message\n\n");
//            Card *newMessage = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:context];
//            newMessage.sharedWith = self.appdelegate.myCard.userID;
//            newMessage.lastName = snapshot.value[lastNameKey];
//            newMessage.firstName = @"";
//            newMessage.cardType = [NSNumber numberWithInt: INTRO_MESSAGE];
//
//        }
//        else if ([snapshot.value[msgTypeKey] integerValue] == MESSAGE_CARD){
//            NSLog(@"ADDING REGULAR CARD MESSAGE for user : %@\n\n", snapshot.value[emailKey]);
//            //card-carrying messages
//            Card *newMessage = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:context];
//            newMessage.sharedWith = snapshot.value[sharedWithKey];
//            newMessage.company = snapshot.value[companyKey];
//            newMessage.email = snapshot.value[emailKey];
//            newMessage.firstName = snapshot.value[firstNameKey];
//            newMessage.lastName = snapshot.value[lastNameKey];
//            newMessage.position = snapshot.value[positionKey];
//            newMessage.templateID = snapshot.value[templateIDKey];
//            newMessage.userID = snapshot.value[userIDKey];
//            newMessage.version = snapshot.value[versionKey];
//            newMessage.cardType = [NSNumber numberWithInt: MESSAGE_CARD];
//
//        }
//        [context save:nil];
//    }];
//
//    //save context DOES THIS NEED TO BE IN BLOCK?????
//
//    //delete messages from firebase
//    [myMessageBoxRef removeAllObservers];
//    [myMessageBoxRef removeValue];
//
//    [self initializeFetchedResultsController];
//    [self.tableView reloadData];
//    return true;
//}

//-(void) initializeFetchedResultsController {
//    self.fetchedResultsController = NULL;
//    //create request with sort descriptor
//    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:cardEntityName];
//    NSPredicate* messageTypePred = [NSPredicate predicateWithFormat: @"((cardType == -1) OR (cardType == 2))"];       //predicate based on card being either a card message or an intro message
//    NSPredicate* pred2 = [NSPredicate predicateWithFormat:@"sharedWith == %@", self.appdelegate.myCard.userID];
//    NSCompoundPredicate* comppred = [NSCompoundPredicate andPredicateWithSubpredicates:@[messageTypePred, pred2]];
//    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey: lastNameKey ascending:YES];
//
//    [request setSortDescriptors:@[sort]];
//    [request setPredicate: comppred];
//
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.privateMoc sectionNameKeyPath:nil cacheName:nil];
//    [self.fetchedResultsController setDelegate:self];
//
//    NSError *error = nil;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
//        abort();
//    }
//}
//
//-(void) fetchModifiedResults {
//    NSError *error = nil;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Failed to fetch modified FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
//        abort();
//    }
//}
//


@end