//
//  BCNetConnect.h
//  XMPPClint
//
//  Created by qingyun on 16/7/11.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>
#import <XMPPRoster.h>
#import <XMPPRosterCoreDataStorage.h>

@interface BCNetConnect : NSObject

@property (nonatomic, strong)XMPPStream *stream;//客户端

@property (nonatomic) BOOL isRegist;

@property (nonatomic, strong)XMPPRosterCoreDataStorage *storage;//花名册的存储
@property (nonatomic, strong)XMPPRoster *roster;//花名册

+(instancetype)shareNetConnect;//单例方法

-(BOOL)connect;//是否连接成功

@end
