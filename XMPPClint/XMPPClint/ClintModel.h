//
//  ClintModel.h
//  XMPPClint
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong)NSString *body;//正文
@property (nonatomic, strong)NSString *from;
@property (nonatomic)BOOL isMe;//本人所发送的
@property (nonatomic)BOOL Composing;//发送中

@end

@interface Status : NSObject
@property (nonatomic) BOOL isOnLine;//在线
@property (nonatomic, strong) NSString *name;//用户名

@end
