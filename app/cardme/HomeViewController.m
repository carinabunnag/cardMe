//
//  HomeViewController.m
//  cardme
//
//  Created by Turner Mandeville on 4/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "HomeViewController.h"
#import "TemplateController.h"

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
    
    NSLog(@"%@ Yo i hope this works: ",imageTextFile);
    
    //When user is accessing an contact, connect w/ Firebase and retrieve
    //NSString value of other user, then decode the image to be shown
    //Decode image file back into an image to be shown
    if (imageTextFile != NULL) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:imageTextFile options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *card = [UIImage imageWithData:data];
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.image =card;
        
            //Can change dimension of image
            imageview.frame = CGRectMake(50, 50, 150, 150);
            
            [self.view addSubview:imageview];
    }

    
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
