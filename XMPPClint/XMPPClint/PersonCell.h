//
//  PersonCell.h
//  XMPPClint
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastMessage;
@property (weak, nonatomic) IBOutlet UILabel *unreadConut;
@property (weak, nonatomic) IBOutlet UILabel *online;
@end
