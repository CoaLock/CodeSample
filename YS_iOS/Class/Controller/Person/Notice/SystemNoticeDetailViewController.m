//
//  SystemNoticeDetailViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SystemNoticeDetailViewController.h"

@interface SystemNoticeDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end



@implementation SystemNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"通知详情"];
    
    _timeLabel.text = _messageModel.addtimeStr;
    _descLabel.text = _messageModel.showStr;

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 11
    NSInteger type = [PASS_NULL_TO_NIL(_messageModel.type) integerValue];
    if (type == 11) {
    
        _titleL.text = @"群发公告";
    }
    else {
    
        _titleL.text = @"系统通知";
    }
    
    _iconImgView.image = [[UIImage imageNamed:@"ic_system_msg_small"] imageWithColor:kAppCustomMainColor];
    
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

@end
