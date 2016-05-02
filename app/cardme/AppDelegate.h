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
#import "Card.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Firebase *firebaseRootRef;
@property (strong, nonatomic) Firebase *firebaseUserRef;
@property (strong, nonatomic) Card* myCard;
@property (strong, nonatomic) NSString* today;
@property (strong, nonatomic) NSNumber* cardct;


- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;
- (Firebase *)getFirebaseRootRef;
- (Firebase *)getFirebaseUserRefForUser: (NSString*) username;
- (void) signOut;

//searching for person and getting their username
//- (FQuery *)queryFirebaseUsernameForPerson: (NSString*) lastname;
//after getting username, share card with that user
- (BOOL) shareCard: (Card*) businessCard
          WithUser: (NSString*) userID;
- (void) deleteCardFromCoreData : (Card*) message;

- (void) readMyCardFromCoreData;
- (void) readMyCardFromCoreDataWithUsername: (NSString*) username;

- (NSNumber*) retrieveCardCt;
- (NSString*) getToday;

@end

