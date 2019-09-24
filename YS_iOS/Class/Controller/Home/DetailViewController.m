//
//  DetailViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DetailViewController.h"

#import "CommentViewController.h"
#import "ReportViewController.h"
#import "RewadListViewController.h"
#import "PersonCenterViewController.h"


#import "DetailTable.h"
#import "DetailHeader.h"
#import "DetailBottomView.h"
#import "RewardView.h"
#import "DXPopover.h"
#import "DetailPopView.h"
#import "CommentInputView.h"
#import "CanlePublishTipView.h"
#import "EffectView.h"
#import "UMShareView.h"

#import "GeneralArticleDetailApi.h"
#import "CommentListApi.h"
#import "DoCommentApi.h"
#import "GArticleModel.h"
#import "DoFollowApi.h"
#import "DoZanApi.h"
#import "DoShareApi.h"
#import "DoRewardApi.h"
#import "GetRewardListApi.h"
#import "DoCollectApi.h"
#import "ReportApi.h"


typedef NS_ENUM(NSUInteger, CommentType) {
    CommentTypeArticle,
    CommentTypeComment,
};

typedef NS_ENUM(NSUInteger, PraiseType) {
    PraiseTypeArticle,
    PraiseTypeComment,
};

typedef NS_ENUM(NSUInteger, ReportType) {
    ReportTypeArticle,
    ReportTypeComment,
};


@interface DetailViewController () <RefreshTableViewDelegate>


@property (nonatomic, strong) DetailTable *detailTable;
@property (nonatomic, strong) DetailHeader *detailHeader;
@property (nonatomic, strong) DetailBottomView *detailBottom; // 底部固定

@property (nonatomic, strong) DetailPopView *popView;  // 更多弹框
@property (nonatomic, strong) DXPopover     *popover;

@property (nonatomic, strong) RewardView *rewardView;  // 打赏选择金币
@property (nonatomic, strong) CommentInputView *inputView;  // 回复输入框


@property (nonatomic, strong) CanlePublishTipView *replyPopupView;
@property (nonatomic, strong) CanlePublishTipView *complainPopupView;

@property (nonatomic, strong) EffectView *effectView;

@property (nonatomic, strong) UMShareView *shareView;

@property (nonatomic, strong) RewadListViewController *rewardVC;


@property (nonatomic, strong) GArticleModel *articleModel;


@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, assign) PraiseType  praiseType;
@property (nonatomic, assign) ReportType  reportType;


@property (nonatomic, assign) NSInteger handleIndex;

// 标识是不是回复键盘，区别于打赏输入金币
@property (nonatomic, assign) BOOL isKeyboardInputCoin;


@end


@implementation DetailViewController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -0) img:@"bg_no_content" title:@"该文章被删除或已下架了" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    return self.blankView;
}


- (CanlePublishTipView *)replyPopupView {
    if (_replyPopupView == nil) {
        
        NSArray *titles = @[@"回复", @"举报", @"取消"];
        _replyPopupView = [[CanlePublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
        
        UIView *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:_replyPopupView];
        
        GrassWeakSelf;
        _replyPopupView.eventBlock = ^(NSInteger index) {
            
            if (![UserDefaultsUtil isContainUserDefault]) {
                
                [weakSelf showReLoginVC];
                return;
            }

            if (index == 0) {
                [weakSelf commentArticle:nil];
            }
            else if (index == 1) {
                
                [weakSelf.complainPopupView show];
            }
        };
        
    }
    return _replyPopupView;
}

- (CanlePublishTipView *)complainPopupView {
    if (_complainPopupView == nil) {
        
        NSArray *titles = @[@"广告或垃圾信息", @"抄袭或未授权转载", @"其他", @"取消"];
        _complainPopupView = [[CanlePublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
        
        UIView *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:_complainPopupView];
        
        
        GrassWeakSelf;
        _complainPopupView.eventBlock = ^(NSInteger index) {
            if (index == 0) {
                
                [weakSelf doReportWithDesc:@"广告或垃圾信息"];
            }
            else if (index == 1) {
                
                [weakSelf doReportWithDesc:@"抄袭或未授权转载"];
            }
            else if (index == 2) {
                
                [weakSelf doReportWithDesc:nil];
            }
            else if (index == 3) {

            }
        };
        
    }
    return _complainPopupView;
}


- (void)initTableView {
    
    _detailTable = [[DetailTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 -49) style:UITableViewStylePlain];
    [_detailTable setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:NO autoRefresh:NO];
    [self.view addSubview:_detailTable];
    
    [_detailTable.searchMoreComment addTarget:self action:@selector(gotoCommentDetail) forControlEvents:UIControlEventTouchUpInside];
}


- (void)initHeaderView {

    _detailHeader = [[NSBundle mainBundle] loadNibNamed:@"DetailHeader" owner:nil options:nil].lastObject;
    _detailTable.tableHeaderView = _detailHeader;
    
    [_detailHeader.attentBtn addTarget:self action:@selector(attentAuthor:) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeader.rewardBtn addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeader.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRewardDetail)];
    [_detailHeader.rewardListView addGestureRecognizer:tagGes];
}


- (void)initBottomView {

    _detailBottom = [[NSBundle mainBundle] loadNibNamed:@"DetailBottomView" owner:self options:nil].lastObject;
     [self.view addSubview:_detailBottom];
    
    [_detailBottom.editBtn addTarget:self action:@selector(commentArticle:) forControlEvents:UIControlEventTouchUpInside];
    [_detailBottom.commentBtn addTarget:self action:@selector(gotoCommentDetail) forControlEvents:UIControlEventTouchUpInside];
    [_detailBottom.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_detailBottom.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];

    [_detailBottom mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
}

- (void)initPopoverView {
    
    _popover = [DXPopover popover];
    GrassWeakSelf;
    NSArray *tittles = @[@"收藏", @"分享", @"举报"];
    NSArray *images = @[@"ic_wzxqsckblack", @"ic_wzxqfxblack", @"ic_wzxqjbblack"];
    _popView = [[DetailPopView alloc] initWithTitles:tittles images:images cellBlock:^(NSInteger indexRow) {
        if (indexRow == 0) {
            
            [weakSelf collectAction:nil];
        }
        else if (indexRow == 1) {

            [weakSelf shareAction];
        }
        else if (indexRow == 2) {
        
            weakSelf.reportType = ReportTypeArticle;
            [weakSelf complainAction];
        }
        
        [weakSelf.popover dismiss];
    }];
}


- (void)initRewardView {

    _rewardView = [[RewardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:_rewardView];
    
    GrassWeakSelf;
    _rewardView.selectedBlock = ^(CGFloat amount) {
    
        [weakSelf doRewardWithAmount:amount];
    };
    
}

- (void)initInputView {

    _inputView = [[NSBundle mainBundle] loadNibNamed:@"CommentInputView" owner:nil options:nil].lastObject;
    [self.view addSubview:_inputView];
    
    [_inputView.submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    
    _inputView.frame = CGRectMake(0, kScreenHeight -64, kScreenWidth, 195);
}


- (void)initEffectView {

    _effectView = [[EffectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_effectView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(effectViewOnClicked:)];
    [_effectView addGestureRecognizer:tapGR];
}

- (void)initRewardListView {

    RewadListViewController *rewardVC = [[RewadListViewController alloc] init];
    rewardVC.articleId = _articleId;
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:rewardVC.view];
    _rewardVC = rewardVC;
}

- (void)initShareView {
    
    GrassWeakSelf;
    _shareView = [[UMShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) viewController:nil eventType:^(UMSocialPlatformType platType) {
        
        [weakSelf doShareActionWithPlatType:platType];
    }];
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:_shareView];
}

- (void)doShareActionWithPlatType:(UMSocialPlatformType)platType {
    
    DoShareApi *doShareApi = [[DoShareApi alloc] init];
    GArticleModel *articleModel = self.shareObj;
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    [doShareApi doShareWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.shareNum = [NSString stringWithFormat:@"%@", resultData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"文章详情"];
    
    self.view.backgroundColor = kBackgroundColor;
    
    
    [UIBarButtonItem addRightItemWithImageName:@"ic_more_white" frame:CGRectMake(0, 0, 25, 20) vc:self action:@selector(rightBtnOnClicked)];
    
    _isKeyboardInputCoin = YES;
    
    
    [self initTableView];
    
    [self initHeaderView];

    [self initPopoverView];
    
    [self initBottomView];

    // 打赏弹框
    [self initRewardView];
    
    // 键盘弹出时, 蒙版背景
    [self initEffectView];
    
    [self initInputView];
    
    [self initShareView];
    
    // 回复弹框
    [self.replyPopupView hide];
    
    // 举报弹框
    [self.complainPopupView hide];

    // 文章打赏列表
    [self initRewardListView];
    
    
    [self getGeneralArticleInfo];
    
    [self addKeyBoardNotification];
}


- (void)addKeyBoardNotification {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardFrameChange:)
                                                 name:UIKeyboardWillChangeFrameNotification                                             object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [_inputView.textView endEditing:YES];
}

#pragma mark - Private
- (void)getGeneralArticleInfo {

    GeneralArticleDetailApi *articleInfoApi = [[GeneralArticleDetailApi alloc] init];
    //[self showIndicatorOnWindowWithMessage:@"加载中..."];
    [articleInfoApi getArticleDetailWithArticleId:_articleId callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        
        NSLog(@"进文章详情了%@", NSStringFromCGRect(self.view.frame));
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _articleModel = [GArticleModel mj_objectWithKeyValues:resultData];
            
            _detailHeader.articleModel = _articleModel;
         
            _detailBottom.collectBtn.selected = [PASS_NULL_TO_NIL(_articleModel.isCollect) integerValue] == 1;
            
            _detailTable.articleModel = _articleModel;
        }
        else if (code == 4040302) {
        
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            
            _detailTable.hidden = YES;
            [[self createBlankView] shouldShow:YES];
            
            _detailBottom.hidden = YES;
            
            [UIBarButtonItem addRightItemWithImageName:@"" frame:CGRectMake(0, 0, 25, 20) vc:self action:nil];

        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getCommentList {

    CommentListApi *commentListApi = [[CommentListApi alloc] init];
    [commentListApi getCommentListWithArticleId:_articleId firstRow:0 fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            CommentListModel *commentlistModel = [CommentListModel mj_objectWithKeyValues:resultData];
            
            _articleModel.articleCommentList = commentlistModel;
            
            _detailTable.articleModel = _articleModel;

        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)getRewardList {

    GetRewardListApi *rewarListApi = [[GetRewardListApi alloc] init];
    
    [rewarListApi getRewaedListWithArticleId:_articleId firstRow:0 fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        if (code == 0) {
       
            DICTIONARY_NIL_NULL(resultData);
            UserListModel *userListModel = [UserListModel mj_objectWithKeyValues:resultData];
            _articleModel.articleRewardList = userListModel;
         
            [_detailHeader changeRewardList:_articleModel];
        }
    }];
}


#pragma mark - Keyboard Events
- (void)handleKeyboardFrameChange:(NSNotification*)notification {
    
    if (_isKeyboardInputCoin) {
        return;
    }
    
    _inputView.size = CGSizeMake(kScreenWidth, 195);
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = rect.origin.y;
    keyboardY = ABS(keyboardY - kScreenHeight) > 0.1 ? keyboardY: keyboardY + 195;
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offsetY = keyboardY - self.view.frame.size.height - 64 - 195;
        _inputView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
    
}

- (void)handleKeyboardDidShow:(NSNotification*)notification {
    
    [_effectView show];
}

- (void)handleKeyboardDidHidden:(NSNotification*)notificaiton {

    
    _isKeyboardInputCoin = YES;
    [_effectView hide];
    
}


#pragma mark - Events
- (void)rightBtnOnClicked {

    if ([PASS_NULL_TO_NIL(_articleModel.isCollect) integerValue] == 1) {
     
        [_popView replaceTitle:@"取消收藏" images:@"ic_wzxqscs" index:0];
    }
    else {
        [_popView replaceTitle:@"收藏" images:@"ic_wzxqsckblack" index:0];
    }
    
    CGPoint startPoint = CGPointMake(kScreenWidth - 30, 64 -5);
    [_popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:_popView inView:[UIApplication sharedApplication].windows.lastObject];
}

- (void)collectAction:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    
    NSInteger articleId = [PASS_NULL_TO_NIL(_articleModel.articleId) integerValue];
    DoCollectApi *doCollectApi = [[DoCollectApi alloc] init];
    [doCollectApi doCollectWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
         
            _articleModel.isCollect = [NSString stringWithFormat:@"%@", resultData];
            
            BOOL isCollected = [PASS_NULL_TO_NIL(resultData) integerValue] ==1;
            _detailBottom.collectBtn.selected = isCollected;
            
            if (isCollected) {
                [self showSuccessIndicator:@"收藏成功"];
            }
            else {
                [self showSuccessIndicator:@"已取消收藏"];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)shareAction {

    self.shareObj = _articleModel;
    [_shareView show];
}


- (void)complainAction {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    [self.complainPopupView show];
}

- (void)effectViewOnClicked:(UIGestureRecognizer*)gesture {

    [self.view endEditing:YES];
    
    [_effectView hide];
}

- (void)submitComment:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    NSString *commentStr = _inputView.textView.text;
    if (commentStr.length == 0) {
        return;
    }
    
    [_inputView.textView endEditing:YES];
    
    NSInteger commentId = -1;
    if (_commentType == CommentTypeComment) {
        
        CommentModel *comentModel = _articleModel.articleCommentList.commentList[_handleIndex];
        commentId = [PASS_NULL_TO_NIL(comentModel.commentId) integerValue];
    }
    
    
    DoCommentApi *commentApi = [[DoCommentApi alloc] init];
    btn.userInteractionEnabled = NO;
    [commentApi doCommentWithArticleId:_articleId contents:commentStr commentId:commentId callback:^(id resultData, NSInteger code) {
        btn.userInteractionEnabled = YES;
        if (code == 0) {
            
            [self getCommentList];
            
            _inputView.textView.text = @"";
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];

}


- (void)doReportWithDesc:(NSString*)desc {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    
    // 1文章，2评论。
    NSInteger type = 0;
    NSInteger relationId = 0;
    if (_reportType == ReportTypeArticle) {
        
        type = 1;
        relationId = _articleId;
    }
    else {
    
        type = 2;
        CommentModel *comentModel = _articleModel.articleCommentList.commentList[_handleIndex];
        relationId = [PASS_NULL_TO_NIL(comentModel.commentId) integerValue];
    }
    
    // 1.其他原因
    if (desc.length == 0) {
        
        ReportViewController *reportVC = [[ReportViewController alloc] init];
        reportVC.type = type;
        reportVC.relationId = relationId;
        [self.navigationController pushViewController:reportVC animated:YES];
        
        return;
    }
    
    
    // 2.选择的原因
    ReportApi *reportApi = [[ReportApi alloc] init];
    [reportApi reportWithType:type relationId:relationId description:desc callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [self showSuccessIndicator:@"举报成功"];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)doRewardWithAmount:(CGFloat)amount {

    if (amount == 0) {
        
        [self showErrorMsg:@"请输入打赏金额"];
        return;
    }
    
    DoRewardApi *doRewardApi = [[DoRewardApi alloc] init];
    [doRewardApi doRewardWithArticleId:_articleId money:amount callback:^(id resultData, NSInteger code) {
        
        if (code == 0) {
            if ([PASS_NULL_TO_NIL(resultData) integerValue] == 1) {
             
                //[self showSuccessIndicator:[NSString stringWithFormat:@"打赏成功%li金币", (NSInteger)amount]];
                
                [self showSuccessIndicator:@"打赏成功"];

                [self getRewardList];
            }
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Header Event
- (void)attentAuthor:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    
    NSInteger userId = [PASS_NULL_TO_NIL(_articleModel.userId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:2 relationId:userId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *isFollow = resultData[@"is_follow"];
            _articleModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            
            btn.selected = ([isFollow integerValue] == 1);
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)showRewardDetail {
    
    [_rewardVC show];
}

- (void)rewardAction {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    [_rewardView show];
}

- (void)praiseAction:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    
    NSInteger articleId = [PASS_NULL_TO_NIL(_articleModel.articleId) integerValue];
    
    DoZanApi *doZanApi = [[DoZanApi alloc] init];
    [doZanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            _articleModel.zanNumStr = resultData[@"zan_num_str"];
            
            _detailHeader.isPraised = [PASS_NULL_TO_NIL(resultData[@"is_zan"]) integerValue] == 1;

            _detailHeader.praiseLabel.text = resultData[@"zan_num_str"];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)praiseRecommendArticleActionWithIndex:(NSInteger)index {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    
    GArticleModel *articleModel = _articleModel.otherArticleList[index];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DoZanApi *doZanApi = [[DoZanApi alloc] init];
    [doZanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.isZan = resultData[@"is_zan"];
            
            NSString *zanNumStr = resultData[@"zan_num_str"];
            
            articleModel.zanNum = zanNumStr;
            _detailTable.articleModel = _articleModel;
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)praiseCommentActionWithIndex:(NSInteger)index {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    CommentModel *commentModel = _articleModel.articleCommentList.commentList[index];
    NSInteger commentId = [PASS_NULL_TO_NIL(commentModel.commentId) integerValue];
    
    DoZanApi *doZanApi = [[DoZanApi alloc] init];
    [doZanApi doZanWithType:2 relationId:commentId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            commentModel.isZan = resultData[@"is_zan"];
            
            NSString *zanNumStr = resultData[@"zan_num_str"];
            
            commentModel.zanNum = zanNumStr;
            
            _detailTable.articleModel = _articleModel;
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - BottomView Event
- (void)commentArticle:(UIButton*)button {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }

    _isKeyboardInputCoin = NO;
    
    
    if (button) {
        _commentType = CommentTypeArticle;
    }

    [_inputView.textView becomeFirstResponder];
}

- (void)gotoCommentDetail {

    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.articleModel = _articleModel;
    [self.navigationController pushViewController:commentVC animated:YES];
}



#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {


    [self getCommentList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {

}

- (void)refreshTableView:(BaseTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_detailTable.isRecommend) {
        
        
    }
    else {
    
        _handleIndex = indexPath.row;
        _commentType = CommentTypeComment;
        _reportType = ReportTypeComment;
        
        [self.replyPopupView show];
    }
}

- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {

    NSArray *tagArr = [sender.stringTag componentsSeparatedByString:@","];
    NSString *type = tagArr[0];
    NSInteger row  = [PASS_NULL_TO_NIL(tagArr[2]) integerValue];
    
    if ([type isEqualToString:@"PraiseComment"]) {
        
        [self praiseCommentActionWithIndex:row];
        return;
    }
    
    
    GArticleModel *articleModel = _articleModel.otherArticleList[row];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    if([type isEqualToString:@"RecPraiseDetail"]){
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.articleId = articleId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else if([type isEqualToString:@"RecShare"]){
        
        self.shareObj = articleModel;
        [_shareView show];
    }
    else if([type isEqualToString:@"RecComment"]){
        
//        CommentViewController *commentVC = [[CommentViewController alloc] init];
//        commentVC.articleModel = articleModel;
//        [self.navigationController pushViewController:commentVC animated:YES];
    }
    else if([type isEqualToString:@"RecPraise"]){
        
        [self praiseRecommendArticleActionWithIndex:row];
    }
    else if([type isEqualToString:@"RecAuthor"]){
        
        
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
        personVC.keyword = articleModel.userInfo.nickname;
        personVC.userId = [articleModel.userInfo.userId integerValue];

        [self.navigationController pushViewController:personVC animated:YES];
    }
    

}




@end
