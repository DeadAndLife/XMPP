//
//  ViewController.m
//  XMPPClint
//
//  Created by qingyun on 16/7/11.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BCNetConnect.h"
#import "ClintModel.h"
#import "PersonCell.h"

@interface ViewController ()<XMPPStreamDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *friendStatus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *messagesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加一个通知,如果登录失败,切换回登录界面,清理数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotAuthenticate:) name:@"didNotAuthenticate" object:nil];
    
    //添加Delegate,接收用户的状态,和消息
    [[BCNetConnect shareNetConnect].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.friendStatus = [NSMutableArray array];
    self.messagesArray = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)didNotAuthenticate:(NSNotification *)notifi{
    //切换到登录界面
    UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"loginnav"];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = vc;
}

#pragma mark - xmpp delegate
//收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%@", message);
    
    //把message转化为model
    Message *ssage = [[Message alloc] init];
    ssage.body = message.body;
    ssage.from = [NSString stringWithFormat:@"%@@%@", message.from.user, message.from.domain];
    ssage.isMe = [sender.myJID.user isEqualToString:message.from.user];
    //排除无效的消息
    if (!ssage.body || [ssage.body isEqualToString:@""]) {
        return;
    }
    
    [self.messagesArray addObject:ssage];
    [self.tableView reloadData];
}

//收到状态改变
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"%@", presence);
    //自己的名字
    NSString *myUser = sender.myJID.user;
    //消息发送者名字
    NSString *friendName = presence.from.user;
    //用户所在的域:
    NSString *domain = presence.from.domain;
    //消息的类型
    NSString *pType = presence.type;
    if (![myUser isEqualToString:friendName]) {
        //好友的状态
        Status *status = [[Status alloc] init];
        status.name = [NSString stringWithFormat:@"%@@%@",friendName, domain];
        if ([pType isEqualToString:@"available"]) {
            status.isOnLine = YES;
        }else{
            status.isOnLine = NO;
        }
        
        //检查以前是否有老的状态,并且更新
        for (int i = 0; i < self.friendStatus.count; i++) {
            Status *s = self.friendStatus[i];
            if ([s.name isEqualToString:status.name]) {
                //设置新的状态,替换老的状态
                [self.friendStatus removeObjectAtIndex:i];
                [self.friendStatus insertObject:status atIndex:i];
                break;
            }
        }
        
        //如果数组不包含,那么添加
        if (![self.friendStatus containsObject:status]) {
            [self.friendStatus addObject:status];
        }
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendStatus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personcell" forIndexPath:indexPath];
    Status *status = self.friendStatus[indexPath.row];
    cell.name.text = status.name;
    cell.online.text = status.isOnLine ? @"在线" : @"离线";
    
    int count = 0;//未读消息
    NSString *str = nil;//最后一条消息
    for (Message *message in self.messagesArray) {
        if ([message.from isEqualToString:status.name]) {
            count++;
            str = message.body;
        }
    }
    cell.lastMessage.text = str;
    cell.unreadConut.text = [NSString stringWithFormat:@"%d", count];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    取出模型中的好友的名字,赋值给下一个控制器
    Status *status = self.friendStatus[indexPath.row];
    NSString *friendName = status.name;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"chartvc"];
    [vc setValue:friendName forKey:@"friendName"];
    [self.navigationController pushViewController:vc animated:YES];
}

//通过sb跳转控制器
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    
//}



@end
