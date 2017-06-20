//
//  ZCMyAccountPrivilegeTableViewCell.m
//  zuche
//
//  Created by yk on 2017/3/7.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountPrivilegeTableViewCell.h"
#import "ZCMyAccountItemBtn.h"
#define kWidthOfCell (UI_SCREEN_WIDTH)
#define kWidthOfItem (UI_SCREEN_WIDTH / 4)

@interface ZCMyAccountPrivilegeTableViewCell ()

@property (nonatomic, strong) ZCMyAccountItemBtn *privilegeItemBtn;

@end

@implementation ZCMyAccountPrivilegeTableViewCell

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
    titleLbl.text = @"我的特权";
    titleLbl.textColor = [UIColor zc_customColorValue1];
    titleLbl.font = [UIFont zc_customFontValueB];
    [self.contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@15);
    }];
    
    UIView *contentViewOfPrivilege = [[UIView alloc] init];
    [self.contentView addSubview:contentViewOfPrivilege];
    [contentViewOfPrivilege mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@45);
    }];
    
    _privilegeItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_privilegeItemBtn buttonWithImageStr:@"ZCIconPrivilegeCardDefault" titleStr:@"会员"];
    _privilegeItemBtn.tag = PrivilegeType_Member;
    [_privilegeItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfPrivilege addSubview:_privilegeItemBtn];
    [_privilegeItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 0);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 45));
    }];
}

- (void)setDataWithFlag:(PrivilegeItemType)flag withData:(NSString *)img withDescription:(NSString *)description
{
    switch (flag) {
        case PrivilegeType_Member:{ // 会员
            [_privilegeItemBtn buttonWithImageStr:img titleStr:description];
        }
            break;
        default:
            break;
    }
}

- (void)buttonTap:(ZCMyAccountItemBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoPageWithPrivilegeType:)]) {
        [self.delegate gotoPageWithPrivilegeType:(int)btn.tag];
    }
}

@end
