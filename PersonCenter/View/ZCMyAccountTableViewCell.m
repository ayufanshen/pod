//
//  ZCMyAccountTableViewCell.m
//  zuche
//
//  Created by yk on 2017/2/21.
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountTableViewCell.h"
#import "Masonry.h"
#import "UIColor+ZCCustom.h"
#import "UIFont+ZCCustom.h"
#import "UIColor+HexString.h"
#import "UIImage+ZCIconFont.h"

@implementation ZCMyAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }
    
    return self;
}


- (void)setupCell
{
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.textColor = [UIColor zc_customColorValue1];
    _titleLbl.font = [UIFont zc_customFontValueB];
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.centerY.mas_equalTo(@0);
    }];
    
    UIImage *rightArrowImg = [UIImage iconWithInfo:ZCIconFontInfoMake(@"\U0000e618", 15, [UIColor zc_customColorValue3])];
    UIImageView *rightArrowImgView = [[UIImageView alloc] init];
    rightArrowImgView.image = rightArrowImg;
    [self.contentView addSubview:rightArrowImgView];
    [rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-15));
        make.centerY.mas_equalTo(@0);
    }];
    
    _detailLbl = [[UILabel alloc] init];
    _detailLbl.textColor = [UIColor zc_customColorValue2];
    _detailLbl.font = [UIFont zc_customFontValue2];
    [self.contentView addSubview:_detailLbl];
    [_detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightArrowImgView.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(@0);
    }];
}

@end
