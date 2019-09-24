//
//  BaseViewController+UMShare.m
//  YS_iOS
//
//  Created by 崔露凯 on 17/1/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController+UMShare.h"

#import <objc/runtime.h>


static char shareObjFlag;


@implementation BaseViewController (UMShare)


- (void)setShareObj:(GArticleModel *)shareObj {

    objc_setAssociatedObject(self, &shareObjFlag, shareObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GArticleModel *)shareObj {

    return objc_getAssociatedObject(self, &shareObjFlag);
}


#pragma mark - UMShare
- (void)sharePromoCodePlatType:(UMSocialPlatformType)platType {
    
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.shareObj.smallPic] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        UIImage *shareImg = image ? image : [UIImage imageNamed:@"app_icon"];
        NSString *title = self.shareObj.title;
        NSString *desc = self.shareObj.desc ? self.shareObj.desc : @"推荐朋友注册";
        
        NSString *link= [NSString stringWithFormat:@"%@%@%@", kDomain, kWebUrlArticleDetail, self.shareObj.articleId];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self shareTextToPlatformType:platType
                                 shareImg:shareImg
                                    title:title
                                     desc:desc
                                     link:link];
            
        });
        
    }];
}


- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType shareImg:(UIImage*)img title:(NSString*)title desc:(NSString*)desc link:(NSString *)link {
    
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:img];
    shareObject.webpageUrl = link;
    
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title;
    messageObject.text = desc;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            
            if (error.code == 2009) {
                [self showErrorMsg:@"取消分享"];
            }
            else {
                [self showErrorMsg:@"分享失败"];
            }
        }
        else{
            
            [self showSuccessIndicator:@"分享成功"];
        }
    }];
}



@end
