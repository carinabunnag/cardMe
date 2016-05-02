//
//  AppDelegate.m
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "AppDelegate.h"
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
static NSString* firebaseAppURL = @"https://cardmebusinesscard.firebaseio.com/";

@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //read my card from core data
    
    //[self deleteAllCardsFromCoreData];
    
    [self readMyCardFromCoreData];
    [self retrieveCardCt];
    [self getToday];
    
    return YES;
}

- (NSString*) getToday {
    if (self.today == NULL) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: [NSDate date]];
        self.today = [NSString stringWithFormat: @"%ld/%ld/%ld", (long)[components day], (long)[components month], (long)[components year]];
    }
    return self.today;
}

//- (Card*) getMyCard {
//    if (self.myCard == NULL) {
//        [self readMyCardFromCoreData];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Firebase Interaction

- (Firebase*)getFirebaseRootRef {
    if (_firebaseRootRef) {
        return _firebaseRootRef;
    }
    _firebaseRootRef = [[Firebase alloc] initWithUrl: firebaseAppURL];
    return _firebaseRootRef;
}

- (Firebase*)getFirebaseUserRefForUser: (NSString*) username {
    if (self.firebaseRootRef) {
        [_firebaseUserRef childByAppendingPath:[NSString stringWithFormat:@"users/%@", username]];
    }
    return _firebaseUserRef;
}



- (NSNumber*) retrieveCardCt {
    if (self.cardct != NULL) {
        return self.cardct;
    }
    
    NSManagedObjectContext* moc = [self managedObjectContext];
    NSFetchRequest* requestToCt = [[NSFetchRequest alloc] initWithEntityName:cardEntityName];
    NSPredicate* predCt = [NSPredicate predicateWithFormat:@"cardType == %d", BUSINESS_CARD];
    [requestToCt setPredicate:predCt];
    
    NSError *error = nil;
    self.cardct = [NSNumber numberWithInteger:([moc countForFetchRequest:requestToCt error:&error])];
    if (error) {
        NSLog(@"There was an error getting the card count%@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    return self.cardct;
}

- (void) deleteCardFromCoreData : (Card*) message {
    NSLog(@"in app delegate: message null : %d\n", (message == NULL));
    NSManagedObjectContext* moc = [self managedObjectContext];
    [moc deleteObject:message];
}

- (void) deleteAllCardsFromCoreData {
    NSLog(@"Deleting all cards from core data\n");
    NSManagedObjectContext* moc = [self managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:cardEntityName];
    NSBatchDeleteRequest* delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest: request];
    NSError *error = nil;
    
    [self.persistentStoreCoordinator executeRequest:delete withContext:moc error:&error];
    if (error) {
        NSLog(@"There was an error performing the batch delete\n%@\n%@", [error localizedDescription], [error userInfo]);
    }
    else {
        NSLog(@"Batch delete completed!");
    }
}


- (void) signOut {
    [self.firebaseRootRef unauth];
    
}



//populates message box with messages from firebase
- (BOOL) readInMessagesFromFirebase {
    NSLog(@"Reading in messages from firebase\n");
    
    //get reference to user's message box on firebase
    NSString* myMessageBoxName = [[NSString alloc] initWithFormat:@"messages/%@", self.myCard.userID];
    Firebase* myMessageBoxRef = [self.getFirebaseRootRef childByAppendingPath:myMessageBoxName];
    
    //create managed object context reference
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    //read messages from firebase to managed object -- possibly change this to a handle later
    [myMessageBoxRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"in appdelegate: snapshot key: %@, snapshot value for last : %@, snapshot value for first : %@",snapshot.key, snapshot.value[lastNameKey], snapshot.value[firstNameKey]);
        
        if (snapshot.value == [NSNull null]) {
            NSLog(@"An error occured reading snapshot values from Firebase");
            return;
        }
        else if ([snapshot.value[msgTypeKey] integerValue] == INTRO_MESSAGE) {           //welcome message
            NSLog(@"Adding intro welcome message\n\n");
            Card *newMessage = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:context];
            newMessage.lastName = snapshot.value[lastNameKey];
            newMessage.firstName = @"";
            newMessage.cardType = [NSNumber numberWithInt: INTRO_MESSAGE];
            
            [snapshot.ref onDisconnectRemoveValue];
        }
        else if ([snapshot.value[msgTypeKey] integerValue] == MESSAGE_CARD){
            
            //card-carrying messages
            Card *newMessage = [NSEntityDescription insertNewObjectForEntityForName:cardEntityName inManagedObjectContext:context];
            NSLog(@"Adding card message\n\n");
            newMessage.company = snapshot.value[companyKey];
            newMessage.email = snapshot.value[emailKey];
            newMessage.firstName = snapshot.value[firstNameKey];
            newMessage.lastName = snapshot.value[lastNameKey];
            newMessage.position = snapshot.value[positionKey];
            newMessage.templateID = snapshot.value[templateIDKey];
            newMessage.userID = snapshot.value[userIDKey];
            newMessage.version = snapshot.value[versionKey];
            newMessage.cardType = [NSNumber numberWithInt: MESSAGE_CARD];
        }
        

    }];
    //save context DOES THIS NEED TO BE IN BLOCK?????
    NSError* err;
    if (([context save: &err]) != YES) {
        NSLog(@"there was an error saving the context\n\n");
    }
    
    //delete messages from firebase
    [myMessageBoxRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Removing messages from firebase\n\n");
        [snapshot.ref onDisconnectRemoveValue];
    }];
    
    return true;
}

- (void) readMyCardFromCoreData {
    NSManagedObjectContext* moc = [self managedObjectContext];
    NSFetchRequest* myCardRequest = [NSFetchRequest fetchRequestWithEntityName:cardEntityName];
    NSPredicate* myCardPredicate = [NSPredicate predicateWithFormat: @"cardType == %d", MY_CARD];
    [myCardRequest setPredicate: myCardPredicate];

    NSError *error = nil;
    NSArray *myCardResults = [moc executeFetchRequest:myCardRequest error:&error];
    if (error) {
        NSLog(@"err: %@, localized err: %@\n\n", [error description], [error localizedDescription]);
        return;

    }
    else if ([myCardResults count] == 0){
        NSLog(@"user has not created a card yet\n\n");
        return;
    }
    else {
        self.myCard = (Card*)myCardResults[0];
        NSLog(@"my card is null: %d\n", (self.myCard == NULL));
        if (!(self.myCard == NULL)) {
            NSLog(@"my card name: %@\n", self.myCard.firstName);
        }
        for (int i = 0; i < [myCardResults count]; i++) {
            
            NSLog(@"%@\n", ((Card*)myCardResults[i]).firstName);
        }
    }
}

- (void) readMyCardFromCoreDataWithUsername: (NSString*) username {
    NSManagedObjectContext* moc = [self managedObjectContext];
    NSFetchRequest* myCardRequest = [NSFetchRequest fetchRequestWithEntityName:cardEntityName];
    NSPredicate* myCardPredicate = [NSPredicate predicateWithFormat: @"cardType == %d AND email == %@", MY_CARD, username];
//    NSPredicate* myUsernamePredicate = [NSPredicate predicateWithFormat:@"email == %@", username];
//    NSCompoundPredicate* compoundPredicate = [[NSCompoundPredicate alloc] initWithType: NSAndPredicateType subpredicates: @[myCardPredicate, myUsernamePredicate]];
//    [myCardRequest setPredicate: compoundPredicate];
    [myCardRequest setPredicate: myCardPredicate];

    
    NSError *error = nil;
    NSArray *myCardResults = [moc executeFetchRequest:myCardRequest error:&error];
    if (error) {
        NSLog(@"err: %@, localized err: %@\n\n", [error description], [error localizedDescription]);
        return;
        
    }
    else if ([myCardResults count] == 0){
        NSLog(@"user has not created a card yet\n\n");
        return;
    }
    else {
        self.myCard = (Card*)myCardResults[0];
        NSLog(@"my card is null: %d\n", (self.myCard == NULL));
        if (!(self.myCard == NULL)) {
            NSLog(@"my card name: %@\n", self.myCard.firstName);
        }
        for (int i = 0; i < [myCardResults count]; i++) {
            
            NSLog(@"%@\n", ((Card*)myCardResults[i]).firstName);
        }
    }
}

//after getting username, share card with that user
- (BOOL) shareCard: (Card*) businessCard
          WithUser: (NSString*) userID {
    
    NSLog(@"sharing card != business card: %d\n", [businessCard.cardType integerValue] != BUSINESS_CARD);
    NSLog(@"sharing card != my card: %d\n", [businessCard.cardType integerValue] != MY_CARD);
    if ([businessCard.cardType integerValue] != BUSINESS_CARD && [businessCard.cardType integerValue] != MY_CARD) {
        NSLog(@"Trying to share non-business card object of type : %@, type of cardType: %@,  with name : %@\n", businessCard.cardType,[[businessCard.cardType class] description], businessCard.lastName);
        exit(-2);
    }
    
    //create reference to user's message box,
    //create reference to new message
    NSString* messageRefString = [[NSString alloc] initWithFormat:@"messages/%@", userID];
    Firebase* userMessageRef = [self.getFirebaseRootRef childByAppendingPath:messageRefString];
    Firebase* nextMessageRef = [userMessageRef childByAutoId];
    
    //create new message in dictionary form
    NSDictionary *shareMessage = @ {
        msgTypeKey: [NSNumber numberWithInt: MESSAGE_CARD],             //signify that it is a message
        companyKey : businessCard.company,
        emailKey : businessCard.email,
        firstNameKey : businessCard.firstName,
        lastNameKey : businessCard.lastName,
        positionKey : businessCard.position,
        templateIDKey : businessCard.templateID,
        userIDKey : businessCard.userID,
        versionKey : businessCard.version,
    };
    
    //setValue for new message in firebase to shareMessage
    [nextMessageRef setValue: shareMessage withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            NSLog(@"Error description : %@, localized description %@", [error description], [error localizedDescription]);
            abort();
            
            //figure out how to return false
        }
        else {
            NSLog(@"Card was succesfully shared");
            //figure out how to return true
        }
    }];

    return true;
}




#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Turner-Mandeville.cardCoreDataExample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cardme" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cardme.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

