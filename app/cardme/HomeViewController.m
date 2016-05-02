//
//  HomeViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.myCard = self.appdelegate.myCard;
    self.username.text = self.myCard.email;
    self.today.text = [self.appdelegate getToday];
    self.cardct.text = [NSString stringWithFormat:@"%@", [self.appdelegate retrieveCardCt]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signout:(id)sender {
    [self.appdelegate signOut];
}

- (IBAction)editCard:(id)sender {
    
}
@end
