//
//  ZCMyAccountWalletTableViewCell.m
//  zuche
//
//  Created by yk on 2017/2/20.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountWalletTableViewCell.h"
#import "ZCMyAccountItemBtn.h"
#import "Masonry.h"
#import "UIColor+ZCCustom.h"
#import "UIFont+ZCCustom.h"
#import "UIColor+HexString.h"
#import "UIImage+ZCIconFont.h"
#import "Define.h"

#define kWidthOfCell (UI_SCREEN_WIDTH)
#define kWidthOfItem (UI_SCREEN_WIDTH / 4)
#define kNumberOfItems 5

@interface ZCMyAccountWalletTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *balanceItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *couponItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *pointItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *creditItemBtn;
@property (nonatomic, strong) ZCMyAccountItemBtn *topupItemBtn;
@property (nonatomic, strong) UIView *couponRedImageItem;

@end

@implementation ZCMyAccountWalletTableViewCell

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
    titleLbl.text = @"我的钱包";
    titleLbl.textColor = [UIColor zc_customColorValue1];
    titleLbl.font = [UIFont zc_customFontValueB];
    [self.contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@15);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@41);
    }];
    
    UIView *scrollContentView = [[UIView alloc] init];
    scrollContentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfCell + kWidthOfItem, 41));
    }];
    _creditItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_creditItemBtn buttonWithMoneyStr:@"0" unitStr:@"张" titleStr:@"银行卡"];
    _creditItemBtn.tag = MyWalletItemType_Credit;
    [_creditItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_creditItemBtn];
    [_creditItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 0);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];

    _balanceItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_balanceItemBtn buttonWithMoneyStr:@"0" unitStr:@"元" titleStr:@"账户余额"];
    _balanceItemBtn.tag = MyWalletItemType_Balance;
    [_balanceItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_balanceItemBtn];
    [_balanceItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 1);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
    _couponItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_couponItemBtn buttonWithMoneyStr:@"0" unitStr:@"张" titleStr:@"优惠券"];
    _couponItemBtn.tag = MyWalletItemType_Coupon;
    [_couponItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_couponItemBtn];
    [_couponItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 2);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
        
    _pointItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_pointItemBtn buttonWithMoneyStr:@"0" unitStr:@"分" titleStr:@"可用积分"];
    _pointItemBtn.tag = MyWalletItemType_Point;
    [_pointItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_pointItemBtn];
    [_pointItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 3);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
    
    _topupItemBtn = [[ZCMyAccountItemBtn alloc] init];
    [_topupItemBtn buttonWithMoneyStr:@"0" unitStr:@"元" titleStr:@"储值卡"];
    _topupItemBtn.tag = MyWalletItemType_Card;
    [_topupItemBtn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_topupItemBtn];
    [_topupItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthOfItem * 4);
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWidthOfItem, 41));
    }];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kWidthOfCell - 15, 53, 15, 35);
    [_rightBtn setImage:[UIImage imageNamed:@"ZCMoreArrow"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(myWalletMoveRight) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightBtn];
}

- (void)myWalletMoveRight
{
    [_scrollView setContentOffset:CGPointMake(kWidthOfItem, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x >= kWidthOfItem && _rightBtn.frame.origin.x == kWidthOfCell - 15) {
        [UIView animateWithDuration:0.3 animations:^{
            _rightBtn.frame = CGRectMake(kWidthOfCell, 53, 15, 35);
        }];
    } else if (_rightBtn.frame.origin.x == kWidthOfCell) {
        [UIView animateWithDuration:0.3 animations:^{
            _rightBtn.frame = CGRectMake(kWidthOfCell - 15, 53, 15, 35);
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        if (_scrollView.contentOffset.x <= kWidthOfItem * 0.5) {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else {
            [_scrollView setContentOffset:CGPointMake(kWidthOfItem, 0) animated:YES];
        }
    }
}

- (void)setDataWithFlag:(MyWalletItemType)flag withData:(NSString *)score withUnite:(NSString *)unite withDescription:(NSString *)description
{
    switch (flag) {
        case MyWalletItemType_Balance:{ // 账户余额
            [_balanceItemBtn buttonWithMoneyStr:score unitStr:unite titleStr:description];
        }
            break;
        case MyWalletItemType_Coupon:{ // 优惠券
            [_couponItemBtn buttonWithMoneyStr:score unitStr:unite titleStr:description];
        }
            break;
        case MyWalletItemType_Point:{ // 积分
            [_pointItemBtn buttonWithMoneyStr:score unitStr:unite titleStr:description];
        }
            break;
        case MyWalletItemType_Credit:{ // 信用卡
            [_creditItemBtn buttonWithMoneyStr:score unitStr:unite titleStr:description];
        }
            break;
        case MyWalletItemType_Card:{ // 储值卡
            [_topupItemBtn buttonWithMoneyStr:score unitStr:unite titleStr:description];
        }
            break;
        default:
            break;
    }
}

- (void)buttonTap:(ZCMyAccountItemBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(gotoPageWithWalletType:)]) {
        [self.delegate gotoPageWithWalletType:(int)btn.tag];
    }
}

@end
