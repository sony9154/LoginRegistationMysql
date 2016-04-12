//
//  LoginViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 3月/31/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnPressed:(id)sender {
    
    NSString *userEmail = self.userEmailTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    
    if(userEmail.length == 0 || userPassword.length == 0){return;}
    
    NSURL *myUrl = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/userLogin.php"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myUrl];
    request.HTTPMethod = @"POST";
    
    NSString *registerDataString = [NSString stringWithFormat:@"email=%@&password=%@", userEmail, userPassword];
    
    request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable jsonData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@",error);
            return ;
        }
        
        //NSError *err = nil;
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"\nResult: %@", result.description);
        
        NSString *resultValue = result[@"status"];
        
        if([resultValue  isEqual: @"Success"])
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:true forKey:@"isUserLoggedIn"];
            [userDefaults synchronize];
            //[[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isUserLoggedIn"];
            //[[NSUserDefaults standardUserDefaults]synchronize];
            
            [self dismissViewControllerAnimated:true completion:nil];
        }
        
        
    }];
    
    [task resume];
    
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
