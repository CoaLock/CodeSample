//
//  AppColorMacro.h
//  YS_iOS
//
//  Created by 崔露凯 on 17/1/11.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#ifndef AppColorMacro_h
#define AppColorMacro_h

#import <UIKit/UIKit.h>


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]



// 界面背景颜色
#define kAppCustomMainColor     [UIColor appCustomMainColor]              //主色




// 颜色配置
#define kNavBarMainColor  [UIColor appNavBarMainColor]
#define kNavBarBgColor    [UIColor appNavBarBgColor]


#define kTabbarMainColor   [UIColor appTabbarMainColor]
#define kTabbarBgColor     [UIColor appTabbarBgColor]



// [UIColor colorWithHexString:@"#232427"]

// [UIColor whiteColor]




#define kBackgroundColor        [UIColor colorWithHexString:@"#F3F3F3"]   //背景色
#define kSeperateLineColor      [UIColor colorWithHexString:@"#E1E1E1"]   //分割线
#define kTextFirstLevelColor    [UIColor colorWithHexString:@"#323232"]   //一级文字
#define kTextSecondLevelColor   [UIColor colorWithHexString:@"#9AA0A2"]   //二级文字
#define kTextThirdLevelColor    [UIColor colorWithHexString:@"#B4B8B9"]   //三级文字
#define kAuxiliaryTipColor      [UIColor colorWithHexString:@"#FF254C"]   //辅助提示颜色
#define kBottomItemGrayColor    [UIColor colorWithHexString:@"#FAFAFA"]   //底栏灰色
#define kCommentSecondColor     [UIColor colorWithHexString:@"#FAFAFA"]   //评论二级颜色



/****颜色列表***/


#define kLightGreyColor RGB(153, 153, 153)         //亮灰色 #999999
#define kOrangeRedColor RGB(255, 83, 27)           //橘红色 #ff531b
#define kPaleGreyColor RGB(243, 243, 243)          //淡灰色 #f1f4f7
#define kDeepGreenColor RGB(65, 117, 5)            //深绿色 #417505
#define kLightGreenColor RGB(200, 220, 81)         //浅绿色 #c8dc51
#define kDarkGreenColor kButtonBackgroundColor     //暗绿色 #335322  RGBa(51, 83, 34)
#define kBrickRedColor RGB(240, 41, 0)             //砖红色 #fo2900
#define kWhiteColor RGB(255, 255, 255)             //白色   #ffffff
#define kBlackColor RGB(0, 0, 0)                   //黑色   #000000
#define kPaleBlueColor RGB(90, 163, 232)           //淡蓝色 #5aa3e8
#define kSilverGreyColor RGB(236, 236, 236)        //银灰色 #ececec
#define kShallowGreyColor RGB(206, 206, 206)       //浅灰色 #cecece
#define kClearColor [UIColor clearColor]           //透明




#endif /* AppColorMacro_h */
