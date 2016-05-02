//
//  swipeableMessageCell.m
//  cardme
//
//  Created by Turner Mandeville on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "swipeableMessageCell.h"

//static CGFloat const kBounceValue = 20.0f;

@implementation swipeableMessageCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
//    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
//    self.panRecognizer.delegate = self;
//    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(id) sender {
    if (sender == self.yesButton) {
        [self.delegate yesButtonActionForMessage: self.messageRef];
//        [self.delegate yesButtonActionForMessage: self.messageData];
//        self.yesButton.enabled = NO;
//        self.noButton.enabled = NO;
        NSLog(@"I clicked the YES button?\n");
        //NSLog(@"in cell: messageData null : %d\n", (self.messageRef == NULL));

    }
    else if (sender == self.noButton) {
        [self.delegate noButtonActionForMessage: self.messageRef];
//        [self.delegate yesButtonActionForMessage: self.messageData];
//        self.yesButton.enabled = NO;
//        self.noButton.enabled = NO;
        NSLog(@"I clicked the NO button?\n");
       // NSLog(@"in cell: messageData null : %d\n", (self.messageRef == NULL));
    }
    else {
        NSLog(@"What the f did you click on?\n");
    }
}

- (CGFloat)buttonTotalWidth {
    NSLog(@"button total width : %f\n", CGRectGetWidth(self.frame) - CGRectGetMinX(self.yesButton.frame));
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.yesButton.frame);
}

//- (void) resetConstraintContstantsToZero: (BOOL) animated notifyDelegateDidClose: (BOOL) endEditing {
//    //TODO: Notify delegate.
//    
//    if (self.startingRightLayoutConstraintConstant == 0 &&
//        self.contentViewRightConstraint.constant == 0) {
//        //Already all the way closed, no bounce necessary
//        return;
//    }
//    
//    self.contentViewRightConstraint.constant = -kBounceValue;
//    self.contentViewLeftConstraint.constant = kBounceValue;
//    
//    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
//        self.contentViewRightConstraint.constant = 0;
//        self.contentViewLeftConstraint.constant = 0;
//        
//        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
//            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
//        }];
//    }];
//}
//
//-(void) setConstraintsToShowAllButtons: (BOOL) animated notifyDelegateDidOpen: (BOOL) notifyDelegate {
//    //TODO: Notify delegate.
//    
//    //1
//    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
//        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
//        return;
//    }
//    //2
//    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
//    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
//    
//    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
//        //3
//        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
//        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
//        
//        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
//            //4
//            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
//        }];
//    }];
//}
////
////- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
////    float duration = 0;
////    if (animated) {
////        duration = 0.1;
//    }
//    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self layoutIfNeeded];
//    } completion:completion];
//}

//
//
//- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            self.panStartPoint = [recognizer translationInView:self.myContentView];
//            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
//            NSLog(@"Pan Began at %@", NSStringFromCGPoint(self.panStartPoint));
//            break;
//        case UIGestureRecognizerStateChanged: {
//            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
//            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
//            NSLog(@"Pan Moved %f", deltaX);
//            BOOL panningLeft = NO;
//            if (currentPoint.x < self.panStartPoint.x) {
//                panningLeft = YES;
//            }
//            NSLog(@"content view right constraint constant: %f\n", self.contentViewRightConstraint.constant);
//            NSLog(@"startingRightLayoutConstraintConstant = %f\n", self.startingRightLayoutConstraintConstant);
//            if (self.startingRightLayoutConstraintConstant == 0) {
//                //The cell was closed and is now opening
//                if (!panningLeft) {
//                    NSLog(@"not panning left\n");
//                    NSLog(@"max: %f\n", MAX(-deltaX, 0));
//
//                    CGFloat constant = MAX(-deltaX, 0); //3
//                    if (constant == 0) { //4
//                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
//                    } else { //5
//                        [self.contentViewRightConstraint setConstant: constant];
//                        NSLog(@"new content view right constraint constant : %f", self.contentViewRightConstraint.constant);
//                    }
//                } else {
//                    NSLog(@"panning left\n");
//                    NSLog(@"min: %f\n", MIN(-deltaX, [self buttonTotalWidth]));
//                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //6
//                    if (constant == [self buttonTotalWidth]) { //7
//                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
//                    } else { //8
//                        [self.contentViewRightConstraint setConstant: constant];
//                        NSLog(@"new content view right constraint constant : %f", self.contentViewRightConstraint.constant);
//                    }
//                }
//            }
//            else {
//                //The cell was at least partially open.
//                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //1
//                if (!panningLeft) {
//                    CGFloat constant = MAX(adjustment, 0); //2
//                    if (constant == 0) { //3
//                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
//                    } else { //4
//                        [self.contentViewRightConstraint setConstant: constant];
//                        NSLog(@"new content view right constraint constant : %f", self.contentViewRightConstraint.constant);
//                    }
//                } else {
//                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //5
//                    if (constant == [self buttonTotalWidth]) { //6
//                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
//                    } else { //7
//                        [self.contentViewRightConstraint setConstant: constant];
//                        NSLog(@"new content view right constraint constant : %f", self.contentViewRightConstraint.constant);
//                    }
//                }
//            }
//            
//            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //8
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//            NSLog(@"Pan Ended");
//            if (self.startingRightLayoutConstraintConstant == 0) { //1
//                //Cell was opening
//                CGFloat halfOfButtonOne = CGRectGetWidth(self.noButton.frame) / 2; //2
//                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
//                    //Open all the way
//                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
//                } else {
//                    //Re-close
//                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
//                }
//            } else {
//                //Cell was closing
//                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.noButton.frame) + (CGRectGetWidth(self.yesButton.frame) / 2); //4
//                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
//                    //Re-open all the way
//                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
//                } else {
//                    //Close
//                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
//                }
//            }
//            break;
//        case UIGestureRecognizerStateCancelled:
//            NSLog(@"Pan Cancelled");
//            if (self.startingRightLayoutConstraintConstant == 0) {
//                //Cell was closed - reset everything to 0
//                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
//            } else {
//                //Cell was open - reset to the open state
//                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
//            }
//            break;
//        default:
//            break;
//    }
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}


@end
