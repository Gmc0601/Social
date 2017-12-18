//
//  XFMyInfoViewController.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/19.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFMyInfoViewController.h"
#import "XFSelectItemView.h"
#import "XFNickNameViewController.h"
#import "XFAssetViewController.h"
#import "XFAssetVerifyViewController.h"
#import "XFSelectInterestView.h"
#import "XFSelectAddressView.h"

@interface XFMyInfoViewController ()<XFSelectItemViewDelegate, XFSelectInterestViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, XFSelectAddressViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) XFSelectItemView *selectItem;
@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *jobArray;
@property (nonatomic, strong) NSArray *incomeArray;
@property (nonatomic, strong) NSMutableArray *hobbyArray;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) BOOL avatarChange;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, assign) BOOL ageChange;
@property (nonatomic, assign) BOOL addressChange;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;

@end

@implementation XFMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.jobArray = @[@"在校学生", @"现役军人", @"私营业主", @"企业职工", @"政府机关/事业单位工作者", @"农业劳动者", @"自由职业者"];
    self.incomeArray = @[@"3000以下", @"3000-5000", @"5000-10000", @"10000-20000", @"50000以上"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    UIView *navView = [UIView xf_navView:@"个人信息"
                              backTarget:self
                              backAction:@selector(backBtnClick)];
    [self.view addSubview:navView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - XFNavHeight)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
}

- (void)setupContent {
    UIView *paddingView1 = [UIView xf_createPaddingView];
    paddingView1.frame = CGRectMake(0, 0, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView1];
    
    UIView *sectionOneView = [self createRightEmptyView:@"基本信息"];
    sectionOneView.top = paddingView1.bottom;
    
    UIView *avatarView = [self createRightIconView:@"头像"];
    avatarView.tag = 100;
    avatarView.top = sectionOneView.bottom;
    if (self.user.avatar_url.length) {
        [self.iconBtn setImageWithURL:[NSURL URLWithString:self.user.avatar_url] forState:UIControlStateNormal options:kNilOptions];
    }
    
    UIView *ageView = [self createRightLabelView:@"年龄" andInfo:self.user.age hiddenSplit:NO];
    ageView.tag = 101;
    ageView.top = avatarView.bottom;
    
    UIView *nickNameView = [self createRightLabelView:@"昵称" andInfo:self.user.nickname hiddenSplit:NO];
    nickNameView.tag = 102;
    nickNameView.top = ageView.bottom;
    
    UIView *genderView = [self createRightLabelView:@"性别" andInfo:self.user.sex hiddenSplit:NO];
    [genderView viewWithTag:999].hidden = YES;
    genderView.tag = 103;
    genderView.top = nickNameView.bottom;
    
    UIView *addressView = [self createRightLabelView:@"居住地" andInfo:self.user.address hiddenSplit:YES];
    addressView.tag = 104;
    addressView.top = genderView.bottom;
    
    UIView *paddingView2 = [UIView xf_createPaddingView];
    paddingView2.frame = CGRectMake(0, addressView.bottom, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView2];
    
    UIView *sectionTwoView = [self createRightEmptyView:@"个人信息"];
    sectionTwoView.top = paddingView2.bottom;
    
    UIView *heightView = [self createRightLabelView:@"身高" andInfo:self.user.height hiddenSplit:NO];
    heightView.tag = 200;
    heightView.top = sectionTwoView.bottom;
    
    UIView *weightView = [self createRightLabelView:@"体重" andInfo:self.user.weight hiddenSplit:NO];
    weightView.tag = 201;
    weightView.top = heightView.bottom;
    
    UIView *educationView = [self createRightLabelView:@"学历" andInfo:self.user.education hiddenSplit:NO];
    educationView.tag = 202;
    educationView.top = weightView.bottom;
    
    UIView *interestView = [self createRightLabelView:@"兴趣爱好" andInfo:self.user.hobby hiddenSplit:NO];
    UILabel *label = [interestView viewWithTag:100];
    CGFloat right = label.right;
    label.height = interestView.height;
    label.left = 70;
    label.top = 0;
    label.width = right - label.left;
    interestView.tag = 203;
    interestView.top = educationView.bottom;
    
    self.hobbyArray = [NSMutableArray arrayWithArray:[self.user.hobby componentsSeparatedByString:@" "]];
    
    UIView *feelingView = [self createRightLabelView:@"感情状况" andInfo:self.user.feeling hiddenSplit:NO];
    feelingView.tag = 204;
    feelingView.top = interestView.bottom;
    
    UIView *standardView = [self createRightLabelView:@"择偶标准" andInfo:@"" hiddenSplit:YES];
    UITextField *field = [[UITextField alloc] init];
    self.field = field;
    [field addTarget:self action:@selector(fieldTextChangedMethod:) forControlEvents:UIControlEventEditingChanged];
    field.placeholder = @"用一句话来描述";
    field.textColor = [UIColor blackColor];
    field.font = Font(15);
    [standardView addSubview:field];
    field.left = 80;
    field.width = kScreenWidth - 15 - 9 - 15 - field.left;
    field.top = 0;
    field.textAlignment = NSTextAlignmentRight;
    field.height = standardView.height;
    [standardView addSubview:field];
    standardView.tag = 205;
    standardView.top = feelingView.bottom;
    if (self.user.spouse.length) {
        field.text = self.user.spouse;
    }
    
    UIView *paddingView3 = [UIView xf_createPaddingView];
    paddingView3.frame = CGRectMake(0, standardView.bottom, kScreenWidth, 5);
    [self.scrollView addSubview:paddingView3];
    
    UIView *sectionThreeView = [self createRightEmptyView:@"详细信息"];
    sectionThreeView.top = paddingView3.bottom;
    
    UIView *workViewView = [self createRightLabelView:@"工作" andInfo:self.user.job hiddenSplit:NO];
    workViewView.tag = 300;
    workViewView.top = sectionThreeView.bottom;
    
    UIView *incomeView = [self createRightLabelView:@"收入" andInfo:self.user.income hiddenSplit:NO];
    incomeView.tag = 301;
    incomeView.top = workViewView.bottom;
    
    UIView *houseView = [self createRightLabelView:@"房产" andInfo:self.user.house hiddenSplit:NO];
    houseView.tag = 302;
    houseView.top = incomeView.bottom;
    
    UIView *carView = [self createRightLabelView:@"车产" andInfo:self.user.car hiddenSplit:NO];
    carView.tag = 303;
    carView.top = houseView.bottom;
    
    UIButton *saveBtn = [UIButton xf_bottomBtnWithTitle:@"保存"
                                                 target:self
                                                 action:@selector(saveBtnClick)];
    saveBtn.frame = CGRectMake(10, carView.bottom + 10, kScreenWidth - 20, 44);
    [self.scrollView addSubview:saveBtn];
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, saveBtn.bottom + 10)];
}

- (void)fieldTextChangedMethod:(UITextField *)textField {
    CGSize size = [textField sizeThatFits:CGSizeZero];
        // 限制验证码长度
    if (size.width > textField.width) {
        textField.text = [textField.text substringToIndex:self.maxCount];
    } else {
        self.maxCount = textField.text.length;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - -------------------<XFSelectAddressViewDelegate>-------------------
- (void)selectAddressView:(XFSelectAddressView *)itemView
           selectProvince:(NSString *)province
                     city:(NSString *)city
                  address:(NSString *)area {
    NSString *info = [NSString stringWithFormat:@"%@%@%@", province, city, area];
    self.province = province;
    self.city = city;
    self.area = area;
    self.addressChange = YES;
    UILabel *label = [self.selectItem viewWithTag:100];
    label.text = info;
    self.user.address = info;
    self.addressChange = YES;
}

- (void)loadData {
    WeakSelf
    [HttpRequest postPath:XFMyInfoUrl
                   params:nil
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0) {
                          if ([responseObject[@"info"] isKindOfClass:[NSDictionary class]]) {
                              NSDictionary *infoDict = responseObject[@"info"];
                              NSDictionary *jibenDict = infoDict[@"jiben"];
                              NSDictionary *gerenDict = infoDict[@"geren"];
                              NSDictionary *xiangxiDict = infoDict[@"xiangxi"];
                              NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
                              if ([jibenDict isKindOfClass:[NSDictionary class]
                                   ]) {
                                  [allDict addEntriesFromDictionary:jibenDict];
                              }
                              if ([gerenDict isKindOfClass:[NSDictionary class]
                                   ]) {
                                  [allDict addEntriesFromDictionary:gerenDict];
                              }
                              if ([xiangxiDict isKindOfClass:[NSDictionary class]
                                   ]) {
                                  [allDict addEntriesFromDictionary:xiangxiDict];
                              }
                              User *user = [User mj_objectWithKeyValues:allDict];
                              weakSelf.user = user;
                              
                              [weakSelf setupContent];
                          }
                      }
                  }
                  
              }];
}

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    UILabel *label = [self.selectItem viewWithTag:100];
    label.text = info;
    NSInteger tag = self.selectItem.tag;
    if (tag == 100) { // 头像
    } else if (tag == 101) {// 年龄
        self.user.age = info;
        self.ageChange = YES;
    } else if (tag == 103) { // 性别
        self.user.sex = info;
    } else if (tag == 104) { // 居住地
    } else if (tag == 200) { // 身高
        self.user.height = info;
    } else if (tag == 201) { // 体重
        self.user.weight = info;
    } else if (tag == 202) { // 学历
        self.user.education = info;
    } else if (tag == 204) { // 感情状况
        self.user.feeling = info;
    } else if (tag == 205) { // 择偶标准
        self.user.spouse = info;
    } else if (tag == 300) { // 工作
        self.user.job = info;
    } else if (tag == 301) { // 收入
        self.user.income = info;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarChange = YES;
    self.avatarImage = image;
    [self.iconBtn setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------<XFSelectInterestViewDelegate>----------
- (void)selectInterestView:(XFSelectInterestView *)view didselectItem:(NSArray *)array {
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < array.count; i++) {
        [str appendFormat:@"%@", array[i]];
        if (i != array.count - 1) {
            [str appendFormat:@" "];
        }
    }
    UILabel *label = [self.selectItem viewWithTag:100];
    label.text = str.copy;
    self.user.hobby = str.copy;
    self.hobbyArray = [NSMutableArray arrayWithArray:array];
    
}

#pragma mark ----------Action----------
- (void)saveBtnClick {
    self.resultArray = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    if (self.ageChange) {
        if (self.user.age.length) {
            dict1[@"age"] = self.user.age;
        }
    }
    
    if (self.addressChange) {
        if (self.province.length) {
            dict1[@"province"] = self.province;
        }
        
        if (self.city.length) {
            dict1[@"city"] = self.city;
        }
        
        if (self.area.length) {
            dict1[@"area"] = self.area;
        }
    }
    
    if (self.avatarChange) {
        if (self.user.avatar_url) {
            dict1[@"avatar_url"] = [[self.avatarImage imageDataRepresentation] base64EncodedString];
        }
    }
    
    [HttpRequest postPath:XFMyBasicInfoUpdateUrl
                   params:dict1
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          [self.resultArray addObject:@"1"];
                      } else {
                          [self.resultArray addObject:responseObject[@"info"]];
                      }
                  } else {
                      [self.resultArray addObject:@"修改失败"];
                  }
                  [self overRequest];
              }];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    if (self.user.height) {
        dict2[@"height"] = self.user.height;
    }
    if (self.user.weight) {
        dict2[@"weight"] = self.user.weight;
    }
    if (self.user.hobby) {
        dict2[@"hobby"] = self.user.hobby;
    }
    if (self.user.education) {
        if ([self.user.education isEqualToString:@"中专及以下"]) {
            dict2[@"education"] = @"1";
        } else if ([self.user.education isEqualToString:@"大专"]) {
            dict2[@"education"] = @"2";
        } else if ([self.user.education isEqualToString:@"本科"]) {
            dict2[@"education"] = @"3";
        } else if ([self.user.education isEqualToString:@"硕士"]) {
            dict2[@"education"] = @"4";
        } else if ([self.user.education isEqualToString:@"博士及以上"]) {
            dict2[@"education"] = @"5";
        }
    }
    if (self.user.feeling) {
        dict2[@"feeling"] = self.user.feeling;
        if ([self.user.feeling isEqualToString:@"未婚"]) {
            dict2[@"feeling"] = @"1";
        } else if ([self.user.feeling isEqualToString:@"离异"]) {
            dict2[@"feeling"] = @"2";
        } else if ([self.user.feeling isEqualToString:@"已婚"]) {
            dict2[@"feeling"] = @"3";
        }
    }
    if (self.field.text.length) {
        dict2[@"spouse"] = self.field.text;
    }
    
    [HttpRequest postPath:XFMyPersonalInfoUpdateUrl
                   params:dict2
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          [self.resultArray addObject:@"1"];
                      } else {
                          [self.resultArray addObject:responseObject[@"info"]];
                      }
                  } else {
                      [self.resultArray addObject:@"修改失败"];
                  }
                  [self overRequest];
              }];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    if (self.user.job) {
        if (self.user.job.length && [self.jobArray containsObject:self.user.job]) {
            NSInteger index = [self.jobArray indexOfObject:self.user.job];
            dict3[@"job"] = @(index + 1);
        }    
    }
    if (self.user.income) {
        if (self.user.income.length && [self.incomeArray containsObject:self.user.income]) {
            NSInteger index = [self.incomeArray indexOfObject:self.user.income];
            dict3[@"income"] = @(index + 1);
        }
    }
    
    [HttpRequest postPath:XFMyMinuteInfoUpdateUrl
                   params:dict3
              resultBlock:^(id responseObject, NSError *error) {
                  if (!error) {
                      NSNumber *errorCode = responseObject[@"error"];
                      if (errorCode.integerValue == 0){
                          [self.resultArray addObject:@"1"];
                      } else {
                          [self.resultArray addObject:responseObject[@"info"]];
                      }
                  } else {
                      [self.resultArray addObject:@"修改失败"];
                  }
                  [self overRequest];
              }];
}

- (void)overRequest {
    BOOL success = YES;
    for (int i = 0; i < self.resultArray.count; i++) {
        NSString *info = self.resultArray[i];
        if (![info isEqualToString:@"1"]) {
            success = NO;
            [ConfigModel mbProgressHUD:info andView:nil];
            break;
        }
    }
    if (success) {
        [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XFLoginSuccessNotification object:nil];
        [self backBtnClick];
    }
}

- (void)rightLabelViewTap:(UITapGestureRecognizer *)ges {
    [self.view endEditing:YES];
    self.selectItem = (XFSelectItemView *)ges.view;
    NSInteger tag = ges.view.tag;
    if (tag == 101) {
        // 年龄
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i <= 100; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"年龄"
                                                                     dataArray:arrayM
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 102) {
        // 昵称
        XFNickNameViewController *controller = [[XFNickNameViewController alloc] init];
        controller.nickName = self.user.nickname;
        controller.saveBtnClick = ^(NSString *nickName) {
            UIView *view = [self.view viewWithTag:102];
            UILabel *label =  (UILabel *)[view viewWithTag:100];
            label.text = nickName;
            self.user.nickname = nickName;
        };
        [self pushController:controller];
    } else if (tag == 103) {
    } else if (tag == 104) {
        // 居住地
        XFSelectAddressView *addressView = [[XFSelectAddressView alloc] init];
        addressView.delegate = self;
        [self.view addSubview:addressView];
    } else if (tag == 200) {
        // 身高
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 140; i <= 200; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"身高(cm)"
                                                                     dataArray:arrayM
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 201) {
        // 体重
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 40; i <= 150; i++) {
            [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
        }
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"体重(kg)"
                                                                     dataArray:arrayM.copy
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 202) {
        // 学历
        NSArray *array = @[@"中专及以下", @"大专", @"本科", @"硕士", @"博士及以上"];
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"感情状况"
                                                                     dataArray:array
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 203) {
        // 兴趣爱好
        XFSelectInterestView *selectView = [[XFSelectInterestView alloc] initWithSelectArray:self.hobbyArray];
        selectView.delegate = self;
        [self.view addSubview:selectView];
    } else if (tag == 204) {
        // 感情状况
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"感情状况"
                                                                     dataArray:@[@"未婚", @"已婚", @"离异"]
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 205) {
        // 择偶标准
    } else if (tag == 300) {
        // 工作
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"工作"
                                                                     dataArray:self.jobArray
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 301) {
        // 收入
        XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"收入"
                                                                     dataArray:self.incomeArray
                                                                    selectText:nil];
        selectItem.delegate = self;
        [self.view addSubview:selectItem];
    } else if (tag == 302) {
        [HttpRequest postPath:XFMyHouseCheckUrl
                       params:nil
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSString *info = responseObject[@"info"];
                              if ([info isEqualToString:@"0"]) {
                                  XFAssetViewController *controller = [[XFAssetViewController alloc] init];
                                  controller.type = AssetType_House;
                                  [self pushController:controller];
                              } else {
                                  XFAssetVerifyViewController *controller = [[XFAssetVerifyViewController alloc] init];
                                  if ([info isEqualToString:@"1"]) {
                                      controller.status = AssetVerifyStatus_Procress;
                                  } else if ([info isEqualToString:@"2"]) {
                                      controller.status = AssetVerifyStatus_Success;
                                  } else if ([info isEqualToString:@"3"]) {
                                      controller.status = AssetVerifyStatus_Fail;
                                  }
                                  [self pushController:controller];
                                  
                              }
                          }
                      }
                  }];
        // 房产
        
    } else if (tag == 303) {
        // 车产
        [HttpRequest postPath:XFMyCarCheckUrl
                       params:nil
                  resultBlock:^(id responseObject, NSError *error) {
                      if (!error) {
                          NSNumber *errorCode = responseObject[@"error"];
                          if (errorCode.integerValue == 0){
                              NSString *info = responseObject[@"info"];
                              if ([info isEqualToString:@"0"]) {
                                  XFAssetViewController *controller = [[XFAssetViewController alloc] init];
                                  controller.type = AssetType_Car;
                                  [self pushController:controller];
                              } else {
                                  XFAssetVerifyViewController *controller = [[XFAssetVerifyViewController alloc] init];
                                  if ([info isEqualToString:@"1"]) {
                                      controller.status = AssetVerifyStatus_Procress;
                                  } else if ([info isEqualToString:@"2"]) {
                                      controller.status = AssetVerifyStatus_Success;
                                  } else if ([info isEqualToString:@"3"]) {
                                      controller.status = AssetVerifyStatus_Fail;
                                  }
                                  [self pushController:controller];
                                  
                              }
                          }
                      }
                  }];
        
    }
}

- (void)rightIconViewTap:(UITapGestureRecognizer *)ges {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择上传类型"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView *)createRightEmptyView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 45);
    
    UILabel *label = [UILabel xf_labelWithFont:Font(15)
                                     textColor:BlackColor
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = info;
    label.frame = CGRectMake(15, 0, view.width - 30, view.height);
    [view addSubview:label];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    [self.scrollView addSubview:view];
    return view;
}

- (UIView *)createRightIconView:(NSString *)info {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 45);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightIconViewTap:)]];
    [self.scrollView addSubview:view];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(102)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = info;
    label.frame = CGRectMake(15, 0, view.width - 30, view.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:Image(@"icon_gd")];
    arrowView.centerY = view.height * 0.5;
    arrowView.right = view.width - 15;
    [view addSubview:arrowView];
    
    UIButton *iconBtn = [UIButton xf_imgButtonWithImgName:@"bg_tj_tx"
                                                   target:self
                                                   action:@selector(iconBtnClick)];
    iconBtn.userInteractionEnabled = NO;
    self.iconBtn = iconBtn;
    iconBtn.size = CGSizeMake(34, 34);
    iconBtn.layer.cornerRadius = 17;
    iconBtn.layer.masksToBounds = YES;
    iconBtn.centerY = view.height * 0.5;
    iconBtn.right = arrowView.left - 10;
    iconBtn.tag = 100;
    [view addSubview:iconBtn];
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    
    return view;
}

- (UIView *)createRightLabelView:(NSString *)title andInfo:(NSString *)info hiddenSplit:(BOOL) hidden {
    UIView *view = [UIView xf_createWhiteView];
    view.size = CGSizeMake(kScreenWidth, 50);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightLabelViewTap:)]];
    [self.scrollView addSubview:view];
    
    UILabel *label = [UILabel xf_labelWithFont:Font(12)
                                     textColor:RGBGray(102)
                                 numberOfLines:0
                                     alignment:NSTextAlignmentLeft];
    label.text = title;
    label.frame = CGRectMake(15, 0, 100, view.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:Image(@"icon_gd-拷贝")];
    arrowView.centerY = view.height * 0.5;
    arrowView.right = view.width - 15;
    arrowView.tag = 999;
    [view addSubview:arrowView];
    
    UILabel *rightLabel = [UILabel xf_labelWithFont:Font(15)
                                          textColor:BlackColor
                                      numberOfLines:1
                                          alignment:NSTextAlignmentRight];
    if (info.length) rightLabel.text = info;
    rightLabel.width = 150;
    rightLabel.top = 0;
    rightLabel.height = view.height;
    rightLabel.right = arrowView.left - 10;
    [view addSubview:rightLabel];
    rightLabel.tag = 100;
    
    UIView *splitView = [UIView xf_createSplitView];
    splitView.frame = CGRectMake(10, view.height - 0.5, view.width - 20, 0.5);
    [view addSubview:splitView];
    splitView.hidden = hidden;
    
    return view;
}

@end

