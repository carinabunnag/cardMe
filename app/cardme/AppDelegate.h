//
//  AppDelegate.h
//  cardme
//
//  Created by Anteneh Moges on 4/14/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Firebase/Firebase.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Firebase *firebaseRootRef;
@property (strong, nonatomic) Firebase *firebaseUserRef;
@property (strong, nonatomic) NSString* myUsername;


- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;
- (Firebase *)getFirebaseRootRef;
- (Firebase *)getFirebaseUserRefForUser: (NSString*) username;
//searching for person and getting their username
- (FQuery *)queryFirebaseUsernameForPerson: (NSString*) lastname;
//after getting username, share card with that user
- (BOOL) shareCard: (id) businessCard
          WithUser: (NSString*) username;

- (BOOL) addNewUser : (NSString*) username
           withEmail : (NSString*) email
       withPassword : (NSString*) password;
- (BOOL) readInMessagesFromFirebase;

@end

