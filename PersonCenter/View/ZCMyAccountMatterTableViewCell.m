//
//  ZCMyAccountMatterTableViewCell.m
//  zuche
//
//  Created by yk on 2017/2/21.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountMatterTableViewCell.h"
#import "Masonry.h"
#import "UIColor+ZCCustom.h"
#import "UIFont+ZCCustom.h"
#import "UIColor+HexString.h"
#import "UIImage+ZCIconFont.h"

#define kWidthOfCell (UI_SCREEN_WIDTH)
#define kWidthOfItem (UI_SCREEN_WIDTH / 4)

@interface ZCMyAccountMatterTableViewCell ()

@property (nonatomic, strong) ZCMyAccountItemBtn *illegalItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *waitPayItemBtn;

@end

@implementation ZCMyAccountMatterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setupCell
{
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"待办事项";
    titleLbl.textColor = [UIColor zc_customColorValue1];
    titleLbl.font = [UIFont zc_customFontValueB];
    [self.contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@15);
    }];
    
    UIView *contentViewOfMatter = [[UIView alloc] init];
    [self.contentView addSubview:contentViewOfMatter];
    [contentViewOfMatter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@41);
    }];
    
    _illegalItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_illegalItemBtn buttonWithNumberStr:@"0" titleStr:@"违章处理"];
    _illegalItemBtn.tag = MatterItemType_Illegal;
    [_illegalItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfMatter addSubview:_illegalItemBtn];
    [_illegalItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 0);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
    
    _waitPayItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_waitPayItemBtn buttonWithNumberStr:@"0" titleStr:@"待支付项"];
    _waitPayItemBtn.tag = MatterItemType_WaitPay;
    [_waitPayItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfMatter addSubview:_waitPayItemBtn];
    [_waitPayItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 1);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
}

- (void)setDataWithFlag:(MatterItemType)flag withData:(NSString *)score withDescription:(NSString *)description
{
    switch (flag) {
        case MatterItemType_Illegal:{ // 违章处理
            [_illegalItemBtn buttonWithNumberStr:score titleStr:description];
        }
            break;
        case MatterItemType_WaitPay:{ // 待支付项
            [_waitPayItemBtn buttonWithNumberStr:score titleStr:description];
        }
            break;
        default:
            break;
    }
}

- (void)buttonTap:(ZCMyAccountItemBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoPageWithMatterType:)]) {
        [self.delegate gotoPageWithMatterType:(int)btn.tag];
    }
}

@end
