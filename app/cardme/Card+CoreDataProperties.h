//
//  Card+CoreDataProperties.h
//  cardme
//
//  Created by Turner Mandeville on 5/1/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cardType;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *position;
@property (nullable, nonatomic, retain) NSNumber *templateID;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSNumber *version;
@property (nullable, nonatomic, retain) NSData *cardImage;
@property (nullable, nonatomic, retain) NSString *sharedWith;

@end

NS_ASSUME_NONNULL_END
