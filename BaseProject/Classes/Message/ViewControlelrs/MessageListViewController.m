//
//  MessageListViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MessageListViewController.h"
//#import "ChatViewController.h"
//#import "JQTimeHelper.h"
#import "LoginViewController.h"
#import "TBNavigationController.h"
#import "SystemMessageViewController.h"
#import "ContactsViewController.h"
#import "ChatRequestViewController.h"
#import "ChatInfoTableViewCell.h"
#import "ChatRequestModel.h"
#import "EaseMessageViewController.h"
#import "ChatNagaitonController.h"
#define FetchChatroomPageSize   20

@interface MessageListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int questCount;
    int unreadCount;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (nonatomic, retain) NSMutableArray *dateArr;
@property (nonatomic, retain) NSMutableArray *nickArr;
@property (nonatomic, retain) UILabel *lab;

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"消息";
    
    [self.rightBtn setTitle:@"系统消息" forState:UIControlStateNormal];
    [self createDate ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDate) name:HaveNewMessage object:nil];
    
}

- (void)createDate {
    unreadCount = 0;
    EMError *error = nil;
    error = [[EMClient sharedClient] loginWithUsername:[ConfigModel getStringforKey:Mobile] password:ChatPWD];
    [self.dateArr removeAllObjects];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    int num = [EMConversation unreadMessagesCount];
    
//    NSArray *conversations = [[EMClient sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    self.dateArr = (NSMutableArray *)conversations;
    
    [self.dateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMConversation *conversation = obj;
        EMMessage *message = conversation.latestMessage;
        if ([[self timeStr:message.localTime] isEqualToString:@"1970-01-01 08:00"]) {
            [self.dateArr removeObject:obj];
        }
    }];
    
    NSString *arrimg ;
    NULLReturn(conversations);
    for (int i = 0; i < conversations.count; i++) {
        EMConversation *conversation = conversations[i];
        unreadCount += conversation.unreadMessagesCount;
        [ConfigModel saveIntegerObject:unreadCount forKey:Unreadnum];
        NSString *imgStr = conversation.conversationId;
        
        
        if (i == 0) {
            arrimg = imgStr;
        }else {
            NSString *str = [NSString stringWithFormat:@",%@", imgStr];
            arrimg = [arrimg stringByAppendingString:str];
        }
    }
    NSMutableArray *newArr = [NSMutableArray new];
    [newArr removeAllObjects];
    [HttpRequest postPath:@"_chat_request_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            
            NSArray *infoArr = datadic[@"info"];
            NULLReturn(infoArr)
            
            for (NSDictionary *dic in infoArr) {
                ChatRequestModel *model = [[ChatRequestModel alloc] init];
                model.avatar_url = dic[@"avatar_url"];
                model.nickname = dic[@"nickname"];
                model.request_id = dic[@"request_id"];
                model.request_time = dic[@"request_time"];
                [newArr addObject:model];
            }
            questCount = (int)newArr.count;
            
            [self.noUseTableView reloadData];
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
        
    }];
    
    NSLog(@".....%@", arrimg);
    //  请求头像 昵称
    
    NULLReturn(arrimg)
    NSDictionary *dic = @{
                          @"username" :arrimg,
                          };
    
    [HttpRequest postPath:@"_chitchatlist_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSArray *infoArr = datadic[@"info"];
            NULLReturn(infoArr)
            for (NSDictionary *dic in infoArr) {
                ChatRequestModel *model = [[ChatRequestModel alloc] init];
                if (!IsNULL(dic[@"nickname"])) {
                    model.nickname = dic[@"nickname"];
                }
                model.avatar_url = dic[@"avatar_url"];
                [self.nickArr addObject:model];
            }
            [self.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];


    
}


- (BOOL)check:(EMMessage *)message {
    EMMessageBody *msgBody = message.body;
    if ([[self timeStr:message.localTime] isEqualToString:@"1970-01-01 08:00"]) {
        return NO;
    }
    return YES;
}

- (IBAction)loginClick:(id)sender {
    TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)moreClick {
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    
    SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        [self.view addSubview:self.noUseTableView];
        [self createDate];

    }else {
        [self.noUseTableView removeFromSuperview];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 1 ? self.dateArr.count: 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu%lu", indexPath.section, indexPath.row];
    
    if (indexPath.section < 1) {
        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        switch (indexPath.section) {
            case 0:{
                cell.textLabel.text = @"通讯录";
            }
                break;
            case 1:{
                cell.textLabel.text = @"聊天请求";
                [cell.contentView addSubview:self.lab];
                if (questCount <= 0) {
                    self.lab.hidden = YES;
                }else if(questCount > 99){
                    self.lab.hidden = NO;
                    self.lab.text = [NSString stringWithFormat:@"9+"];
                }else {
                    self.lab.hidden = NO;
                    self.lab.text = [NSString stringWithFormat:@"%d", questCount];
                }

            }
                break;
                
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        ChatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if  (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"ChatInfoTableViewCell" owner :nil options :nil ];
            cell = [  nibs lastObject ];
        }
        
        ChatRequestModel *model = [[ChatRequestModel alloc] init];
        if (self.nickArr.count > 0) {
           model = self.nickArr[indexPath.row];
        }
        
        EMConversation *conversation = self.dateArr[indexPath.row];
        if (conversation.unreadMessagesCount== 0) {
            cell.countLab.hidden = YES;
        }else {
            cell.countLab.hidden = NO;
            cell.countLab.text = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
        }
        EMMessage *message = conversation.latestMessage;
        
        [self getmessage:message cell:cell];
        //  更改时间
        cell.timeLab.text = [self timeStr:message.localTime];
        NSLog(@"...<><>.%@",[self timeStr:message.localTime]);
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
        cell.nameLab.text = model.nickname;
        
        return cell;
    }
    
    
    
}

- (NSString *)timeStr:(long long)timestamp
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFmt.dateFormat = @"HH:mm";
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    
    
    return [dateFmt stringFromDate:msgDate];
}




- (void)getmessage:(EMMessage *)message cell:(ChatInfoTableViewCell *)cell {
    EMMessageBody *msgBody = message.body;
    
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 收到的文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            NSString *txt = textBody.text;
            cell.infoLab.text = txt;
            NSLog(@"收到的文字是 txt -- %@",txt);
        }
            break;
        case EMMessageBodyTypeImage:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",body.downloadStatus);
            cell.infoLab.text = @"[图片]";
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,body.downloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,body.downloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
        }
            break;
        case EMMessageBodyTypeFile:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.downloadStatus);
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 1 ? 70 : 48;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    EMConversation *conversation = self.dateArr[indexPath.row];
    [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError){
        //code
        [weakSelf createDate];
        
    }];
    // 刷新
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        ContactsViewController *vc = [[ContactsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    if (indexPath.section == 1) {
        
        EMConversation *conversation = self.dateArr[indexPath.row];
        [ConfigModel jumptoChatViewController:self withId:conversation.conversationId];
    }
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStyleGrouped];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (NSMutableArray *)dateArr {
    if(!_dateArr ){
        _dateArr = [NSMutableArray new];
}
    return _dateArr;
    
}

- (NSMutableArray *)nickArr {
    if (!_nickArr) {
        _nickArr  = [NSMutableArray new];
    }
    return _nickArr;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:FRAME(kScreenW - 40, 12, 30, 20)];
        _lab.layer.masksToBounds = YES;
        _lab.layer.cornerRadius = 10;
        _lab.backgroundColor = [UIColor redColor];
        _lab.textColor = [UIColor whiteColor];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = NormalFont(10);
    }
    return _lab;
}


@end
