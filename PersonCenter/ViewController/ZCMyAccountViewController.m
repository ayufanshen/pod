//
//  ZCMyAccountViewController.m
//  zuche
//
//  Copyright © 2017年 zuche. All rights reserved.
//

#import "ZCMyAccountViewController.h"
#import "ZCApplePushDestinationProtocol.h"
#import "UINavigationBar+Awesome.h"
#import "UINavigationController+PresntStyleUtils.h"
#import "ZCARWebViewController.h"
#import "NSDictionary+ZCUtlity.h"
#import "NSObject+ZCUtility.h"
#import "ZCGuideMaskView.h"
#import "ZCRealNameCertifyView.h"
#import "ZCIllegalMessageView.h"
#import "ZCMyAccountTableHeaderView.h"
#import "ZCMyAccountWalletTableViewCell.h"
#import "ZCMyAccountPrivilegeTableViewCell.h"
#import "ZCMyAccountMatterTableViewCell.h"
#import "ZCMyAccountHelpTableViewCell.h"
#import "ZCMyAccountTableViewCell.h"
#import "ZCUserInfo.h"
#import "AppDelegate.h"
#import "ZCNotificationDefineHeader.h"
#import "ZCMyAccountViewModel.h"

#import "Define.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIImage+ZCIconFont.h"
#import "ZCTrackEvent.h"
#import "ZCRouterManager.h"
#import "UIColor+ZCCustom.h"
#import "ZCNetworkManger.h"

#define kMyWalletTableViewCell      @"myWalletTableViewCell"
#define kPrivilegeTableViewCell     @"privilegeTableViewCell"
#define kMatterToDoTableViewCell    @"matterToDoTableViewCell"
#define kHelpFeedBkTableViewCell    @"helpFeedBkTableViewCell"

#define kHEIGHT 160

@interface ZCMyAccountViewController ()<ZCApplePushDestinationProtocol, UITableViewDataSource, UITableViewDelegate, ZCWalletTableViewCellDelegate, ZCPrivilegeTableViewCellDelegate, ZCMatterTableViewCellDelegate, ZCHelpTableViewCellDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
{
    ZCIllegalMessageView *_illegalView;
}

@property (assign, nonatomic) BOOL                       isFromWap;    // 标记页面是否是从wap页面过来
@property (strong, nonatomic) ZCRealNameCertifyView      *certifyView; // 新用户引导用户实名的问题
@property (strong, nonatomic) UIButton                   *preferentialBtn;
@property (strong, nonatomic) UITableView                *mainTableView;
@property (strong, nonatomic) ZCMyAccountTableHeaderView *myAccountHV;
@property (assign, nonatomic) BOOL                        flag;
@property (strong, nonatomic) ZCMyAccountViewModel       *myAccountViewModel;
@end

@implementation ZCMyAccountViewController

+ (instancetype)instantiateWithDestinationInfo:(NSDictionary *)dic
{
    static ZCMyAccountViewController *_sharedController = nil;
    _sharedController = [[ZCMyAccountViewController alloc] init];
    _sharedController.isFromWap = YES;
    return _sharedController;
}

#pragma mark -view-

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myAccountViewModel = [ZCMyAccountViewModel new];
    
    self.navigationItem.title = @"个人中心";
    self.tabBarItem.title = @"我的";
    
    //是个右上角优惠按钮的UI的bug，延迟一下，使他显示后再能滑动tableview
    _flag = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _flag = YES;
    });
    
    [self preferentialActivityButton];
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    CGFloat offsetY = _mainTableView.contentOffset.y;
    if (offsetY > -kHEIGHT) {
        [self showNavigationBar];
    } else {
        [self hiddenNavigationBar];
    }
    if (self.isFromWap) {
        if (self.myAccountViewModel.isNewUser) {
            // 3.8.0 添加对从wap页过来的新注册用户的引导指示
            [self showAlertNewUserTipsView];
        }
    }
    

    //退出登录时清空数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearUserIndfo)
                                                 name:NOTIFICATION_KEY_LOGOUT
                                               object:nil];
    [self getProofCount];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reqMyChinaData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
}

-(void)showNavigationBar{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *marketImg = [UIImage iconWithInfo:ZCIconFontInfoMake(@"\U0000e61d", 28, [UIColor blackColor])];
    [_preferentialBtn setImage:marketImg forState:UIControlStateNormal];
    [_preferentialBtn setImage:marketImg forState:UIControlStateHighlighted];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
}

-(void)hiddenNavigationBar{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
}


- (void)preferentialActivityButton
{
    _preferentialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _preferentialBtn.frame = CGRectMake(0, 0, 28, 28);
    UIImage *marketImg = [UIImage iconWithInfo:ZCIconFontInfoMake(@"\U0000e61d", 28, [UIColor whiteColor])];
    [_preferentialBtn setImage:marketImg forState:UIControlStateNormal];
    [_preferentialBtn setImage:marketImg forState:UIControlStateHighlighted];
    [_preferentialBtn addTarget:self action:@selector(showMarketWeb) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_preferentialBtn];
    _preferentialBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)setupTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50)
                                                  style:UITableViewStyleGrouped];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.backgroundColor  = [UIColor colorWithHexString:@"f6f6f6"];
    _mainTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _mainTableView.separatorColor   = [UIColor colorWithRed:208 / 255.0f green:208 / 255.f blue:208 / 255.f alpha:1.0f];
    _mainTableView.contentInset     = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
    _mainTableView.dataSource       = self;
    _mainTableView.delegate         = self;
    [self.view addSubview:_mainTableView];
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"ZCImgFaceBg"];
    backImageView.userInteractionEnabled = YES;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.tag = 1001;
    [_mainTableView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kHEIGHT);
        make.width.mas_equalTo(UI_SCREEN_WIDTH);
        make.height.mas_equalTo(kHEIGHT);
    }];
    
    UIButton *preferentialBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *marketImg = [UIImage iconWithInfo:ZCIconFontInfoMake(@"\U0000e61d", 28, [UIColor whiteColor])];
    [preferentialBtn2 setImage:marketImg forState:UIControlStateNormal];
    [preferentialBtn2 setImage:marketImg forState:UIControlStateHighlighted];
    [preferentialBtn2 addTarget:self
                         action:@selector(showMarketWeb)
               forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:preferentialBtn2];
    [preferentialBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImageView.mas_top).offset(30);
        make.right.mas_equalTo(backImageView.mas_right).offset(-6);
        make.height.mas_equalTo(@28);
        make.width.mas_equalTo(@28);
    }];
    
    _myAccountHV = [[ZCMyAccountTableHeaderView alloc] init];
    __weak typeof(self) weakSelf = self;
    _myAccountHV.webPageBlock = ^(NSInteger type){
        if (type == 1000 || type == 2000) {
            [weakSelf gotoMyCenterPage];
        } else {
            [ZCTrackEvent trackEvent:@"WD_huangguan"];
            [weakSelf ToMemberLevelWeb];
        }
    };
    [_mainTableView addSubview:_myAccountHV];
    [_myAccountHV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kHEIGHT);
        make.width.mas_equalTo(UI_SCREEN_WIDTH-80);
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(kHEIGHT);
    }];
}


- (void)clearUserIndfo{
    if (![NSObject isEmptyObj:self.myAccountViewModel.resultDict]) {
        self.myAccountViewModel.resultDict = [NSDictionary dictionary];
        [self.myAccountViewModel clearMyAccount];
        [self setIllegalCount:@"0"];
        [self refreshData];
    }
}

- (void)showAlertNewUserTipsView
{
    [ZCTrackEvent trackEvent:@"ZC_shimingtj"];
    self.certifyView = [[ZCRealNameCertifyView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.certifyView show];
    __weak ZCMyAccountViewController *weakself = self;
    self.certifyView.callBackBlock = ^(){
        [weakself.navigationController performAfterCompletePersonalInfo:^(BOOL hadCompleted, BOOL onlyJust,eCompleteInfoFinishType callBackType) {
            if (hadCompleted) {
                if (callBackType == eCompleteInfoFinishType_UserInfo) {
                    // 跳转到个人中心界面
                    UIViewController *vc = [[HHRouter shared] matchController:kZCPersonalInfoViewController];
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
            }
        } withCompleteInfoType:eCompleteInfoType_Wap];
    };
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.certifyView];
}

- (void)reqMyChinaData
{
    [ZCProgressHUD showEnableOnView:self.view];
    NSDictionary *paramsDict = @{@"encrypt":@(YES)};
    [[ZCNetworkManger sharedManager] GETWithFuncID:E_USER_INFO_ACTION
                                          delegate:self
                                        parameters:paramsDict];
}

- (void)getProofCount
{
    NSDictionary *param = @{@"type" : @2};
    [[ZCNetworkManger sharedManager] POSTWithAction:E_getProof_CountAction
                                         parameters:param
                                            success:^(NSDictionary *result) {
                                                DDLogVerbose(@"%@",result);
                                                NSDictionary *reDic   = [result objectForKey:API_Field_Result];
                                                
                                                [self.myAccountViewModel initPeccancyModel:reDic];

                                                // 违章待处理条数
                                                int proofCount = self.myAccountViewModel.peccancyModel.proofCount;
                                                NSString *proofCountStr = [NSString stringWithFormat:@"%d", proofCount];
                                                
                                                [self setIllegalCount:proofCountStr];
                                                
                                                [self refrashllegalData];
                                                [_mainTableView reloadData];
                                                
                                            }failure:nil];
    
}

- (void)didSuccess:(ZCNetworkManger *)api userInfo:(NSDictionary *)info
{
    [ZCProgressHUD dismiss];
    int funid = [info intForKey:API_PARAM_FUNCTIONID];
    switch (funid) {
        case E_USER_INFO_ACTION: {
            
            self.myAccountViewModel.resultDict = [info dictionaryForKey:API_Field_Result];
            
            [self.myAccountViewModel initMyAccountResult:[info dictionaryForKey:API_Field_Result]];
            
            [self.myAccountViewModel initUserInfo];
            [self refreshData];
            [_mainTableView reloadData];
        }
            break;
        case E_USER_GIFTCARDLIST: {
            NSArray *cardList = [info arrayForKey:API_Field_Result];
            if ([cardList count] > 0) {
            
                UIViewController *vc = [[HHRouter shared] matchController:kZCDepositViewController];
                vc.params =@{@"cardList":cardList};
                [self.navigationController pushViewController:vc animated:YES];

            } else {
                [ZCProgressHUD showMsg:@"您没有可使用的储值卡" onView:self.view];
            }
        }
            break;
        case E_USER_CREDITLISTS: {
            [self goToCreditCardListVC];
        }
            break;
        default:
            break;
    }
}

#pragma mark - other functions
/**
 *  获取到网络数据后刷新的方法
 */
- (void)refreshData{
    _myAccountHV.userHeadShot.image = [UIImage imageNamed:@"ZCFaceDefault"];
    
    NSString * memberLevelStr = self.myAccountViewModel.memberLevelStr;
    NSString * userImageName  = self.myAccountViewModel.userImageName;
    
    // 会员状态
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:2];
    
    
    ZCMyAccountPrivilegeTableViewCell *privilegeCell = (ZCMyAccountPrivilegeTableViewCell *)[_mainTableView cellForRowAtIndexPath:indexPath1];
    ZCMyAccountWalletTableViewCell *cell = (ZCMyAccountWalletTableViewCell *)[_mainTableView cellForRowAtIndexPath:indexPath0];
    ZCMyAccountMatterTableViewCell *matterCell = (ZCMyAccountMatterTableViewCell *)[_mainTableView cellForRowAtIndexPath:indexPath2];
    
    [_myAccountHV adjustMemberWithLevel:memberLevelStr levelIconImg:userImageName];
    
    _myAccountHV.nameLbl.text = self.myAccountViewModel.name;
    
    [privilegeCell setDataWithFlag:PrivilegeType_Member
                          withData:userImageName
                   withDescription:memberLevelStr];
    
    [cell setDataWithFlag:MyWalletItemType_Balance
                 withData:self.myAccountViewModel.balanceAmount
                withUnite:@"元"
          withDescription:@"账户余额"];
    
    [cell setDataWithFlag:MyWalletItemType_Coupon
                 withData:self.myAccountViewModel.myAccount.couponCount.stringValue?:@"0"
                withUnite:@"张"
          withDescription:@"优惠券"];
    
    [cell setDataWithFlag:MyWalletItemType_Point
                 withData:self.myAccountViewModel.myAccount.availIntegral.stringValue?:@"0"
                withUnite:@"分"
          withDescription:@"可用积分"];
    
    [cell setDataWithFlag:MyWalletItemType_Card
                 withData:self.myAccountViewModel.myAccount.giftcardAmount.stringValue?:@"0"
                withUnite:@"元"
          withDescription:@"储值卡"];
    
    // 信用卡状态
    [cell setDataWithFlag:MyWalletItemType_Credit
                 withData:self.myAccountViewModel.cardCount?:@"0"
                withUnite:@"张"
          withDescription:@"银行卡"];
    
    // 违章追款待付款条数
    [matterCell setDataWithFlag:MatterItemType_WaitPay
                       withData:self.myAccountViewModel.myAccount.violationUnCount.stringValue?:@"0"
                withDescription:@"待支付项"];

}

//刷新的违章处理数据
-(void)refrashllegalData{
    
    NSString * description = self.myAccountViewModel.peccancyModel.proofDesc;
    
    if (description && description.length > 1) {
        _illegalView = [[ZCIllegalMessageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 34)];
        [_illegalView addTarget:self action:@selector(enterIllegalEvidence)];
        _illegalView.titleLbl.text = description;
        [_mainTableView addSubview:_illegalView];
    } else {
        [_illegalView removeFromSuperview];
    }
    
}

- (void)setIllegalCount:(NSString *)illegalCount{
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:2];
    ZCMyAccountMatterTableViewCell *matterCell = (ZCMyAccountMatterTableViewCell *)[_mainTableView cellForRowAtIndexPath:indexPath2];
    [matterCell setDataWithFlag:MatterItemType_Illegal withData:illegalCount withDescription:@"违章处理"];
}

// 优惠活动
- (void)showMarketWeb
{
    [ZCTrackEvent trackEvent:@"WD_huodong"];
    NSString *activityURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"activityURL"]?:@"about:blank";
    
    UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
    vc.params = @{@"title":@"优惠活动",
                  @"requestURL":activityURL,
                  @"comeFromWhere":@(Come_From_Other)
                  };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    if (_flag == YES) {
        if (point.y < -kHEIGHT) {
            CGFloat offsetY = point.y;
            [[_mainTableView viewWithTag:1001] mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(offsetY);
                make.height.mas_equalTo(-offsetY);
            }];
        }
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -kHEIGHT) {
        [self showNavigationBar];
    } else {
        [self hiddenNavigationBar];
    }
}


/**
 *  跳转到个人资料的详情页面
 */
- (void)gotoMyCenterPage
{
    [ZCTrackEvent trackEvent:@"WD_geren"];
    
    NSMutableDictionary *personDict = [NSMutableDictionary dictionaryWithDictionary:self.myAccountViewModel.resultDict];
    NSString *userDetailUrl = self.myAccountViewModel.myAccount.userDetailUrl;
    
    UIViewController *vc = [[HHRouter shared] matchController:kZCPersonalInfoViewController];
    vc.params =@{@"personDict":personDict,@"userDetailUrl":userDetailUrl};
    [self.navigationController pushViewController:vc animated:YES];
    

//    personalInfo.personDict = [NSMutableDictionary dictionaryWithDictionary:self.myAccountViewModel.resultDict];
////    personalInfo.phone = self.myAccountViewModel.myAccount.nativePhone;
//    personalInfo.userDetailUrl = self.myAccountViewModel.myAccount.userDetailUrl;

}

// 会员详情
-(void)ToMemberLevelWeb
{
    NSString *title = @"";
    if (self.myAccountViewModel.myAccount.level == LevelPudong) {
        title = @"御驾黑卡尊享权益";
    }else{
        title = @"会员等级";
    }
    
    UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
    vc.params = @{@"title":title,
                  @"requestURL":self.myAccountViewModel.memberLevelURLStr,
                  @"comeFromWhere":@(Come_From_Other)
                  };
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.myAccountViewModel.peccancyModel.proofDesc.length > 1) {
            return 34.0f;
        } else {
            return 0.1f;
        }
    } else {
        return 10.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 10);
    [headerView setBackgroundColor:[UIColor clearColor]];
    UIView *bootomLineView = [[UIView alloc]init];
    bootomLineView.backgroundColor = [UIColor zc_customColorValue5];
    [headerView addSubview:bootomLineView];
    [bootomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(mSINGLE_LINE_WIDTH);
    }];
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = [UIColor zc_customColorValue5];
    [headerView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(mSINGLE_LINE_WIDTH);
    }];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 111.0f;
    } else if (indexPath.section == 1 || indexPath.section == 3) {
        return 115.0f;
    } else {
        return 50.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIndentifier = @"personCenterTableViewCell";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMyWalletTableViewCell];
        if (cell == nil) {
            cell = [[ZCMyAccountWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyWalletTableViewCell];
            ZCMyAccountWalletTableViewCell *myWalletCell = (ZCMyAccountWalletTableViewCell *)cell;
            myWalletCell.delegate = self;
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPrivilegeTableViewCell];
        if (cell == nil) {
            cell = [[ZCMyAccountPrivilegeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPrivilegeTableViewCell];
            ZCMyAccountPrivilegeTableViewCell *privilCell = (ZCMyAccountPrivilegeTableViewCell *)cell;
            privilCell.delegate = self;
        }
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMatterToDoTableViewCell];
        if (cell == nil) {
            cell = [[ZCMyAccountMatterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMatterToDoTableViewCell];
            ZCMyAccountMatterTableViewCell *matterCell = (ZCMyAccountMatterTableViewCell *)cell;
            matterCell.delegate = self;
        }
    } else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:kHelpFeedBkTableViewCell];
        if (cell == nil) {
            cell = [[ZCMyAccountHelpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHelpFeedBkTableViewCell];
            ZCMyAccountHelpTableViewCell *helCell = (ZCMyAccountHelpTableViewCell *)cell;
            helCell.delegate = self;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier];
        if (cell == nil) {
            cell = [[ZCMyAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            cell.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = nil;
        }
        
        ZCMyAccountTableViewCell *accountCell = (ZCMyAccountTableViewCell *)cell;
        
        NSArray *titleArray = self.myAccountViewModel.cellTitleArray[indexPath.section - 1];
        
        [self.myAccountViewModel setCellTextLabel:accountCell.titleLbl
                                       withString:[titleArray objectAtIndex:indexPath.row]];
        
        NSArray *sectionSubTitlArray = self.myAccountViewModel.cellSubTitleArray[indexPath.section-1];
        accountCell.detailLbl.text = sectionSubTitlArray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        
        [ZCTrackEvent trackEvent:@"WD_fapiao"];
        // 发票管理入口
        UIViewController *vc = [[HHRouter shared] matchController:kZCInvoiceViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 5) {
        [ZCTrackEvent trackEvent:@"WD_guanyu"];
        
        // 关于神州入口
        UIViewController *vc = [[HHRouter shared] matchController:kZCAboutHelpViewController];
        vc.params = @{@"helpVC.aboutUsLinkURL":self.myAccountViewModel.myAccount.helps.aboutusUrl};
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 6) {
        [ZCTrackEvent trackEvent:@"WD_kefu"];
        // 拨打客服电话
        NSString *otherTitle = [NSString stringWithFormat:@"拨打电话 %@", [AppDelegate sharedDelegate].hotCallString];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"神州租车客服竭诚为您服务"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:otherTitle, nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[AppDelegate sharedDelegate].hotCallString]]];
    }
}

#pragma mark - cellDelegate
- (void)gotoPageWithWalletType:(MyWalletItemType)type
{
    switch (type) {
        case MyWalletItemType_Point: {
            [ZCTrackEvent trackEvent:@"WD_jifen"];
            //积分详情
            UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
            vc.params = @{@"title":@"可用积分",
                          @"requestURL":self.myAccountViewModel.scoreUrlStr,
                          @"comeFromWhere":@(Come_From_Other)
                          };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case MyWalletItemType_Coupon:{
            [ZCTrackEvent trackEvent:@"WD_youhuiquan"];
            
            UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
            vc.params = @{@"title":@"优惠券",
                          @"requestURL":self.myAccountViewModel.couponUrlStr,
                          @"comeFromWhere":@(Come_From_Other)
                          };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case MyWalletItemType_Card:{
            
            [ZCTrackEvent trackEvent:@"WD_chuzhida"];
            
            // 跳转到储值卡详情页面
            [[ZCNetworkManger sharedManager] GETWithFuncID:E_USER_GIFTCARDLIST
                                                  delegate:self
                                                parameters:nil];
            [ZCProgressHUD showClear];
        }
            break;
        case MyWalletItemType_Credit:{
            [ZCTrackEvent trackEvent:@"WD_yihangka"];
            [self goToCreditCardListVC];
        }
            break;
        case MyWalletItemType_Balance:{
            [ZCTrackEvent trackEvent:@"WD_yue"];
            
            if ([self.myAccountViewModel.balanceAmount doubleValue] == 0) {
                [ZCProgressHUD showMsg:@"您没有账户余额" onView:self.view];
                return;
            }
            
        
            UIViewController *vc = [[HHRouter shared] matchController:kZCAccountBalanceViewController];
            vc.params =@{@"phoneNumber":self.myAccountViewModel.myAccount.nativePhone};
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break; 
            
        default:
            break;
    }
}

- (void)verifyCreditCard
{
    // 读取用户单例中是否需要完善个人信息
    [self.navigationController performAfterCompletePersonalInfo:^(BOOL hadCompleted, BOOL onlyJust,eCompleteInfoFinishType callBackType) {
        if (hadCompleted) { // 验证信用卡的cell
            [[ZCNetworkManger sharedManager] GETWithFuncID:E_USER_CREDITLISTS
                                                  delegate:self
                                                parameters:nil];
        }
    } withCompleteInfoType:eCompleteInfoType_CreditCard];
}

//跳转到银行卡管理界面
- (void)goToCreditCardListVC
{
    [self.navigationController performAfterCompletePersonalInfo:^(BOOL hadCompleted, BOOL onlyJust, eCompleteInfoFinishType finishType) {
        if (hadCompleted) {
            
            UIViewController *vc = [[HHRouter shared] matchController:kZCMyBankCardListViewController];
            [self.navigationController pushViewController:vc animated:YES];

        }
    } withCompleteInfoType:eCompleteInfoType_PersonalCenter];
}

- (void)gotoPageWithMatterType:(MatterItemType)type
{
    switch (type) {
        case MatterItemType_Illegal:{
            [ZCTrackEvent trackEvent:@"WD_weizhang"];
            
            [self enterIllegalEvidence];
        }
            break;
        case MatterItemType_WaitPay:{
            [ZCTrackEvent trackEvent:@"WD_daizhifu"];
            // 违章追款入口
            /**
             *  存 ：最新追款订单时间戳
             */
            [self.myAccountViewModel updateLatestPeccancyDate];
            
            UIViewController *vc = [[HHRouter shared] matchController:kZCIllegalChaseListViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)gotoPageWithHelpType:(HelpItemType)type
{    
    switch (type) {
        case HelpItemType_Course:{
            [ZCTrackEvent trackEvent:@"WD_yindao"];
            
            UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
            vc.params = @{@"title":@"新手指导",
                            @"requestURL":self.myAccountViewModel.myAccount.helps.newhandUrl};
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case HelpItemType_Rule:{
            [ZCTrackEvent trackEvent:@"WD_guize"];

            UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
            vc.params = @{@"title":@"服务规则",
                          @"requestURL":self.myAccountViewModel.myAccount.helps.serviceruleUrl};
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case HelpItemType_Problem:{
            [ZCTrackEvent trackEvent:@"WD_wenti"];
            
            UIViewController *vc = [[HHRouter shared] matchController:kZCARWebViewController];
            vc.params = @{@"title":@"常见问题",
                          @"requestURL":self.myAccountViewModel.myAccount.helps.questionUrl};
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case HelpItemType_Feedbk:{
            [ZCTrackEvent trackEvent:@"WD_fankui"];

            UIViewController *vc = [[HHRouter shared] matchController:kZCHomeFeedBackViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)gotoPageWithPrivilegeType:(PrivilegeItemType)type
{
    switch (type) {
        case PrivilegeType_Member:{
            [ZCTrackEvent trackEvent:@"WD_jinka"];
            [self ToMemberLevelWeb];
        }
            break;
        default:
            break;
    }
}

- (void)enterIllegalEvidence
{
    [self.myAccountViewModel setLatestPeccancyDate];
    //违章服务
    UIViewController *vc = [[HHRouter shared] matchController:kZCIllegalEvidenceViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
