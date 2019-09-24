//
//  PublishViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishViewController.h"


#import "AddTagViewController.h"
#import "ArticlePreviewViewController.h"
#import "PublishPerformViewController.h"


#import "PublishHeader.h"
#import "PublishTable.h"
#import "PublishBar.h"
#import "CanlePublishTipView.h"

#import "PublishImgCell.h"


#import "GetPreviewDetailApi.h"
#import "SaveArticleaPI.h"
#import "ReleaseArticleApi.h"
#import "UploadImageApi.h"
#import "UserArticleDetailApi.h"


#import "ArticleModel.h"

#import "TagModel.h"
#import "GArticleModel.h"


#import "SelectPhotoUtil.h"
#import "UIView+FirstResponder.h"
#import "UIImage+Custom.h"

#import "HZPhotoBrowser.h"
#import "ZLPhotoActionSheet.h"


@interface PublishViewController () <RefreshTableViewDelegate, HZPhotoBrowserDelegate>


@property (nonatomic, strong) AddTagViewController *addTagVC;


@property (nonatomic, strong) PublishTable *tableView;
@property (nonatomic, strong) PublishHeader *tableHeader;


@property (nonatomic, strong) CanlePublishTipView *tipView;

// 键盘上方编辑框
@property (nonatomic, strong) PublishBar *editBar;


// 当前数据源模型
@property (nonatomic, strong) ArticleModel *articleModel;


// 当前插入图片位置
@property (nonatomic, assign) NSInteger insertIndex;  // 代表第几个model
@property (nonatomic, assign) NSRange insertRange;    // 代表文字range

@property (nonatomic, strong) NSString *tagIdStr;
@property (nonatomic, strong) NSString *tagStr;

@property (nonatomic, strong)  GArticleModel *gArticleModel;





@end

@implementation PublishViewController


#pragma mark - Init
- (void)initTable {

    _tableView = [[PublishTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain];
    _tableView.refreshDelegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView updateTableDatasSource:_articleModel];

    
    GrassWeakSelf;
    // 1.cell上textView是去第一响应者时调用，刷新数据
    _tableView.editBlock = ^(NSString *text, NSInteger tag, EditStatus editStatus, NSRange selectRange) {
    
        [weakSelf handleTextViewCallBackWithText:text index:tag editStatus:editStatus range:selectRange];
    };
 
    
    // 2/tableView 拖动，重置插入图片位置为最后一行(小草项目没有作用)
    _tableView.scrollBlock = ^() {
    
        [weakSelf resetInsertLocationToEnd];
        [weakSelf.view endEditing:YES];
    };
    
    // 3.textview开始响应，文字改变时调用；改变输入框为位置为可见
    _tableView.cellDidChangeEdit = ^(CGRect textViewFrame) {
    
        textViewFrame.origin.y = textViewFrame.origin.y + 40;
        
        [weakSelf.tableView scrollRectToVisible:textViewFrame animated:YES];
    };
}


// 更新textView文字到模型中
- (void)handleTextViewCallBackWithText:(NSString*)text index:(NSInteger)index editStatus:(EditStatus)status range:(NSRange)selectRange {

    PublishModel *publishModel = _articleModel.modelList[index];
    publishModel.content = text;
    
    _insertIndex = index;
    _insertRange = selectRange;
    
    if (status == EditStatusEnd) {
        [_tableView updateTableDatasSource:_articleModel];
    }
}


- (void)initTableHeader {

    _tableHeader = [[NSBundle mainBundle] loadNibNamed:@"PublishHeader" owner:nil options:nil].lastObject;
    _tableHeader.frame = CGRectMake(0, 0, kScreenWidth, 100);
    _tableView.tableHeaderView = _tableHeader;
    [_tableHeader.addTagBtn addTarget:self action:@selector(addTagAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initFooter {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(footerViewOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, kScreenWidth, 200);
    _tableView.tableFooterView = button;
}


- (void)initEditBar {
    
    GrassWeakSelf;
    _editBar = [[NSBundle mainBundle] loadNibNamed:@"PublishBar" owner:nil options:nil].lastObject;
    _editBar.frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 40);
    [self.view addSubview:_editBar];

    _editBar.eventBlock = ^(PublishBarEvent eventType) {
        
        [weakSelf insertImage];
    };
}

- (void)initTipView {

    NSArray *titles = @[@"保存草稿", @"放弃编辑", @"取消"];
    _tipView = [[CanlePublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
    [self.navigationController.view addSubview:_tipView];
    
    GrassWeakSelf;
    _tipView.eventBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf saveArticle];
        }
        else if (index == 1) {
        
            [weakSelf quitArticle];
        }
    };
    
}

- (void)initNavBar {

    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 11, 20) vc:self action:@selector(dismissController:)];

    UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previewBtn.lk_attribute
    .normalTitle(@"预览")
    .normalTitleColor(kNavBarMainColor)
    .event(self, @selector(preViewArticle:))
    .font(16);

    previewBtn.frame = CGRectMake(0, 0, 35, 20);
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.lk_attribute
    .normalTitle(@"发布")
    .normalTitleColor(kNavBarMainColor)
    .event(self, @selector(publishArticle:))
    .font(16);
    
    publishBtn.frame = CGRectMake(0, 0, 35, 20);

    UIBarButtonItem *itemPreview = [[UIBarButtonItem alloc] initWithCustomView:previewBtn];
    UIBarButtonItem *itemPublish = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItems = @[itemPreview, itemPublish];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"写文章"];
    
    [self initNavBar];
    
    if (_articleModel == nil && _pushlishType == PushlishTypeAdd) {
        
        _articleModel = [[ArticleModel alloc] init];
        PublishModel *publishModel = [[PublishModel alloc] init];
        [_articleModel.modelList addObject:publishModel];
    }

    
    [self initTable];
    
    [self initTableHeader];

    [self initEditBar];
    
    [self initTipView];
    
    
    [self initFooter];
    
    [self addKeyBoardNotification];
    
    
    [self getArticleDetailInfo];
    
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

    // 1.当用户还未写文章前，点击空白地方，响应文章详情textView
    if (_articleModel.modelList.count == 1) {

        PublishTextCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textField becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

// 禁用侧滑 返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}


#pragma mark - Private
- (void)getArticleDetailInfo {

    if (_pushlishType == PushlishTypeAdd) {
        return;
    }
    
    [self showIndicatorOnWindowWithMessage:@"加载中..."];
    UserArticleDetailApi *detailApi = [[UserArticleDetailApi alloc] init];
    [detailApi getArticleDetailWithArticleId:_articleId callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _gArticleModel = [GArticleModel mj_objectWithKeyValues:resultData];
        
            [self handleGArticleModel:_gArticleModel];
        }
        // 显示加载错误界面
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)handleGArticleModel:(GArticleModel*)articleModel {

    // 标题
    _tableHeader.titleLabel.text = _gArticleModel.title;
    
    NSMutableArray *tagNames = @[].mutableCopy;
    NSMutableArray *tagIds = @[].mutableCopy;
    for (TagModel *tagModel in _gArticleModel.tagList) {
        
        [tagNames addObject:tagModel.tagName];
        [tagIds addObject:tagModel.tagId];
    }
    
    _tagIdStr = [tagIds componentsJoinedByString:@","];
    _tagStr = [tagNames componentsJoinedByString:@"、"];
    
    //文章
    _tableHeader.tagLabel.text = _tagStr;

    // 构造发布模型
    NSMutableArray *textList = _gArticleModel.textList;
    _articleModel = [[ArticleModel alloc] init];
    
    for (NSInteger i = 0; i < textList.count; i++) {
        
        NSDictionary *dic = textList[i];
        BOOL isPic = [PASS_NULL_TO_NIL(dic[@"is_pic"]) integerValue] == 1;
        NSString *contents = dic[@"line"];
        STRING_NIL_NULL(contents);
        
        // 第一个
        if (i == 0) {
            
            PublishModel *publishModel = [[PublishModel alloc] init];
            [_articleModel.modelList addObject:publishModel];
            if (isPic) {
                
                publishModel.imgUrl = contents;
            }
            else {
                
                publishModel.content = contents;
            }
        }
        else {
        
            PublishModel *lastModel = _articleModel.modelList.lastObject;
            BOOL isPicLast = lastModel.imgUrl.length > 0;
            
            // 图片
            if (isPic) {
                
                if (isPicLast) {
                 
                    PublishModel *publishModel = [[PublishModel alloc] init];
                    [_articleModel.modelList addObject:publishModel];
                    publishModel.imgUrl = contents;
                }
                else {
                
                    lastModel.imgUrl = contents;
                }
                
            }
            // 文字一定创建新的model
            else {
            
                PublishModel *publishModel = [[PublishModel alloc] init];
                [_articleModel.modelList addObject:publishModel];
                publishModel.content = contents;
            }
            
        }
        if (i == textList.count -1) {
            
            if (isPic) {
                
                PublishModel *publishModel = [[PublishModel alloc] init];
                [_articleModel.modelList addObject:publishModel];
            }
        }
        
    }
    
    [_tableView updateTableDatasSource:_articleModel];
}


- (void)resetInsertLocationToEnd {

    _insertIndex = _articleModel.modelList.count -1;
    PublishModel *publishModel = _articleModel.modelList.lastObject;
    _insertRange = NSMakeRange(publishModel.content.length, 0);
}


- (NSString*)getArticleJsonString {
    
    // 1.构造数组
    NSMutableArray *textList = @[].mutableCopy;
    for (PublishModel *model in _articleModel.modelList) {
        
        // 文字
        if (model.content.length) {
            
            NSMutableDictionary *dic = @{@"is_pic": @"0",
                                         @"line"  : model.content
                                         }.mutableCopy;
            
            [textList addObject:dic];
        }
        
        // 图片
        if (model.imgUrl.length > 0) {
            
            NSMutableDictionary *dic = @{@"is_pic": @"1",
                                         @"line"  : model.imgUrl
                                         }.mutableCopy;
            [textList addObject:dic];
        }
    }
    
    if (textList.count == 0) {
        return @"";
    }
    
    // 2.数组转化为json
    NSString *jsonStr = [NSString serializeMessage:textList];
    
    return jsonStr;
}



#pragma mark - Keyboard Events
- (void)handleKeyboardFrameChange:(NSNotification*)notification {

    _editBar.size = CGSizeMake(kScreenWidth, 40);
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = rect.origin.y;
    keyboardY = ABS(keyboardY - kScreenHeight) > 0.1 ? keyboardY: keyboardY + 40;
    
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offsetY = keyboardY - self.view.frame.size.height - 64 - 40;

        _editBar.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
    
}

- (void)handleKeyboardDidShow:(NSNotification*)notification {

    
    NSDictionary *userInfo = notification.userInfo;
    
    // CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
   // 获取键盘高度

    _tableView.contentInset = UIEdgeInsetsMake(0, 0,rect.size.height, 0);
}

- (void)handleKeyboardDidHidden:(NSNotification*)notificaiton {
    
    _tableView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - Events
- (void)footerViewOnClicked:(UIButton*)btn {

    NSInteger count = _articleModel.modelList.count;
    if (count < 1) {
        return;
    }
    
    NSInteger indexRow = (count - 1)*2;
    UIView *fisrtResponder = [self.view getFirstResponder];
    
    if (!fisrtResponder) {
        PublishTextCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0]];
        [cell.textField becomeFirstResponder];
    }
}


- (void)dismissController:(UIButton*)button {

    [self.view endEditing:YES];
    
    NSString *jsonStr = [self getArticleJsonString];
    
    NSString *articleTitle = _tableHeader.titleLabel.text;
    
    
    if (_tagIdStr.length==0 && jsonStr.length==0 && articleTitle.length == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [_tipView show];
}

- (void)saveArticle {
    
    [self saveArticleWithRelease:NO];
}

- (void)quitArticle {

    [self.navigationController popViewControllerAnimated:YES];
}


// 预览文章
- (void)preViewArticle:(UIButton*)btn {
    
    [self.view endEditing:YES];
    
    NSString *jsonStr = [self getArticleJsonString];
    
    NSString *articleTitle = _tableHeader.titleLabel.text;
    
    NSString *msg = @"";
    if (jsonStr.length == 0) {
        msg = @"请添加文章内容";
    }
    else if (_tagIdStr.length == 0) {
        msg = @"请选择文章标签";
    }
    else if (articleTitle.length == 0) {
        msg = @"请填写文章标题";
    }
    if (msg.length > 0) {
        
        [self showErrorMsg:msg];
        return;
    }
    
    btn.userInteractionEnabled = NO;
    GetPreviewDetailApi *previewApi = [[GetPreviewDetailApi alloc] init];
    [previewApi getPreviewDetailWithTextList:jsonStr callback:^(id resultData, NSInteger code) {
        
        btn.userInteractionEnabled = YES;
        if (code == 0) {
            
            ArticlePreviewViewController *previewVC = [[ArticlePreviewViewController alloc] init];
            previewVC.articleId = _articleId;
            
            previewVC.htmlStr = resultData;
            previewVC.articleTitle = articleTitle;
            previewVC.tagList = _tagIdStr;
            previewVC.textList = jsonStr;
            
            previewVC.tagStr = [self.tagStr stringByReplacingOccurrencesOfString:@"、" withString:@" · "];
            
            [self.navigationController pushViewController:previewVC animated:YES];
        }
        else {
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


// 发布文章
- (void)publishArticle:(UIButton*)btn {
    
    [self.view endEditing:YES];
    
    [self saveArticleWithRelease:YES];
}

- (void)saveArticleWithRelease:(BOOL)isRelease {

    NSString *jsonStr = [self getArticleJsonString];
    
    NSString *articleTitle = _tableHeader.titleLabel.text;
    
    NSString *msg = @"";
    if (jsonStr.length == 0) {
        msg = @"请添加文章内容";
    }
    else if (_tagIdStr.length == 0) {
        msg = @"请选择文章标签";
    }
    else if (articleTitle.length == 0) {
        msg = @"请填写文章标题";
    }
    
    if (msg.length > 0) {
        
        [self showErrorMsg:msg];
        return;
    }
    
    
    _articleId = (_pushlishType == PushlishTypeEdit) ? _articleId : -1;
    SaveArticleaPI *saveArticleApi = [[SaveArticleaPI alloc] init];
    [saveArticleApi saveArticleWithArticleId:_articleId title:articleTitle tagList:_tagIdStr textList:jsonStr callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSInteger articleId = [PASS_NULL_TO_NIL(resultData) integerValue];
            if (articleId > 0 && isRelease) {
                
                [self releaseAricleWithArticleId:articleId];
            }
            
            if (!isRelease) {
                
                [self showSuccessIndicator:@"保存成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)releaseAricleWithArticleId:(NSInteger)articleId {
    
    [self showIndicatorOnWindowWithMessage:@"发布中..."];
    ReleaseArticleApi *releaseApi = [[ReleaseArticleApi alloc] init];
    [releaseApi releaseArticleWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            PublishPerformViewController *publishPerformVC = [[PublishPerformViewController alloc] init];
            [self.navigationController pushViewController:publishPerformVC animated:YES];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


// 添加标签
- (void)addTagAction:(UIButton*)btn {

    [self.view endEditing:YES];
    
    if (_addTagVC == nil) {
        
        GrassWeakSelf;
        _addTagVC = [[AddTagViewController alloc] init];
        _addTagVC.sureBlock = ^(NSArray *tagList, NSString *tagIdStr, NSString *tagNameStr) {
                        
            weakSelf.tableHeader.tagLabel.text = tagNameStr;
            weakSelf.tagStr = tagNameStr;
            weakSelf.tagIdStr = tagIdStr;
        };
    }
    
    [self.navigationController pushViewController:_addTagVC animated:YES];
}


- (void)insertImage {

    [self.view endEditing:YES];
    
    GrassWeakSelf;
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 6;
    [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:@[] completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        
        [weakSelf hanleSelectImgs:selectPhotos];
    }];
    
    
    return;
    
    // 原生单张图片选择
    SelectPhotoUtil *photoUtil = [SelectPhotoUtil shareInstance];
    [photoUtil selectImageViewWithViewController:self success:^(UIImage *image, NSDictionary *info) {
        
        CGFloat widthImg = image.size.width;
        CGFloat heightImg = image.size.height;
        
        image = [UIImage getHumbnailImage:image scaledToSize:CGSizeMake(375 *1.5, heightImg *1.5/(widthImg/375))];
        
        NSData *data = UIImagePNGRepresentation(image);
        
        [self showIndicatorOnWindowWithMessage:@"上传图片中..."];
        UploadImageApi *uploadApi = [[UploadImageApi alloc] init];
        [uploadApi uploadImageWithData:data dir:@"article" callback:^(id resultData, NSInteger code) {
            [self hideIndicatorOnWindow];
            if (code == 0) {

                [self insertImgSuccessWithImg:image imgUrl:resultData];
            }
            else {
                
                [self showErrorMsg:resultData[@"msg"]];
            }
        }];
        
    }];
}


- (void)hanleSelectImgs:(NSArray*)selectPhotos {
    
    dispatch_group_t group = dispatch_group_create();
    [self showIndicatorOnWindowWithMessage:@"上传图片中..."];
    
    NSMutableDictionary *imgDic = @{}.mutableCopy;
    for (NSInteger i = 0; i < selectPhotos.count; i++) {
        
        UIImage *img = selectPhotos[i];
    
        dispatch_group_enter(group);
        NSData *data = UIImagePNGRepresentation(img);
        NSLog(@"%li", data.length);
        
        UploadImageApi *uploadApi = [[UploadImageApi alloc] init];
        [uploadApi uploadImageWithData:data dir:@"article" callback:^(id resultData, NSInteger code) {
            if (code == 0) {
                
                imgDic[[NSString stringWithFormat:@"%li", i]] = resultData;
            }
            else {
                
                [self showErrorMsg:resultData[@"msg"]];
            }
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self hideIndicatorOnWindow];
        
        NSArray *keyArr = [imgDic allKeys];
        NSArray *arrrayordered =  [keyArr sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];

        NSMutableArray *imgUrlArr = @[].mutableCopy;
        NSMutableArray *imgArr = @[].mutableCopy;
        for (NSString *key in arrrayordered) {
            
            [imgUrlArr addObject:imgDic[key]];
            [imgArr addObject:selectPhotos[[key integerValue]]];
        }
        
        [self insertImgSuccessWithImgs:imgArr imgUrls:imgUrlArr];
    });

}

// 插入单张图片
- (void)insertImgSuccessWithImg:(UIImage*)image imgUrl:(NSString*)imgUrl {

    // 1.获取当前正在编辑的模型
    PublishModel *publishModel = _articleModel.modelList[_insertIndex];
    
    
    // 2.分隔编辑模型的文字
    NSString *content = publishModel.content;
    NSInteger location = _insertRange.location;
    
    NSString *leftContent = [content substringToIndex:location];
    NSString *nextString = [content substringFromIndex:location];
    
    publishModel.content = leftContent;
    
    
    // 3.创建新的模型, 把上个模型的图片，存到下一个模型
    PublishModel *newModel = [[PublishModel alloc] init];
    newModel.content = nextString;
    
    
    newModel.image = publishModel.image;
    newModel.imgUrl = publishModel.imgUrl;
    
    
    [_articleModel.modelList insertObject:newModel atIndex:_insertIndex+1];
    
    
    // 4.设置当前模型图片图片
    publishModel.image = image;
    publishModel.imgUrl = imgUrl;
    
    [_tableView updateTableDatasSource:_articleModel];
    
    // 4.设置添加图片到结尾位置
    [self resetInsertLocationToEnd];
}

// 插入多张图片
- (void)insertImgSuccessWithImgs:(NSArray*)imgs imgUrls:(NSArray*)imgUrls {
    
    // 1.获取当前正在编辑的模型
    PublishModel *publishModel = _articleModel.modelList[_insertIndex];
    

    // 2.分隔编辑模型的文字
    NSString *content = publishModel.content;
    NSInteger location = _insertRange.location;
    
    NSString *leftContent = [content substringToIndex:location];
    NSString *nextString = [content substringFromIndex:location];
    
    
    
    // 3.创建新的模型, 把上个模型的图片，存到下一个模型
    NSMutableArray *insertModels = @[].mutableCopy;
    for (NSInteger i = 0; i < imgs.count; i ++) {
        
        PublishModel *addModel = [[PublishModel alloc] init];
        [insertModels addObject:addModel];

        if (i < imgs.count - 1) {
            
            addModel.image = imgs[i+1];
            addModel.imgUrl = imgUrls[i+1];
        }
        else {
        
            addModel.image = publishModel.image;
            addModel.imgUrl = publishModel.imgUrl;
            addModel.content = nextString;
        }
       
    }
    
    // 4.设置当前模型图片图片
    publishModel.content = leftContent;
    publishModel.image = imgs.firstObject;
    publishModel.imgUrl = imgUrls.firstObject;

    
    [_articleModel.modelList insertObjects:insertModels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_insertIndex+1, insertModels.count)]];

    [_tableView updateTableDatasSource:_articleModel];
    
    // 4.设置添加图片到结尾位置
    [self resetInsertLocationToEnd];
}

#pragma mark - RefreshTableViewDelegate
- (void)refreshTableView:(BaseTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%2 == 0) {
        return;
    }
    
    /*
    NSArray *modelList = _articleModel.modelList;
    NSMutableArray *imageArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = 0; i < modelList.count; i++) {
        
        PublishModel *publishModel = modelList[i];
        if (publishModel.imgUrl.length > 0) {
            
            [imageArr addObject:publishModel.imgUrl];
            if (indexPath.row == i*2 +1) {
                
                index = imageArr.count -1;
            }
        }
    }
    */
 
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        PublishImgCell *cell = [refreshTableview cellForRowAtIndexPath:indexPath];
        if (cell.imgView.image.size.height < 1) {
            return ;
        }
        
        //启动图片浏览器
        HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
        browserVc.sourceImagesContainerView = cell.imgView; // 原图的父控件
        browserVc.imageCount = 1; // 图片总数
        browserVc.currentImageIndex = 0;
        browserVc.delegate = self;
        [browserVc show];
    });
    
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imgView = (UIImageView*)browser.sourceImagesContainerView;
    return [imgView image];
}

/*
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    UIImageView *imgView = (UIImageView*)browser.sourceImagesContainerView;
    PublishModel *publishModel = _articleModel.modelList[0];
    return [NSURL URLWithString:publishModel.imgUrl];
}
*/


- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {

    PublishModel *publishModel = _articleModel.modelList[index];
    publishModel.image = nil;
    publishModel.imgUrl = nil;
    
    [_tableView updateTableDatasSource:_articleModel];
}



@end
