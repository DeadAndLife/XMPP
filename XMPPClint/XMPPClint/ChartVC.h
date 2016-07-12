//
//  ChartVC.h
//  XMPPClint
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartVC : UIViewController

//传递好友的名字
@property (nonatomic, strong)NSString *friendName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFild;
- (IBAction)send:(id)sender;

@end
