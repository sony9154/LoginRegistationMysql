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



@interface LoginViewController ()<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    fbLoginButton.delegate = self;
    fbLoginButton.frame = CGRectMake((self.view.frame.size.width - fbLoginButton.frame.size.width)/2, self.view.frame.size.height * 0.8, fbLoginButton.frame.size.width, fbLoginButton.frame.size.height);
    [self.view addSubview:fbLoginButton];
    fbLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    
    NSDictionary *demandInfo = @{@"fields": @"name, email, first_name, last_name, picture.type(large)"};
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:demandInfo]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             NSLog(@"%@",result);
             //NSLog(@"%@",result[@"email"]);
             //NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             mainMenuViewController.successNickname = (NSString*)result[@"name"];
         }
    }];
    

}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
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
        NSString *resultNickname = [result[@"nickname"] objectForKey:@"user_nickname"];
        //NSString *nicknameCut = [resultNickname substringFromIndex:5];
        
        if([resultValue  isEqual: @"Success"])
        {
            //NSString *userEmailStored = [[NSUserDefaults standardUserDefaults]stringForKey:userEmail];
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isUserLoggedIn"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
                //mainMenuViewController.successName = self.userEmailTextField.text;
                mainMenuViewController.successNickname = resultNickname;
            [self showDetailViewController:mainMenuViewController sender:nil];
            });
            
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
