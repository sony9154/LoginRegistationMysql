//
//  MainMenuViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 4月/17/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SettingsViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *useImageView;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.successNickname;
    
    NSLog(@"userNameLabel is : %@",self.userNameLabel.text);
    
    UIImage *image = [UIImage imageNamed:@"123456.jpg"];
    self.useImageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingsBtnPressed:(id)sender {
    
    SettingsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    vc2.settingsNickname = self.userNameLabel.text;
    
    [self showViewController:vc2 sender:nil];
}

- (IBAction)settingsBtnPressed2:(id)sender {
    
    SettingsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    vc2.settingsNickname = self.userNameLabel.text;
    
    [self showViewController:vc2 sender:nil];
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
