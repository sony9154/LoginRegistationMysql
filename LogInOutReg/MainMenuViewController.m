//
//  MainMenuViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 4月/17/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.successNickname;
    
    NSLog(@"userNameLabel is : %@",self.userNameLabel.text);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
