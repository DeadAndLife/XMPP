//
//  LoginVC.m
//  XMPPClint
//
//  Created by qingyun on 16/7/11.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "LoginVC.h"
#import "BCNetConnect.h"
#import "AppDelegate.h"

@interface LoginVC ()<XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@end

@implementation LoginVC

-(void)dealloc{
    [[BCNetConnect shareNetConnect].stream removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BCNetConnect shareNetConnect].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    //保存用户和密码,服务器,连接服务器,
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = self.userName.text;
    userName = [userName stringByAppendingString:@"@biancheng.me"];
    NSString *pwdStr = self.pwd.text;
    NSString *service = @"localhost";
    
    [userDefaults setObject:userName forKey:@"user"];
    [userDefaults setObject:pwdStr forKey:@"pwd"];
    [userDefaults setObject:service forKey:@"service"];
    [userDefaults synchronize];
    //让连接器连接
    [[BCNetConnect shareNetConnect] connect];
    
}
- (IBAction)regist:(id)sender {
    //保存用户名和密码,注册
    
    //保存用户和密码,服务器,连接服务器,
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = self.userName.text;
    userName = [userName stringByAppendingString:@"@biancheng.me"];
    NSString *pwdStr = self.pwd.text;
    NSString *service = @"localhost";
    
    [userDefaults setObject:userName forKey:@"user"];
    [userDefaults setObject:pwdStr forKey:@"pwd"];
    [userDefaults setObject:service forKey:@"service"];
    [userDefaults synchronize];
    
    [[BCNetConnect shareNetConnect] setIsRegist:YES];
    [[BCNetConnect shareNetConnect] connect];
    
}

//设置Delegate,登陆成功后切换到首页
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //登录成功切换到首页
    UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"homenav"];
    
    //系统Delegate,切换rootvc
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = vc;
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
