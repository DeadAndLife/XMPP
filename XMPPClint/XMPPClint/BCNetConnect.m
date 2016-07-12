//
//  BCNetConnect.m
//  XMPPClint
//
//  Created by qingyun on 16/7/11.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "BCNetConnect.h"

@interface BCNetConnect ()<XMPPStreamDelegate, XMPPRosterDelegate>

@end

@implementation BCNetConnect

+(instancetype)shareNetConnect{
    static BCNetConnect *netConnect;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netConnect = [[BCNetConnect alloc] init];
    });
    
    return netConnect;
}


//连接服务器
-(BOOL)connect{
    //断开连接,重新开始
    if (self.stream.isConnected) {
        [self.stream disconnect];
    }
    
    //得到用户名,密码,服务器,验证存在后,进行连接,返回连接结果
//    如果没有用户名密码,直接返回 NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"user"];
    NSString *pwd = [userDefaults objectForKey:@"pwd"];
    NSString *service = [userDefaults objectForKey:@"service"];
    if (!userName || !pwd) {
        return NO;
    }
    
    //配置客户端的jid,域,ip地址,进行连接
    self.stream.myJID = [XMPPJID jidWithString:userName];
    self.stream.hostName = service;
    
    NSError *error;
    //连接服务器,返回连接结果
    return [self.stream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
}

//设置上线状态
-(void)goOnline{
    //状态,默认为可用的
    XMPPPresence *presence = [XMPPPresence presence];
    //发送状态
    [_stream sendElement:presence];
}

#pragma mark - xmpp delegate

//连接成功Delegate中,进行登录,或者注册
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"connect success");
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //验证密码是否正确
    NSError *error;
    //根据情况,选择不同操作
    if (!self.isRegist) {
        //登录服务器
        [self.stream authenticateWithPassword:pwd error:&error];
    }else{
        //注册新账号
        [self.stream registerWithPassword:pwd error:&error];
        self.isRegist = NO;
    }
    
}

//登录成功后,设置上线状态
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登录成功");
    //上线状态
    [self goOnline];
    
    
    //初始化花名册
    self.storage = [[XMPPRosterCoreDataStorage alloc] init];
    self.roster = [[XMPPRoster alloc] initWithRosterStorage:_storage];
    
    //绑定stream
    [self.roster activate:self.stream];
    //设置Delegate
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

//登录失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didNotAuthenticate" object:nil userInfo:nil];
}

//注册成功后,登录
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //验证密码是否正确
    NSError *error;
    [self.stream authenticateWithPassword:pwd error:&error];

}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败:%@",error);
}

//状态改变的方法
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //我们是接收方from为好友
    NSString *friendName = presence.from.user;
    
    NSString *myName = self.stream.myJID.user;
    if ([myName isEqualToString:friendName]) {
        //自己的状态改变
        NSLog(@"%@", presence.type);
    }
    
    //如果消息的type是subscribe,是添加好友,处理好友添加
    if ([presence.type isEqualToString:@"subscribe"]) {
        //好友的名字
        XMPPJID *friendJID = presence.from;
        //同意对方添加好友,并且添加对方为好友
        [self.roster acceptPresenceSubscriptionRequestFrom:friendJID andAddToRoster:YES];
    }
    
    
}





#pragma mark - get/set
-(XMPPStream *)stream{
    if (!_stream) {
        //创建客户端对象
        self.stream = [[XMPPStream alloc] init];
        //设置delegate,指定回调队列
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _stream;
}


@end
