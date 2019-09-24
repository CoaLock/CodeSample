//
//  AppMacro.h
//  LetWeCode
//
//  Created by 崔露凯 on 15/10/28.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#pragma mark - ToolsMacros



#define kPageFetchNum 10

#define kSegmentBgHeight 53

// 如果数据为NULL，设为nil
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

// 处理nil，为空字符串@""
#define STRING_NIL_NULL(x) if(x == nil || [x isKindOfClass:[NSNull class]]){x = @"";}


#define ARRAY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @[];}

#define DICTIONARY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @{};}



#define GrassWeakSelf  __weak typeof(self) weakSelf = self;

// 统一处理打印日志
#ifdef DEBUG
#define DLog(format, ...)  NSLog(format, __VA_ARGS__)
#else
#define DLog(...)
#endif

#define XCDEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)


#pragma mark - 界面尺寸

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(x) (x)*(kScreenWidth)/375.0
#define kHeight(y) (y)*(kScreenHeight)/667.0

#define KViewWidth self.frame.size.width
#define KViewHeight self.frame.size.height

#define Font(F)               [UIFont systemFontOfSize:(F)]
#define boldFont(F)           [UIFont boldSystemFontOfSize:(F)]

#define kTitleFont            Font(16)
#define kArticleTitleFont     Font(22)
#define kArticleTextFont      Font(14)
#define kArticleSubTitleFont  Font(13)
#define kTabbarTextFont       Font(10)
#define kDecorateFont         Font(10)

#define kBlackBgAlpha         0.4

#define kBorderCorner         4


#define kRectImgScale        2/1.0
#define kRectImgHeight(width)   kWidth((width/kRectImgScale))



#pragma mark - HttpMacros

#define SEAVER_APP_ID @"xiaocaoiosappid@u8ms@nsN2G8M2"

#define  kHttpSignKey  @"@J4*A9N7&B^A9Y7j6sWv8m6%q_p+z-h="

#define kHttpServicePushDomain @"http://supermarket-push.beyondin.com"

#define kHttpServicePort @"80"


// 正式环境
#define kHttpServiceDomainProduct
#define kHttpImageServiceProduct

#define kHttpImageServiceSubmitProduct

#define kWebServiceDomainProduct


// 本地服务器/c测试服务器
#define kDomain @"http://xiaocao.beyondin.com"
//#define kDomain @"http://www.xiaocao.com"

//#define kDomain @"http://192.168.1.222"



#define kHttpServiceDomainSandbox [NSString stringWithFormat:@"%@/?m=api&a=api", kDomain]

#define kHttpImageServiceSandbox kDomain

#define kHttpImageServiceSubmitSandbox [NSString stringWithFormat:@"%@/api/uploadImage", kDomain]

#define kWebServiceDomainSandbox kDomain       // web服务器地址（测试环境）


// web路径
#define kWebUrlArticleDetail    @"/FrontShare/article/article_id/"       // 文章详情链接
#define kWebUrlHelpList         @"/FrontHelp/help_list"                  // 帮助列表
#define kWebUrlHelpDetail       @"/FrontHelp/help_detail/help_id/"      // 帮助详情
#define kWebUrlMyCoin           @"/FrontUser/my_coin/style/"                    // 金币页面
#define kWebUrlCoinDescription  @"/FrontArticle/about_coin"              // 金币说明
#define kWebUrlAboutUs          @"/FrontArticle/about_us"                // 简介
#define kWebUrlRegistAgreement  @"/FrontArticle/regist_agreement"        // 用户协议
#define kWebUrlNoticeDetail     @"/FrontArticle/notice_detail/notice_id/"     // 群发公告详情

#define kWebUrlShareApp     @"/FrontShare/app"     // 分享app



#endif /* AppMacro_h */
