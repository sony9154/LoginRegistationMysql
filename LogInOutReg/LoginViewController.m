//
//  LoginViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 3月/31/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    fbLoginButton.center = self.view.center;
    [self.view addSubview:fbLoginButton];
    fbLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
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
            NSString *userEmailStored = [[NSUserDefaults standardUserDefaults]stringForKey:userEmail];
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isUserLoggedIn"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
            mainMenuViewController.successName = userEmailStored;
            [self showDetailViewController:mainMenuViewController sender:nil];
            });
            
        }
        
        
    }];
    
    [task resume];
    
}


- (IBAction)fbLoginBtnPressed:(id)sender {
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
