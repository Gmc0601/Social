//
//  ChatViewController.m
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "MessageHelper.h"
//#import "TaskCell.h"
#import "AboveBT.h"
#import "MsgTaskModel.h"
#import "MsgTaskAlert.h"
#import "TaskDetailVC.h"
#import "AlertSuccessV.h"

@interface ChatViewController ()<YYTextViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIView *chatView;
    CGFloat topH;
    
    

}


@property (nonatomic, strong) YYTextView  *inputText;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MsgUser *user;

@property (nonatomic, strong) UITableViewCell *topView;

@property (nonatomic, strong) NSMutableArray *taskAry;



@property (nonatomic, strong) MsgTaskModel *mTaskModel;



@end

@implementation ChatViewController

/*
 * 初始化聊天页
 * conversation：聊天对象
 * type：单聊，群聊
 */
- (instancetype)initWithConversation:(NSString *)conversation type:(EMConversationType)type
{
    self = [super init];
    if (self) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:conversation type:type createIfNotExist:YES];
//        self.simpleServer = [conversation isEqualToString:[Singleton shareSingleton].serverNum];
    }
    return self;
}


- (instancetype)initWithFriendID:(NSString *)chatID
{
    self = [super init];
    
    if (self) {
        WeakObj(self);
        self.taskAry = @[].mutableCopy;
        [[HttpRequest defaultRequest] postPath:simple_MessageExchange params:@{@"userid":chatID} resultBlock:^(id responseObject, NSError *error) {
            if (SUCCESS(responseObject)) {
                
                [MsgTaskModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"ID":@"id"};
                }];
                NSMutableArray *goodList = [MsgTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"info"][@"list"]];
                
                [selfWeak.taskAry addObjectsFromArray:goodList];
                
                selfWeak.user =  [MsgUser mj_objectWithKeyValues:responseObject[@"info"][@"userlist"]];
                self.title = self.user.nickname;
                selfWeak.conversation = [[EMClient sharedClient].chatManager getConversation:selfWeak.user.mobile type:EMConversationTypeChat createIfNotExist:YES];
                
                //网络请求
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 主线程刷新UI
                    [selfWeak createDataFromTable];
                    [selfWeak changeTopView:selfWeak.taskAry.firstObject];
                });
                if (selfWeak.firstMessage) {
                    [selfWeak sendMessage:selfWeak.firstMessage];
                }
                
            }
        }];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Singleton shareSingleton].inChatView = YES;
    [self registerNotification];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [Singleton shareSingleton].inChatView = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setUpItems];
    
    self.dataSource = [@[] mutableCopy];
    [self createDataFromTable];

    
   
  
}







#pragma mark -  客服发消息给用户
- (void)sendfirstMessage{
    
    EMTextMessageBody *textMsg = [[EMTextMessageBody alloc] initWithText:@"你好，有什么问题可以直接来问我"];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:Defaults(User_Mobile) from:[Singleton shareSingleton].serverNum to:Defaults(User_Mobile) body:textMsg ext:nil];
    

    [self.dataSource insertObject:message atIndex:0];
    [self.tableView reloadData];
    [self.tableView scrollToRow:self.dataSource.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
}



- (void)registerNotification
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrmWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reserveNewMessage:) name:ReserveMessageNotification object:nil];

    
}







#pragma mark -   数据库

- (void)createDataFromTable
{
    NSString *messageID;
    EMMessage *message = self.dataSource.firstObject;
    if (message) {
        messageID = message.messageId;
    }
    
    int count = self.conversation.unreadMessagesCount>10?self.conversation.unreadMessagesCount:10;
    
    [self.conversation loadMessagesStartFromId:messageID count:count searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            [self.dataSource addObjectsFromArray:aMessages];
          
            [self.dataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                long long time1 = ((EMMessage *)obj1).localTime;
                long long time2 = ((EMMessage *)obj2).localTime;
                return  [@(time1) compare:@(time2)];
            }];
            [self.tableView reloadData];
            if (self.dataSource.count != 0 && ![self.tableView.mj_header isRefreshing]) {
                [self.tableView scrollToRow:self.dataSource.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionNone) animated:NO];
            }
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                message.isRead = YES;
                [[EMClient sharedClient].chatManager  updateMessage:message completion:^(EMMessage *aMessage, EMError *aError) {
                    
                }];
            }];
            [self.tableView.mj_header endRefreshing];
            if (self.simpleServer) {
                [self sendfirstMessage];
            }
        }
     
    }];
}



#pragma mark -   UI
- (void)setUpItems
{
    topH = 0;
    if (!self.simpleServer) {
        self.topView = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"topCell"];
        self.topView.frame = CGRectMake(0, Navi_Height, kScreenWidth, Height(50));
        self.topView.backgroundColor = WhiteColor;
        [self.view addSubview:self.topView];
        WeakObj(self);
        [self.topView setTapActionWithBlock:^{
            [MsgTaskAlert alertWithBlock:^(NSInteger index) {
                
                MsgTaskModel *model = selfWeak.taskAry[index];
                [selfWeak changeTopView:model];
                TaskDetailVC *detailVC = [[TaskDetailVC alloc] init];
                if ([model.type isEqualToString:@"商品"]) {
                    detailVC.isGoods = YES;
                }
                detailVC.ID =  model.ID;
                [selfWeak.navigationController pushViewController:detailVC animated:YES];
                
            } alertAry:selfWeak.taskAry];
        }];
        topH = Height(50)+Navi_Height;
    }
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topH, KScreenWidth, KScreenHeight-Height(48)-topH) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = BackGround_Color;
    self.tableView.separatorColor = ClearColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView.panGestureRecognizer  addActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    self.tableView.mj_header = [[Singleton shareSingleton] addHeaderRefresh:^{
        [self createDataFromTable];
    }];
    [self.view addSubview:self.tableView];
    
    
    ///aboutBT
    AboveBT *aboveBT = [[AboveBT alloc] initWithFrame:CGRectMake(kScreenWidth-Height(52)-Width(15), self.tableView.bottom-Height(52)-Width(15), Height(52), Height(52))];
    [aboveBT addBlockForControlEvents:(UIControlEventTouchUpInside) block:^(id  _Nonnull sender) {
        
        NSString *number = self.simpleServer? [Singleton shareSingleton].serverNum:self.user.mobile;
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",number]]];
    }];
    [self.view addSubview:aboveBT];
    
    
    
    //聊天
    chatView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, KScreenWidth, Height(48))];
    chatView.backgroundColor = WhiteColor;
    [self.view addSubview:chatView];
    
    self.inputText = [[YYTextView alloc] initWithFrame:CGRectMake(Width(15), Height(10), KScreenWidth-Width(69), Height(28))];
    self.inputText.layer.borderWidth = 0.5;
    self.inputText.layer.borderColor = FGX_line_color.CGColor;
    self.inputText.backgroundColor = WhiteColor;
    self.inputText.returnKeyType = UIReturnKeySend;
    self.inputText.enablesReturnKeyAutomatically=YES;
    self.inputText.delegate = self;
    
    UIButton *cameraBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cameraBT.frame = CGRectMake(self.inputText.right, 0, kScreenWidth-self.inputText.right, Height(48));
    [cameraBT setImage:[UIImage imageNamed:@"camera-button"] forState:(UIControlStateNormal)];
    [cameraBT addTarget:self action:@selector(selectPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [chatView addSubview:cameraBT];
     self.inputText.font = Font(13);
    self.inputText.placeholderText =  @"请输入要发送的内容";
   
    self.inputText.textColor = TEXT_666;
    self.inputText.layer.cornerRadius = 2;
    [chatView addSubview:self.inputText];
    
}
#pragma mark - change topView  点击事件
//change topView
- (void)changeTopView:(MsgTaskModel *)model{
    if (model==nil) {
        return;
    }
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]  ",model.type]];
    one.color = Main_Color;
    NSMutableAttributedString *two = [[NSMutableAttributedString alloc] initWithString:model.title];
    two.color = TEXT_666;
    [one appendAttributedString:two];
    self.topView.textLabel.attributedText = one;
    self.topView.textLabel.font = Font(13);
    self.topView.lineHide = NO;
    
    [self.topView.rightBT setImage:[UIImage imageNamed:@"dingdan"] forState:(UIControlStateNormal)];
    WeakObj(self);
    [self.topView.rightBT addBlockForControlEvents:(UIControlEventTouchUpInside) block:^(id  _Nonnull sender) {
        TaskDetailVC *detailVC = [[TaskDetailVC alloc] init];
        if ([model.type isEqualToString:@"商品"]) {
            detailVC.isGoods = YES;
        }
        detailVC.ID =  model.ID;
        [selfWeak.navigationController pushViewController:detailVC animated:YES];
    }];
    [self.topView setNeedsLayout];
    
    self.mTaskModel = model;
//    self.taskAry.firstObject;
    if (self.mTaskModel) {
        if (Simple_MyID(self.mTaskModel.publisher_id)&&[self.mTaskModel.type isEqualToString:@"商品"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }else if (Simple_MyID(self.mTaskModel.publisher_id)&&[self.mTaskModel.type isEqualToString:@"任务"]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(finishTask)];
        }else if (!Simple_MyID(self.mTaskModel.publisher_id)&&[self.mTaskModel.type isEqualToString:@"商品"]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(finishGood)];
        }else if (!Simple_MyID(self.mTaskModel.publisher_id)&&[self.mTaskModel.type isEqualToString:@"任务"]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消抢单" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelTask)];
        }
    }
    
}



#pragma mark - 确认完成(任务)
- (void)finishTask{
    [AlertSuccessV alertWithBlock:^(NSString *rate, NSString *commit) {
        [[HttpRequest defaultRequest] postPath:simple_FinishTask params:@{@"id":self.mTaskModel.ID,@"star":rate} resultBlock:^(id responseObject, NSError *error) {
            if (SUCCESS(responseObject)) {
                [SVProgressHUD showSuccessWithStatus:@"完成任务"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    } imageStr:self.user.avatar_url name:self.user.nickname];
}

#pragma mark - 确认完成（商品）
- (void)finishGood{
    [AlertSuccessV alertWithBlock:^(NSString *rate, NSString *commit) {
        [[HttpRequest defaultRequest] postPath:simple_FinishGood params:@{@"id":self.mTaskModel.ID,@"star":rate} resultBlock:^(id responseObject, NSError *error) {
            if (SUCCESS(responseObject)) {
                [SVProgressHUD showSuccessWithStatus:@"完成交易"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    } imageStr:self.user.avatar_url name:self.user.nickname];
}
#pragma mark - 取消抢单
- (void)cancelTask{
   UIAlertController * alertVC =  [[Singleton shareSingleton] alertWithTitle:nil detail:@"您是要取消抢单么？每月取消抢单超过三次后按规定扣除押金。请确认" cancel:@"按错了" action:^(UIAlertAction *action) {
        [[HttpRequest defaultRequest] postPath:simple_RemoveTaskGet params:@{@"id":self.mTaskModel.ID} resultBlock:^(id responseObject, NSError *error) {
            if (SUCCESS(responseObject)) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}





#pragma mark - =====    收到消息

- (void)reserveNewMessage:(NSNotification *)notifi
{
    EMMessage *message = (EMMessage *)notifi.object;
    if (![message.conversationId isEqualToString:self.conversation.conversationId]) {
        return;
    }
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    [self.tableView scrollToRow:self.dataSource.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
    message.isRead = YES;
    [[EMClient sharedClient].chatManager  updateMessage:message completion:nil];
}

#pragma mark - =====    发送消息
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
    
        [self sendMessage:textView.text];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark -     发送一条消息
- (void)sendMessage:(NSString *)text{
    EMTextMessageBody *textMsg = [[EMTextMessageBody alloc] initWithText:text];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:Defaults(User_Mobile) to:self.conversation.conversationId body:textMsg ext:nil];
     message.isRead =  YES;
    
    [[MessageHelper shareHelper] sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        [self.dataSource addObject:message];
        [self.tableView reloadData];
        [self.tableView scrollToRow:self.dataSource.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
    }];
  
    self.inputText.text = @"";
}




#pragma mark - 监听键盘
- (void)kbFrmWillChange:(NSNotification *)noti{
    if (![self.inputText isFirstResponder]) {
        return;
    }
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;

    chatView.top = kbEndY-Height(48);

    if (self.tableView.contentSize.height < CGRectGetHeight(kbEndFrm)) {
        return;
    }
    if (kbEndY==kScreenHeight) {
        self.tableView.top = topH;
    }else{
        self.tableView.top = -kbEndFrm.size.height+topH;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.user = self.user;
    if (indexPath.row == 0) {
        cell.haveHeader = YES;
        cell.haveTime = YES;
    }else{
        cell.haveHeader = [self haveHeader:indexPath];
        cell.haveTime = [self havetime:indexPath];
    }
     cell.message = self.dataSource[indexPath.row];

    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"%f",[self getTableCellHeight:indexPath]);
    return [self getTableCellHeight:indexPath];
}


- (CGFloat)getTableCellHeight:(NSIndexPath *)indexPath
{
    EMMessage * message = self.dataSource[indexPath.row];

   static CGFloat timeHeight;
   static CGFloat headerHeight;
    
    if (indexPath.row==0) {
        timeHeight =  Height(50);
        headerHeight =  Height(25);
        if (message.body.type == EMMessageBodyTypeText) {
            CGFloat height = [((EMTextMessageBody *)message.body).text sizeWithAttributes:@{NSFontAttributeName:Font(13)}].height+Height(20);
          
            return  timeHeight + headerHeight  + height + Height(20);
        }else{
            return timeHeight + headerHeight + Height(105) + Height(20);
        }
    }else{
        if (![self haveHeader:indexPath]) {
            headerHeight = 0;
        }else{
            headerHeight =  Height(25);
        }
        if ([self havetime:indexPath]) {
            timeHeight =  Height(50);
        }else{
            timeHeight = 0;
        }

        if (message.body.type == EMMessageBodyTypeText) {
            CGFloat height = [((EMTextMessageBody *)message.body).text sizeForFont:Font(13) size:CGSizeMake(Width(250)-Width(30),0) mode:(NSLineBreakByWordWrapping)].height;
            
        return timeHeight + headerHeight + height + Height(20) + Height(20);
        }else{
            return timeHeight + headerHeight + Height(105) + Height(20);
        }
    }
    
    
}

- (BOOL)havetime:(NSIndexPath *)indexPath
{
    EMMessage * message = self.dataSource[indexPath.row];
    EMMessage * headMessage = self.dataSource[indexPath.row-1];
    
    return (message.timestamp-headMessage.timestamp)>3600*1000;
}
- (BOOL)haveHeader:(NSIndexPath *)indexPath
{
    EMMessage * message = self.dataSource[indexPath.row];
    EMMessage * headMessage = self.dataSource[indexPath.row-1];
  
    return ![headMessage.from isEqualToString:message.from];
}






#pragma mark -- 选择照片

- (void)selectPhoto{
    [self.view endEditing:YES];
   
    [[Singleton shareSingleton] getPhotoViewController:self];
}

#pragma mark - 获取相片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    EMImageMessageBody *imageMsg = [[EMImageMessageBody alloc] initWithData:data thumbnailData:data];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:Defaults(User_Mobile) to:self.conversation.conversationId body:imageMsg ext:nil];
    
    message.isRead =  YES;

    [[MessageHelper shareHelper] sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        [self.dataSource addObject:message];
        [self.tableView reloadData];
        [self.tableView scrollToRow:self.dataSource.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
    }];
  
    
}

@end
