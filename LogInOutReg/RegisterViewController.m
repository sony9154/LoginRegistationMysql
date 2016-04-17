//
//  RegisterViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 4月/5/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNicknameTextField;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnPressed:(id)sender {
    
    NSString *userEmail = self.userEmailTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    NSString *userRepeatPassword = self.repeatPasswordTextField.text;
    NSString *userNickname = self.userNicknameTextField.text;
    
    if(userEmail.length == 0 || userPassword.length == 0 || userRepeatPassword.length == 0 || userNickname.length == 0)
    {
        [self displayMyAlertMessage:@"所有欄位都要填寫"];
        return;
    }
    
    if(userPassword != userRepeatPassword) {
        [self displayMyAlertMessage:@"密碼輸入不一致！"];
    }
    
    NSURL *myURL = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/userRegister.php"];
    //NSURL *myURL = [NSURL URLWithString:@"http://localhost:8888/HelloBingo/userRegister.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    request.HTTPMethod = @"POST";
    
    NSString *registerDataString = [NSString stringWithFormat:@"email=%@&password=%@&nickname=%@", userEmail, userPassword, userNickname];
    
    request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable jsonData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error != nil) {
            NSLog(@"%@",error);
            return ;
        }
        
        //NSError *err = nil;
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Result: %@", result.description);
        
        NSString *resultValue = result[@"status"];
        BOOL isUserRegistered = false;
        if([resultValue  isEqual: @"Success"]) {
            isUserRegistered = true;
        }
        NSString *messageToDisplay = result[@"message"];
        if (!isUserRegistered) {
            messageToDisplay = result[@"message"];
            NSLog(@"MessageToDisplay is :%@",messageToDisplay);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:messageToDisplay preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [myAlert addAction:okAction];
            [self presentViewController:myAlert animated:true completion:nil];
            
        });
        
        
    }];
    
    [task resume];
    //[self dismissViewControllerAnimated:true completion:nil];
}


- (void) displayMyAlertMessage:(NSString*)userMessage {
    
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"注意！" message:userMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [myAlert addAction:okAction];
    [self presentViewController:myAlert animated:true completion:nil];
    
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



















