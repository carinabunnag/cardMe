//
//  AppDelegate.m
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "AppDelegate.h"

static NSString* cardEntityName = @"Card";
static NSString* messageEntityName = @"Message";
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

//populates message box with messages from firebase
- (BOOL) readInMessagesFromFirebase {
    //get reference to user's message box on firebase
    NSString* myMessageBoxName = [[NSString alloc] initWithFormat:@"messages/%@", _myUsername];
    Firebase* myMessageBoxRef = [self.getFirebaseRootRef childByAppendingPath:myMessageBoxName];
    
    //create managed object context reference
    NSManagedObjectContext *context = [self managedObjectContext];
    

    //read messages from firebase to managed object -- possible change this to a handle later
    [myMessageBoxRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            NSLog(@"An error occured reading snapshot values from Firebase");
            return;
        }
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:messageEntityName inManagedObjectContext:context];
        [newManagedObject setValue:snapshot.value[companyKey] forKey:companyKey];
        [newManagedObject setValue:snapshot.value[emailKey] forKey:emailKey];
        [newManagedObject setValue:snapshot.value[firstNameKey] forKey:firstNameKey];
        [newManagedObject setValue:snapshot.value[lastNameKey] forKey:lastNameKey];
        [newManagedObject setValue:snapshot.value[positionKey] forKey:positionKey];
        [newManagedObject setValue:snapshot.value[templateIDKey] forKey:templateIDKey];
        [newManagedObject setValue:snapshot.value[userIDKey] forKey:userIDKey];
        [newManagedObject setValue:snapshot.value[versionKey] forKey:versionKey];
    }];
    
    //save context
    [context save: NULL];
    return true;
}

//after getting username, share card with that user
- (BOOL) shareCard: (id) businessCard
          WithUser: (NSString*) username {
    
    //create reference to user's message box,
    //create reference to new message
    NSString* messageRefString = [[NSString alloc] initWithFormat:@"messages/%@", username];
    Firebase* userMessageRef = [self.getFirebaseRootRef childByAppendingPath:messageRefString];
    Firebase* nextMessageRef = [userMessageRef childByAutoId];
    
    //create new message in dictionary form
    NSDictionary *shareMessage = @ {
        companyKey : [[businessCard valueForKey:companyKey] description],
        emailKey : [[businessCard valueForKey:emailKey] description],
        firstNameKey : [[businessCard valueForKey:firstNameKey] description],
        lastNameKey : [[businessCard valueForKey:lastNameKey] description],
        positionKey : [[businessCard valueForKey:positionKey] description],
        templateIDKey : [[businessCard valueForKey:templateIDKey] description],
        userIDKey : [[businessCard valueForKey:userIDKey] description],
        versionKey : [[businessCard valueForKey:versionKey] description],
    };
    
    //setValue for new message in firebase to shareMessage
    [nextMessageRef setValue: shareMessage];
    
    return true;
}

- (BOOL) addNewUser : (NSString*) username
          withEmail : (NSString*) email
       withPassword : (NSString*) password {
    return true;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cardCoreDataExample" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cardCoreDataExample.sqlite"];
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

