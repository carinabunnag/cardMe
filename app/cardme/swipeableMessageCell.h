//
//  swipeableMessageCell.h
//  cardme
//
//  Created by Turner Mandeville on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Card.h"


@protocol swipeableMessageCellDelegate <NSObject>
- (void) yesButtonActionForMessage: (Card*) message;
- (void) noButtonActionForMessage: (Card*) message;
@end

@interface swipeableMessageCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton* yesButton;
@property (weak, nonatomic) IBOutlet UIButton* noButton;
@property (weak, nonatomic) IBOutlet UILabel* messageLabel;
@property (weak, nonatomic) IBOutlet UIView* myContentView;
@property (strong, nonatomic) Card* messageData;
@property (nonatomic, strong) NSString *cellText;
@property (weak, nonatomic) id <swipeableMessageCellDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

-(IBAction)buttonClicked:(id)sender;
- (void) resetConstraintContstantsToZero: (BOOL) animated notifyDelegateDidClose: (BOOL) endEditing;
-(void) setConstraintsToShowAllButtons: (BOOL) animated notifyDelegateDidOpen: (BOOL) notifyDelegate;
@end
