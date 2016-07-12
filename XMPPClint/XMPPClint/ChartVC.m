//
//  ChartVC.m
//  XMPPClint
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartVC.h"
#import "BCNetConnect.h"
#import "ClintModel.h"

@interface ChartVC ()<XMPPStreamDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *messagesArray;

@end

@implementation ChartVC

-(void)dealloc{
    [[BCNetConnect shareNetConnect].stream removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.friendName;
    self.messagesArray = [NSMutableArray array];
    [[BCNetConnect shareNetConnect].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    
    //构建消息,发送
    XMPPMessage *sendMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:self.friendName]];
    [sendMessage addBody:self.textFild.text];
//    通过xmppstream 发送消息
    [[BCNetConnect shareNetConnect].stream sendElement:sendMessage];
    //输入框置空
    self.textFild.text = nil;
    
    //将自己发送的消息转化为model,放到数据源中
    Message *message = [[Message alloc] init];
    message.isMe = YES;
    message.from = [BCNetConnect shareNetConnect].stream.myJID.user;
    message.body = sendMessage.body;
    
    [self.messagesArray addObject:message];
    
    [self.tableView reloadData];
    
}

#pragma mark - xmpp stream delegate

//收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *fromString = [NSString stringWithFormat:@"%@@%@", message.from.user, message.from.domain];
    //是当前聊天对象发送的消息
    if ([fromString isEqualToString:self.friendName]) {
        //转化为model,添加到数组
        Message *model = [[Message alloc] init];
        model.from = message.fromStr;
        model.isMe = NO;
        model.body = message.body;
        [self.messagesArray addObject:model];
        
        [self.tableView reloadData];
    }
    
}

#pragma mark - table View delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    Message *message = self.messagesArray[indexPath.row];
    if (message.isMe) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    }
    cell.textLabel.text = message.from;
    cell.detailTextLabel.text = message.body;
    return cell;
    
}

@end
