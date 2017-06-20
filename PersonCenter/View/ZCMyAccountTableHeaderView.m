//
//  ZCMyAccountTableHeaderView.m
//  zuche
//
//  Created by yk on 2017/2/20.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountTableHeaderView.h"
#import "UIImageView+WebCache.h"
@interface ZCMyAccountTableHeaderView()

@property (nonatomic, strong) UIImageView *rightArrowImgView;
@property (nonatomic, strong) UIImageView *privilegeImgView;
@property (nonatomic, strong) UILabel *memberLbl;

@end

@implementation ZCMyAccountTableHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildHeaderView];
    }
    return self;
}

- (void)buildHeaderView
{
    _userHeadShot = [[UIImageView alloc] init];
    _userHeadShot.image = [UIImage imageNamed:@"ZCFaceNormal"];
    [self addSubview:_userHeadShot];
    [_userHeadShot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(@40);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.tag = 1000;
    [headBtn addTarget:self action:@selector(gotoWebPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(@40);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    _nameLbl = [[UILabel alloc] init];
    _nameLbl.text = @"会员";
    _nameLbl.textColor = [UIColor whiteColor];
    _nameLbl.font = [UIFont zc_customFontValueB];
    _nameLbl.textAlignment = NSTextAlignmentCenter;
    _nameLbl.userInteractionEnabled = YES;
    [self addSubview:_nameLbl];
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@(-4));
        make.top.mas_equalTo(_userHeadShot.mas_bottom).mas_offset(10);
    }];

    UIImage *rightArrowImg = [UIImage iconWithInfo:ZCIconFontInfoMake(@"\U0000e618", 10, [UIColor whiteColor])];
    _rightArrowImgView = [[UIImageView alloc] initWithImage:rightArrowImg];
    [self addSubview:_rightArrowImgView];
    [_rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLbl.mas_centerY);
        make.left.mas_equalTo(_nameLbl.mas_right).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];

    _privilegeImgView = [[UIImageView alloc] init];
    _privilegeImgView.image = [UIImage imageNamed:@"ZCIconPrivilegeCardDefault"];
    [self addSubview:_privilegeImgView];
    [_privilegeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLbl.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(_userHeadShot.mas_left).mas_offset(-9);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];

    _memberLbl = [[UILabel alloc] init];
    _memberLbl.text = @"普卡会员";
    _memberLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    _memberLbl.font = [UIFont zc_customFontValueD];
    _memberLbl.textAlignment = NSTextAlignmentCenter;
    _memberLbl.userInteractionEnabled = YES;
    [self addSubview:_memberLbl];
    [_memberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_privilegeImgView.mas_centerY);
        make.left.mas_equalTo(_privilegeImgView.mas_right).mas_offset(5);
    }];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.tag = 2000;
    [nameBtn addTarget:self action:@selector(gotoWebPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameBtn];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userHeadShot.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(@0);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(_nameLbl.mas_width).mas_offset(10);
    }];

    UIButton *memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    memberBtn.tag = 3000;
    [memberBtn addTarget:self action:@selector(gotoWebPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:memberBtn];
    [memberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLbl.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(@0);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(_memberLbl.mas_width).mas_offset(20);
    }];
}

- (void)adjustMemberWithLevel:(NSString *)levelStr levelIconImg:(NSString *)levelIconImg
{
    if ([levelIconImg hasPrefix:@"http"]) {
        [_privilegeImgView sd_setImageWithURL:[NSURL URLWithString:levelIconImg]];
    }else{
        _privilegeImgView.image = [UIImage imageNamed:levelIconImg];
    }
    _memberLbl.text = levelStr;
    if (levelStr.length > 4) {
        [_privilegeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userHeadShot.mas_left).mas_offset(-15);
        }];
    }
}

- (void)gotoWebPage:(UIButton *)btn
{
    if (self.webPageBlock) {
        self.webPageBlock(btn.tag);
    }
}

@end
