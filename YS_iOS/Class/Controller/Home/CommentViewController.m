//
//  CommentViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CommentViewController.h"
#import "DetailViewController.h"
#import "CanlePublishTipView.h"
#import "ReportViewController.h"


#import "CommentTable.h"
#import "CommentHeader.h"
#import "CommentBottomView.h"
#import "CommentInputView.h"
#import "EffectView.h"
#import "CommentInputView.h"


#import "GArticleModel.h"


#import "CommentListApi.h"
#import "DoCommentApi.h"
#import "ReportApi.h"
#import "DoZanApi.h"



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



@interface CommentViewController () <RefreshTableViewDelegate>


@property (nonatomic, strong) CommentTable *tableView;

@property (nonatomic, strong) CommentHeader *headerView;

@property (nonatomic, strong) CommentBottomView *bottomView;

@property (nonatomic, strong) CommentInputView *inputView;  // 回复输入框

@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) CommentListModel *commentListModel;


@property (nonatomic, strong) CanlePublishTipView *replyPopupView;
@property (nonatomic, strong) CanlePublishTipView *complainPopupView;

@property (nonatomic, strong) EffectView *effectView;



@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, assign) PraiseType  praiseType;
@property (nonatomic, assign) ReportType  reportType;


@property (nonatomic, assign) NSInteger handleIndex;


@end

@implementation CommentViewController


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
        [self.navigationController.view addSubview:_replyPopupView];
        
        GrassWeakSelf;
        _replyPopupView.eventBlock = ^(NSInteger index) {
            if (index == 0) {
                
                [weakSelf commentArticle:nil];
            }
            else if (index == 1) {
                
                if (![UserDefaultsUtil isContainUserDefault]) {
                    
                    [weakSelf showReLoginVC];
                    return;
                }
                
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
        [self.navigationController.view addSubview:_complainPopupView];
     
        
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

- (void)initHeaderView {

    _headerView = [[NSBundle mainBundle] loadNibNamed:@"CommentHeader" owner:nil options:nil].lastObject;
    _tableView.tableHeaderView = _headerView;
    
    [_headerView.detailBtn addTarget:self action:@selector(seeArticleDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    _headerView.articleModel = _articleModel;
}

- (void)initTableView {


    _tableView = [[CommentTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -49) style:UITableViewStylePlain];
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    [self.view addSubview:_tableView];
}

- (void)initBottomView {

    _bottomView = [[NSBundle mainBundle] loadNibNamed:@"CommentBottomView" owner:nil options:nil].lastObject;
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.mas_offset(0);
        make.height.mas_offset(49);
    }];
    
    GrassWeakSelf;
    _bottomView.touchBlock = ^() {
    
        weakSelf.commentType = CommentTypeArticle;
        [weakSelf.inputView.textView becomeFirstResponder];
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


#pragma mark - Life Cycle
- (void)viewDidLoad {
   [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"评论"];
    

    [self initTableView];
    
    [self initHeaderView];
    
    [self initBottomView];
    
    [self addKeyBoardNotification];
    
    [self initEffectView];
    
    [self initInputView];

    
    [self.replyPopupView hide];
    
    
    [self.complainPopupView hide];
    
    
    [self getCommentList];

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
    [self.view endEditing:YES];
}


#pragma mark - Private
- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
}

- (void)getCommentList {
    
    NSInteger articleId = [PASS_NULL_TO_NIL(_articleModel.articleId) integerValue];
    articleId = (articleId > 0) ? articleId : _articleId;
    
    CommentListApi *commentListApi = [[CommentListApi alloc] init];
    [commentListApi getCommentListWithArticleId:articleId firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _commentListModel = [[CommentListModel alloc] init];
                _commentListModel.commentList =  @[].mutableCopy;;
            }
            
            if (_articleModel == nil) {
                
                _articleModel = [GArticleModel mj_objectWithKeyValues:resultData[@"article_info"]];
                _headerView.articleModel = _articleModel;
            }
            
            CommentListModel *commentListModel = [CommentListModel mj_objectWithKeyValues:resultData];
            [_commentListModel.commentList addObjectsFromArray:commentListModel.commentList];

            if ([PASS_NULL_TO_NIL(commentListModel.total) integerValue] > 0) {
                _commentListModel.total = commentListModel.total;
            }
            
            _tableView.commentListModel = _commentListModel;
            
            
            // 有数据
            if (commentListModel.commentList.count >= kPageFetchNum) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_tableView noDataTips];
            }
            
            
        }
        else if (code == 4050202) {
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            
            _tableView.hidden = YES;
            [[self createBlankView] shouldShow:YES];
            
            _bottomView.hidden = YES;
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
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
        
        CommentModel *comentModel = _commentListModel.commentList[_handleIndex];
        commentId = [PASS_NULL_TO_NIL(comentModel.commentId) integerValue];
    }
    
    NSInteger articleId = [PASS_NULL_TO_NIL(_articleModel.articleId) integerValue];
    btn.userInteractionEnabled = NO;
    DoCommentApi *commentApi = [[DoCommentApi alloc] init];
    [commentApi doCommentWithArticleId:articleId contents:commentStr commentId:commentId callback:^(id resultData, NSInteger code) {
        btn.userInteractionEnabled = YES;
        if (code == 0) {
            
            _firstRow = 0;
            [self getCommentList];
            
            _inputView.textView.text = @"";
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
    
    
    CommentModel *commentModel = _commentListModel.commentList[index];
    NSInteger commentId = [PASS_NULL_TO_NIL(commentModel.commentId) integerValue];
    
    DoZanApi *doZanApi = [[DoZanApi alloc] init];
    [doZanApi doZanWithType:2 relationId:commentId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            commentModel.isZan = resultData[@"is_zan"];
            
            NSString *zanNumStr = resultData[@"zan_num_str"];
            
            commentModel.zanNum = zanNumStr;
            
            _tableView.commentListModel = _commentListModel;
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - Events
- (void)commentArticle:(UIButton*)button {
    
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    
    
    _commentType = CommentTypeComment;
    
    [_inputView.textView becomeFirstResponder];
}

- (void)effectViewOnClicked:(UIGestureRecognizer*)gesture {
    
    [self.view endEditing:YES];
    
    [_effectView hide];
}


- (void)doReportWithDesc:(NSString*)desc {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    
    // 1文章，2评论。
    NSInteger type = 2;
    CommentModel *comentModel = _commentListModel.commentList[_handleIndex];
    NSInteger relationId = [PASS_NULL_TO_NIL(comentModel.commentId) integerValue];
    
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


- (void)seeArticleDetail:(UIButton*)button {

    NSInteger articleId = [PASS_NULL_TO_NIL(_articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Keyboard Events
- (void)handleKeyboardFrameChange:(NSNotification*)notification {
    
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

    
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
}

- (void)handleKeyboardDidHidden:(NSNotification*)notificaiton {
    
    [_effectView hide];
}

#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [_tableView resetDataTips];
    
    [self getCommentList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
 

    [self getCommentList];
}

- (void)refreshTableView:(BaseTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _handleIndex = indexPath.row;
    _commentType = CommentTypeComment;
    
    [self.replyPopupView show];
}

- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {
    
    NSArray *tagArr = [sender.stringTag componentsSeparatedByString:@","];
    NSString *type = tagArr[0];
    NSInteger section = [PASS_NULL_TO_NIL(tagArr[1]) integerValue];
    NSInteger row  = [PASS_NULL_TO_NIL(tagArr[2]) integerValue];
 
    if ([type isEqualToString:@"PraiseComment"]) {
        
        
        [self praiseCommentActionWithIndex:row];
    }
}






@end
