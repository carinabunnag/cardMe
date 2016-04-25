//
//  Account.h
//  cardme
//
//  Created by Anteneh Moges on 4/21/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <Firebase/Firebase.h>

static NSMutableArray *login;

@interface Account : NSObject


-(void) setUser: (NSString*)un;
-(void) setPass: (NSString*)pd;
//-(void) setWebsite: (NSString*)k;


-(NSString*) getEmail;
-(NSString*) getUser;
//-(NSString*) getPass;

-(int) getCount;
-(void) incrCount;


@end