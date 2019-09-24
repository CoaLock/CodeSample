//
//  DetailPopView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DetailPopView.h"
#import "DetailPopCell.h"


static NSString *identifer = @"identifer";


@interface DetailPopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *images;


@property (nonatomic, copy) PopoverCellBlock cellBlock;

@end


@implementation DetailPopView


- (instancetype)initWithTitles:(NSArray*)titles images:(NSArray*)images cellBlock:(PopoverCellBlock)cellBlock {

    _titles = titles.mutableCopy;
    _images = images.mutableCopy;
    
    CGRect frame = CGRectMake(0, 0, 120, titles.count*44);
    if (self = [super initWithFrame:frame]) {
        
        _cellBlock= [cellBlock copy];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"DetailPopCell" bundle:nil] forCellReuseIdentifier:identifer];
    }
    return self;
}

#pragma mark - Public
- (void)replaceTitle:(NSString*)title images:(NSString*)image index:(NSInteger)index {

    STRING_NIL_NULL(title);
    [_titles replaceObjectAtIndex:index withObject:title];
    [_images replaceObjectAtIndex:index withObject:image];

    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    cell.titleL.text = _titles[indexPath.row];
    
    // 收藏按钮主题色特殊处理
    if ([_images[indexPath.row] isEqualToString:@"ic_wzxqscs"]) {
        
        cell.imgView.image = [[UIImage imageNamed:_images[indexPath.row]] imageWithColor:kAppCustomMainColor];

    }
    else {
        cell.imgView.image = [UIImage imageNamed:_images[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _cellBlock(indexPath.row);
}



@end
