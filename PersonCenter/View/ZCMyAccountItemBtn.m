//
//  ZCMyAccountItemBtn.m
//  zuche
//
//  Created by yk on 2017/2/22.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountItemBtn.h"
#import "NIAttributedLabel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIFont+ZCCustom.h"
#import "UIColor+ZCCustom.h"
#import "Define.h"

@interface ZCMyAccountItemBtn ()

@property (nonatomic, strong) NIAttributedLabel *moneyLbl;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZCMyAccountItemBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupItem];
    }
    return self;
}

- (void)setupItem
{
    UIView *verticalLine = [[UIView alloc] init];
    [verticalLine setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(self.mas_left).mas_offset(-mSINGLE_LINE_ADJUST_OFFSET);
        make.width.mas_equalTo(mSINGLE_LINE_WIDTH);
    }];
    
    _moneyLbl = [[NIAttributedLabel alloc] init];
    [_moneyLbl setBackgroundColor:[UIColor clearColor]];
    _moneyLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLbl];
    [_moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
    }];
    _moneyLbl.hidden = NO;
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    _imgView.hidden = YES;
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.textColor = [UIColor zc_customColorValue2];
    _titleLbl.font = [UIFont zc_customFontValueF];
    [self addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
}

- (void)buttonWithMoneyStr:(NSString *)moneyStr unitStr:(NSString *)unitStr titleStr:(NSString *)titleStr
{
    _moneyLbl.text = [NSString stringWithFormat:@"%@ %@", moneyStr, unitStr];
    if ([moneyStr isEqualToString:@"0"]) {
        [_moneyLbl setTextColor:[UIColor zc_customColorValue2]];
    } else {
        [_moneyLbl setTextColor:[UIColor zc_customColorStandard] range:NSMakeRange(0, moneyStr.length)];
        [_moneyLbl setTextColor:[UIColor zc_customColorValue2] range:NSMakeRange(moneyStr.length, 2)];
    }
    [_moneyLbl setFont:[UIFont zc_customFontValueK] range:NSMakeRange(0, moneyStr.length)];//20
    if (UI_SCREEN_WIDTH > 320) {
        [_moneyLbl setFont:[UIFont zc_customFontValueJ] range:NSMakeRange(0, moneyStr.length)];
    }
    [_moneyLbl setFont:[UIFont systemFontOfSize:10] range:NSMakeRange(moneyStr.length, 2)];
    
    [_moneyLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
    }];
    _titleLbl.text = titleStr;
}

- (void)buttonWithStatusStr:(NSString *)statusStr titleStr:(NSString *)titleStr
{
    _moneyLbl.text = statusStr;
    [_moneyLbl setTextColor:[UIColor zc_customColorStandard]];
    [_moneyLbl setFont:[UIFont zc_customFontValueG]];
    [_moneyLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@5);
    }];
    _titleLbl.text = titleStr;
}

- (void)buttonWithNumberStr:(NSString *)numberStr titleStr:(NSString *)titleStr
{
    _moneyLbl.text = numberStr;
    if ([numberStr isEqualToString:@"0"]) {
        [_moneyLbl setTextColor:[UIColor zc_customColorValue2]];
    } else {
        [_moneyLbl setTextColor:[UIColor zc_customColorStandard]];
    }
    [_moneyLbl setFont:[UIFont zc_customFontValueJ]];
    
    _titleLbl.text = titleStr;
}

- (void)buttonWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr
{
    _moneyLbl.hidden = YES;
    _imgView.hidden = NO;
    if ([imageStr hasPrefix:@"http"]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }else{
        _imgView.image = [UIImage imageNamed:imageStr];
    }
    _titleLbl.text = titleStr;
}

@end
