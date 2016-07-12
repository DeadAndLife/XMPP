//
//  AddUserVC.m
//  XMPPClint
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AddUserVC.h"
#import "BCNetConnect.h"

@interface AddUserVC ()

@end

@implementation AddUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)addUser:(id)sender {
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", self.nameFriend.text ,@"biancheng.me"]];
    //调用花名册,添加好友
    [[BCNetConnect shareNetConnect].roster subscribePresenceToUser:jid];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
