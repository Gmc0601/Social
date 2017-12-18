//
//  AddInfoViewController.m
//  BaseProject
//
//  Created by cc on 2017/10/31.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddInfoViewController.h"
#import "XFNickNameViewController.h"
#import "XFSelectItemView.h"
#import "AppAlertViewController.h"
#import "CityPickView.h"
#import "GTMBase64.h"

@interface AddInfoViewController ()<UITableViewDelegate, UITableViewDataSource,XFSelectItemViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *age, *nickName, *sex, *location;
}

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSArray *dataArr;

@property (nonatomic, retain) UIImageView *headimage;

@property (nonatomic, retain) UIButton *finishBtn;

@end

@implementation AddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sex =  @"注册后不可修改";
    self.titleLab.text = @"基本信息";
    self.rightBar.hidden = YES;
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.finishBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IdStr = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:IdStr];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IdStr];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.headimage];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    NSString *str ;
    switch (indexPath.row) {
        case 0:{
            
        }
            str = @"";
            break;
        case 1:
            str = age;
            break;
        case 2:
            str = nickName;
            break;
        case 3:
            str = sex;
            break;
        case 4:
            str = location;
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = str;
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeakSelf
    switch (indexPath.row) {
        case 0:{
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takeAlbum];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //TODO
            }];
            [actionSheet addAction:action1];
            [actionSheet addAction:action2];
            [actionSheet addAction:cancelAction];
            
            [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
        }
            break;
        case 1:{
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i <= 100; i++) {
                [arrayM addObject:[NSString stringWithFormat:@"%d", i]];
            }
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"年龄"
                                                                         dataArray:arrayM
                                                                        selectText:nil];
            selectItem.tag = 101;
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 2:{
            XFNickNameViewController *vc = [[XFNickNameViewController alloc] init];
            vc.saveBtnClick = ^(NSString *nick) {
                nickName = nick;
                [weakSelf.noUseTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            XFSelectItemView *selectItem = [[XFSelectItemView alloc] initWithTitle:@"性别"
                                                                         dataArray:@[@"男", @"女"]
                                                                        selectText:nil];
            selectItem.tag = 102;
            selectItem.delegate = self;
            [self.view addSubview:selectItem];
        }
            break;
        case 4:{
            
            CityPickView *cityPickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, kScreenH , self.view.frame.size.width, 256)];
            cityPickView.address = @"浙江省-杭州市-余杭区";  //设置默认城市，弹出之后显示的是这个
            cityPickView.backgroundColor = [UIColor whiteColor];//设置背景颜色
            cityPickView.toolshidden = NO; //默认是显示的，如不需要，toolsHidden设置为yes
            //点击确定按钮回调
            cityPickView.doneBlock = ^(NSString *proVince,NSString *city,NSString *area){
                location = [NSString stringWithFormat:@"%@-%@-%@",proVince,city,area];
                [weakSelf.noUseTableView reloadData];
                [self.view endEditing:YES];//使键盘消失
            };
            //点击取消按钮回调
            cityPickView.cancelblock = ^(){
                [self.view endEditing:YES];
            };
            [cityPickView show];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ----------<XFSelectItemViewDelegate>----------
- (void)selectItemView:(XFSelectItemView *)itemView selectInfo:(NSString *)info {
    if (itemView.tag == 101) {
        age = info;
    }
    if (itemView.tag == 102) {
        sex = info;
    }
    [self.noUseTableView reloadData];
}

#pragma mark -- Photo
- (void)takeAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
        [alert showAlert:@"提示" message:@"当前相机不可用" sureTitle:nil cancelTitle:@"确定" sure:nil cancel:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.headimage.image = editedImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.noUseTableView reloadData];
}

- (void)finishClick:(UIButton *)sender {
    //  保存
    /*
     userToken 必传
     sex 性别 必传  1男 2女
     avatar_url  头像 必传  base64
     nickname 昵称 必传
     age 年龄 必传
     address 居住地 必传
     */
    
    
    NSString *sexStr;
    if ([sex isEqualToString:@"男"]) {
        sexStr = @"1";
    }else {
        sexStr = @"2";
    }
    NSData *imgData = UIImageJPEGRepresentation(self.headimage.image,0.5);
    NSString *imgStr = [GTMBase64 stringByEncodingData:imgData];
    if (!imgStr) {
        imgStr = nil;
    }
    NSDictionary *dic = @{
                          @"sex" : sexStr,
                          @"avatar_url" : imgStr,
                          @"nickname" : nickName,
                          @"age" : age,
                          @"address" : location
                          };
    
    [HttpRequest postPath:@"_myxinxi_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
            [[NSNotificationCenter defaultCenter] postNotificationName:XFLoginSuccessNotification object:nil];
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeigh(50))];
            UILabel *headLab = [[UILabel alloc] initWithFrame:FRAME(0, 0, kScreenW, 10)];
            headLab.backgroundColor = RGB(239, 240, 241);
            UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 10, kScreenW, 40)];
            lab.backgroundColor = [UIColor whiteColor];
            lab.textColor = UIColorFromHex(0x999999);
            lab.text = @"   以下资料为必填项";
            lab.font = [UIFont systemFontOfSize:12];
            UILabel *line = [[UILabel alloc] initWithFrame:FRAME(5, 39, kScreenW, 1)];
            line.backgroundColor = UIColorFromHex(0xe0e0e0);
            [lab addSubview:line];
            [view addSubview:lab];
            [view addSubview:headLab];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeigh(50))];
            view;
        });
    }
    return _noUseTableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"头像", @"年龄", @"昵称", @"性别", @"居住地"];
    }
    return _dataArr;
}


- (UIImageView *)headimage {
    if (!_headimage) {
        _headimage  = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - SizeWidth(77), SizeHeigh(8), SizeWidth(34), SizeWidth(34))];
        _headimage.layer.masksToBounds = YES;
        _headimage.layer.cornerRadius = SizeWidth(17);
        _headimage.image = [UIImage imageNamed:@"jbxx_img_tx"];
    }
    return _headimage;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] initWithFrame:FRAME(15, kScreenH - 44 - 10, kScreenW - 30, 44)];
        _finishBtn.backgroundColor = ThemeColor;
        [_finishBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 5;
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
