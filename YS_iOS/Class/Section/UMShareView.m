//
//  UMShareView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UMShareView.h"

#import "BaseViewController.h"

#import <UMSocialCore/UMSocialCore.h>

#import <SDWebImageDownloader.h>

#import "GArticleModel.h"

#import "UIView+Responder.h"


@interface UMShareView ()


@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong)  BaseViewController *showVC;

@property (nonatomic, copy) ShareBlock shareBlock;


@end


@implementation UMShareView



- (void)initSubview {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // effectView.backgroundColor = [UIColor blackColor];
    [self addSubview:effectView];
    
    _effectView = effectView;
    _effectView.alpha = 0.001;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [effectView addGestureRecognizer:tapGesture];
    
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 285)];
    containView.lk_attribute
    .backgroundColor(kWhiteColor)
    .superView(self);
    _containView = containView;
    
    
    NSArray *titleNames = @[@"微信好友", @"朋友圈", @"QQ好友", @"QQ空间", @"微博"];
    NSArray *iconNames = @[@"ic_weixin", @"ic_wx_timeline", @"ic_qq", @"ic_qzone", @"ic_weibo"];
    for (NSInteger i = 0; i < titleNames.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lk_attribute
        .normalImage([UIImage imageNamed:iconNames[i]])
        .event(self, @selector(btnOnClick:))
        .tag(1000 +i)
        .superView(containView);
        
        
        UILabel *label = [[UILabel alloc] init];
        label.lk_attribute
        .font(14)
        .text(titleNames[i])
        .textAlignment(NSTextAlignmentCenter)
        .textColor([UIColor blackColor])
        .superView(containView);
        
        
        CGFloat itemWidth = kScreenWidth/3.0;
        if (i < 3) {
            
            btn.frame = CGRectMake(itemWidth *i + (itemWidth-50)/2, 30, 50, 50);
            
            label.frame = CGRectMake(itemWidth *i, btn.bottom+7, itemWidth, 20);
        }
        else {
            
            
            btn.frame = CGRectMake(itemWidth *(i-3) + (itemWidth-50)/2, 134, 50, 50);
            label.frame = CGRectMake(itemWidth *(i-3), btn.bottom+7, itemWidth, 20);
        }
        
        // 隐藏微信
        if (i == 0 || i == 1) {
            BOOL canOpenWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ;
            BOOL canOpenWechat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
            
            if (!(canOpenWeixin || canOpenWechat)) {
                
                btn.hidden = YES;
                label.hidden = YES;
            }
        }
        
        // 隐藏微博
        
        // BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
        BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
        BOOL hadInstalledWeibohd = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibohd://"]];
        
        if (i == 5) {
            if (!(hadInstalledWeibo || hadInstalledWeibohd)) {
                
                btn.hidden = YES;
                label.hidden = YES;
            }
        }
        
    }
    
    
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth, 1)];
    lineH.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(containView);
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.lk_attribute
    .normalTitle(@"取消")
    .font(16)
    .normalTitleColor(kAuxiliaryTipColor)
    .event(self, @selector(cancleBtnOnClicked:))
    .superView(containView);
    
    cancleBtn.frame = CGRectMake(0, 251, kScreenWidth, 22);
    
    cancleBtn.topEdge(20).bottomEdge(10);
    
    [self hide];

}


- (instancetype)initWithFrame:(CGRect)frame viewController:(BaseViewController*)viewController eventType:(ShareBlock)shareBlock {
    if (self = [super initWithFrame:frame]) {
    
        self.showVC = viewController;
        
        _shareBlock = [shareBlock copy];
        
        [self initSubview];
        
    }
    return self;
}


- (void)btnOnClick:(UIButton*)btn {

    /*
    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    UMSocialPlatformType_WechatTimeLine
    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
    UMSocialPlatformType_Qzone              = 5,//qq空间
    UMSocialPlatformType_Sina
    */
    
    NSInteger tag = btn.tag -1000;
    
    [self hide];
    
    
    if (tag == 0) {
        
        [self sharePromoCodePlatType:UMSocialPlatformType_WechatSession];
    }
    else if (tag == 1) {
    
        [self sharePromoCodePlatType:UMSocialPlatformType_WechatTimeLine];

    }
    else if (tag == 2) {
        
        [self sharePromoCodePlatType:UMSocialPlatformType_QQ];

    }
    else if (tag == 3) {
     
        [self sharePromoCodePlatType:UMSocialPlatformType_Qzone];

    }
    else if (tag == 4) {
        
        [self sharePromoCodePlatType:UMSocialPlatformType_Sina];
    }
    
}

- (void)cancleBtnOnClicked:(UIButton*)btn {

    [self hide];
}


- (void)sharePromoCodePlatType:(UMSocialPlatformType)platType {
    
    
    if (_shareBlock) {
        _shareBlock(platType);
    }
    return;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_articleModel.smallPic] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        UIImage *shareImg = image ? image : [UIImage imageNamed:@"app_icon"];
        NSString *title = _articleModel.title;
        NSString *desc = @"推荐朋友注册";
        
        NSString *link= [NSString stringWithFormat:@"%@%@%@", kDomain, kWebUrlArticleDetail, _articleModel.articleId];
        
        [self shareTextToPlatformType:platType
                             shareImg:shareImg
                                title:title
                                 desc:desc
                                 link:link];
        
    }];
}


- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType shareImg:(UIImage*)img title:(NSString*)title desc:(NSString*)desc link:(NSString *)link {
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"22" descr:@"234" thumImage:[UIImage imageNamed:@"pl_header"]];
    shareObject.webpageUrl = @"http://www.baidu.com";
    
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self.nextResponder completion:^(id data, NSError *error) {
        
        // UMSocialPlatformErrorType
        
    }];

    
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:[UIImage imageNamed:@"pl_header"]];
//    shareObject.webpageUrl = link;
//    
//    // 创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    messageObject.title = title;
//    messageObject.text = desc;
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
//        
//        // UMSocialPlatformErrorType
//        if (error) {
//            if (error.code == 2009) {
//                [self.showVC showErrorMsg:@"取消分享"];
//            }
//            else {
//                [self.showVC showErrorMsg:@"分享失败"];
//            }
//        }else{
//            
//            [self.showVC showErrorMsg:@"分享成功"];
//        }
//    }];
}


- (void)tapAction {

    [self hide];
}


#pragma mark - Private

- (void)show {
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _effectView.alpha = 0.4;
        
        _containView.frame = CGRectMake(0, kScreenHeight - 285, kScreenWidth, 285);
    } completion:^(BOOL finished) {
       
        
    }];
}


- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _effectView.alpha = 0.001;
        
        _containView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
}


@end
