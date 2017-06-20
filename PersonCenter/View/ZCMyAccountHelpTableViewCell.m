//
//  ZCMyAccountHelpTableViewCell.m
//  zuche
//
//  Created by yk on 2017/2/21.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountHelpTableViewCell.h"
#import "ZCMyAccountItemBtn.h"
#import "Masonry.h"
#import "UIColor+ZCCustom.h"
#import "UIFont+ZCCustom.h"
#import "UIColor+HexString.h"
#import "UIImage+ZCIconFont.h"
#import "Define.h"

#define kWidthOfCell (UI_SCREEN_WIDTH)
#define kWidthOfItem (UI_SCREEN_WIDTH / 4)

@interface ZCMyAccountHelpTableViewCell ()

@property (nonatomic, strong) ZCMyAccountItemBtn *courseItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *ruleItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *problemItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *feedbkItemBtn;

@end

@implementation ZCMyAccountHelpTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    titleLbl.text = @"帮助反馈";
    titleLbl.textColor = [UIColor zc_customColorValue1];
    titleLbl.font = [UIFont zc_customFontValueB];
    [self.contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@15);
    }];
    
    UIView *contentViewOfHelp = [[UIView alloc] init];
    [self.contentView addSubview:contentViewOfHelp];
    [contentViewOfHelp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@45);
    }];
    
    _courseItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_courseItemBtn buttonWithImageStr:@"ZCIconHelpCourse" titleStr:@"新手指导"];
    _courseItemBtn.tag = HelpItemType_Course;
    [_courseItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfHelp addSubview:_courseItemBtn];
    [_courseItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 0);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 45));
    }];
    
    _ruleItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_ruleItemBtn buttonWithImageStr:@"ZCIconHelpRule" titleStr:@"服务规则"];
    _ruleItemBtn.tag = HelpItemType_Rule;
    [_ruleItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfHelp addSubview:_ruleItemBtn];
    [_ruleItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 1);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 45));
    }];
    
    _problemItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_problemItemBtn buttonWithImageStr:@"ZCIconHelpProblem" titleStr:@"常见问题"];
    _problemItemBtn.tag = HelpItemType_Problem;
    [_problemItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfHelp addSubview:_problemItemBtn];
    [_problemItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 2);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 45));
    }];
    
    _feedbkItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_feedbkItemBtn buttonWithImageStr:@"ZCIconFeedback" titleStr:@"意见反馈"];
    _feedbkItemBtn.tag = HelpItemType_Feedbk;
    [_feedbkItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentViewOfHelp addSubview:_feedbkItemBtn];
    [_feedbkItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 3);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 45));
    }];
}

- (void)setDataWithFlag:(HelpItemType)flag withData:(NSString *)img withDescription:(NSString *)description
{
    switch (flag) {
        case HelpItemType_Course:{ // 新手指导
            [_courseItemBtn buttonWithImageStr:img titleStr:description];
        }
            break;
        case HelpItemType_Rule:{ // 服务规则
            [_ruleItemBtn buttonWithImageStr:img titleStr:description];
        }
            break;
        case HelpItemType_Problem:{ // 常见问题
            [_problemItemBtn buttonWithImageStr:img titleStr:description];
        }
            break;
        case HelpItemType_Feedbk:{ // 意见反馈
            [_feedbkItemBtn buttonWithImageStr:img titleStr:description];
        }
            break;
        default:
            break;
    }
}

- (void)buttonTap:(ZCMyAccountItemBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoPageWithHelpType:)]) {
        [self.delegate gotoPageWithHelpType:(int)btn.tag];
    }
}

@end
