//
//  PublishTable.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishTable.h"
#import "PublishImgCell.h"


static NSString *imgCellIndentifier = @"imgCellIndentifier";
static NSString *textCellIndentifier = @"textCellIndentifier";



@interface PublishTable ()


@property (nonatomic, strong) ArticleModel *articleModel;


@end

@implementation PublishTable


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.delegate = self;
        
        self.backgroundColor = kWhiteColor;
        
        [self registerClass:[PublishImgCell class] forCellReuseIdentifier:imgCellIndentifier];
        
        [self registerClass:[PublishTextCell class] forCellReuseIdentifier:textCellIndentifier];

    }

    return self;
}


#pragma mark - Public
- (void)updateTableDatasSource:(ArticleModel*)articleModel {

    _articleModel = articleModel;
    [self reloadData];
}


#pragma mark - Event
- (void)deleteBtnOnClicked:(UIButton*)btn {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:btn SelectRowAtIndex:(btn.tag -1000)/2];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return _articleModel.modelList.count *2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PublishModel *model = _articleModel.modelList[indexPath.row/2];

    if (indexPath.row%2 == 0) {

        PublishTextCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIndentifier forIndexPath:indexPath];
        cell.textField.tag = indexPath.row/2 + 1000;
        
        cell.editBlock = _editBlock;
        
        cell.content = model.content;
        
        
        GrassWeakSelf;
        // 当前单元格换行，下面的单元格一次往下移动
        __weak PublishTextCell *weakCell = cell;
        cell.reloadBlock = ^(NSInteger index, CGRect cursorRowFrame) {
      

            NSArray *indexPaths = [weakSelf indexPathsForVisibleRows];
            for (NSIndexPath *path in indexPaths) {
                
                if (path.row > index*2) {
                    
                    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
                    PublishTextCell *lastCell = [self cellForRowAtIndexPath:lastPath];
                    
                    PublishTextCell *nextCell = [self cellForRowAtIndexPath:path];
                    
                    nextCell.top = lastCell.bottom;
                }
            }
            
            CGRect textViewFrame = [self convertRect:cursorRowFrame fromView:weakCell.textField];
            
            // 回调到控制器
            if (weakSelf.cellDidChangeEdit) {
             
                weakSelf.cellDidChangeEdit(textViewFrame);
            }
            
        };
        
        
        cell.mergeTextBlock = ^(NSInteger tag, NSString *text) {
        
            [weakSelf handleMergeLine:tag leftText:text];
        };
        
        
        return cell;
    }
    else {
        
        PublishImgCell *cell = [tableView dequeueReusableCellWithIdentifier:imgCellIndentifier forIndexPath:indexPath];
        
        if (model.image != nil) {
            
            cell.image = model.image;
        }
        else {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
        }

        cell.deleteBtn.tag = 1000 + indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)handleMergeLine:(NSInteger)index leftText:(NSString*)leftText {
    
    if (index < 1) {
        return;
    }
    
    PublishModel *lastModel = _articleModel.modelList[index -1];
    
    if (lastModel.imgUrl.length > 0) {
        return;
    }
    
    // 收回键盘
    [self reloadData];

    
    PublishModel *currentModel = _articleModel.modelList[index];
    
    NSString *lastContent = lastModel.content ? lastModel.content : @"";
    NSString *currentContent = currentModel.content ? currentModel.content : @"";

    NSString *newContent = [NSString stringWithFormat:@"%@%@", lastContent, currentContent];
    
    currentModel.content = newContent;
    lastModel.content = @"";
    
    // 删除空的模型，刷新数据
   // [self reloadData];

    
    [_articleModel.modelList removeObjectAtIndex:index-1];
    
    [self reloadData];
    
    
    // 获取指定cell的textView， 移动光标
    PublishTextCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(index-1)*2 inSection:0]];
    [cell.textField becomeFirstResponder];
    cell.textField.selectedRange = NSMakeRange(lastContent.length, 0);

}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublishModel *model = _articleModel.modelList[indexPath.row /2];
    
    
    // 文字
    if (indexPath.row%2 == 0) {
    
        NSString *content = PASS_NULL_TO_NIL(model.content);
        
        UITextView *calculateView = [[UITextView alloc] init];
        calculateView.font = Font(15.0);
        calculateView.text = content;
        CGSize size = [calculateView sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
        
        CGFloat height = size.height;
        
        return height > 35 ? height+1 : 35;
    }
    // 图片
    else {

        return model.imgUrl.length > 0 ? 200 : 0.001;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (_scrollBlock) {
        _scrollBlock();
    }
}



@end
