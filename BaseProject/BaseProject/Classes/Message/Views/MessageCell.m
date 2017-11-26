
//
//  MessageCell.m
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import "MessageCell.h"
#import "ChatBalloonView.h"


@interface MessageCell (){
    CGFloat headerHight;
    CGFloat leftW;
    CGFloat timeHight;
}


/* 头像 */
@property (nonatomic, strong) UIImageView *headIcon;
/* 名称 */
@property (nonatomic, strong) YYLabel *nameLB;
/* 聊天气泡 */
@property (nonatomic, strong) ChatBalloonView *balloonView;
/* 加载图片 */
@property (nonatomic, strong) UIImageView *contentImageV;
/* 时间  */
@property (nonatomic, strong) YYLabel *timeLB;
@property (nonatomic) ChatType type;




@end


@implementation MessageCell




+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"message_Cell";//不能一样, 否则重加载
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
    cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = BackGround_Color;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self                = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
//        头像
        self.headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Width(15), 0, Width(48), Width(48))];
        self.headIcon.hidden = YES;
//        名称
        self.nameLB = [[YYLabel alloc] init];
        self.nameLB.hidden = YES;
//        内容
//        图片
        self.contentImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(140), Height(105))];
//        聊天气泡
        self.balloonView  = [[ChatBalloonView alloc] initWithFrame:CGRectMake(0, 0, Width(250), self.contentView.height)];
//        时间
        self.timeLB = [[YYLabel alloc] init];
        self.timeLB.hidden = YES;

        [self.contentView addSubview:self.contentImageV];
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nameLB];
        [self.contentView addSubview:self.balloonView];
        [self.contentView addSubview:self.timeLB];
        
        self.nameLB.font = Font(11);
        self.nameLB.textColor = TEXT_999;
        
        self.timeLB.font = Font(11);
        self.timeLB.textColor = TEXT_999;
        self.timeLB.textAlignment = YYTextVerticalAlignmentCenter;
        
        headerHight = Height(0);
        timeHight = Height(0);
        leftW = (Width(15)+Width(48)+Width(10));
    }
    return self;
}

- (void)setHaveTime:(BOOL)haveTime
{
    _haveTime = haveTime;
    if (haveTime) {
        self.timeLB.hidden = NO;
        self.timeLB.frame = CGRectMake(0, 0, KScreenWidth, Height(50));

        timeHight = Height(50);
    }else{
        self.timeLB.hidden = YES;
        self.timeLB.frame = CGRectMake(0, 0, KScreenWidth, 0);

        timeHight = 0;
    }
}


- (void)setHaveHeader:(BOOL)haveHeader
{
    _haveHeader = haveHeader;
    if (haveHeader) {
        self.headIcon.hidden = NO;
        self.nameLB.hidden = NO;
        headerHight = Height(25);
    }else{
        self.headIcon.hidden = YES;
        self.nameLB.hidden = YES;
        headerHight = 0;
    }
}


- (void)setMessage:(EMMessage *)message
{
    _message = message;
    
    
    if ([message.from isEqualToString: simple_user]&&(message.body.type == EMMessageBodyTypeText)) {
        self.type = ChatTypeMineMsg;
        self.balloonView.text = ((EMTextMessageBody *)message.body).text;

    }else if([message.from isEqualToString: simple_user]&&(message.body.type == EMMessageBodyTypeImage)){
        self.type = ChatTypeMineImg;
        
        EMImageMessageBody *body = (EMImageMessageBody *)message.body;

        
        [self.contentImageV sd_setImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath]];

        
    }else if([message.to isEqualToString: simple_user]&&(message.body.type == EMMessageBodyTypeText)){
        self.type = ChatTypeFriendMsg;
        self.balloonView.text = ((EMTextMessageBody *)message.body).text;
   

    }else if([message.to isEqualToString: simple_user]&&(message.body.type == EMMessageBodyTypeImage)){
        EMImageMessageBody *body = (EMImageMessageBody *)message.body;
        
        [self.contentImageV sd_setImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath]];
        self.type = ChatTypeFriendImg;

    }
    
    self.headIcon.image = [UIImage imageNamed:@"weixin"];
    self.nameLB.text = @"阿萨德飞机";
    
    
    self.timeLB.text = [self getTimeWithInterval:message.timestamp];
    
    self.nameLB.width = kScreenWidth-leftW-Width(15);
    self.nameLB.height = Height(10);
    
    [self setNeedsLayout];
}


#pragma mark -  简单生活。。。
- (NSString *)getTimeWithInterval:(NSTimeInterval)interval{
    
  NSDate *date =  [NSDate dateWithTimeIntervalSince1970:interval];
    if ([date isToday]) {
        return [@"HH:mm" getTimeWithDate:date];
    }else if ([date isYesterday]){
        return [NSString stringWithFormat:@"昨天 %@", [@"HH:mm" getTimeWithDate:date]];

    }else{
        return [@"MM-dd  HH:mm" getTimeWithDate:date];
    }
    
}


- (void)setType:(ChatType)type
{
    _type = type;
    
    if (type == ChatTypeMineMsg) {
        self.headIcon.right = kScreenWidth-Width(15);
        self.nameLB.right = kScreenWidth-leftW;
        self.nameLB.textAlignment = NSTextAlignmentRight;
        self.balloonView.balloonAlignment = ChatBalloonAlignmentRight;
        self.balloonView.right = kScreenWidth-leftW+Width(5);
        
        self.balloonView.hidden = NO;
        self.contentImageV.hidden = YES;
    }else if(type == ChatTypeFriendMsg){
        self.headIcon.left = Width(15);
        self.nameLB.left = leftW;
        self.balloonView.balloonAlignment = ChatBalloonAlignmentLeft;
        self.balloonView.left = leftW-Width(5);
        
        self.balloonView.hidden = NO;
        self.contentImageV.hidden = YES;
    }else if (type == ChatTypeMineImg){
        self.headIcon.right = kScreenWidth-Width(15);
        self.nameLB.right = kScreenWidth-leftW;
        self.contentImageV.right = kScreenWidth-leftW;
        
        self.contentImageV.hidden = NO;
        self.balloonView.hidden = YES;
    }else if (type == ChatTypeFriendImg){
        self.headIcon.left = Width(15);
        self.nameLB.left = leftW;
        self.contentImageV.left = leftW;
        
        self.contentImageV.hidden = NO;
        self.balloonView.hidden = YES;
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.headIcon.layer.cornerRadius = self.headIcon.width/2;
    self.headIcon.clipsToBounds = YES;
    self.headIcon.top = timeHight;
    
    self.balloonView.top = headerHight+timeHight;
    
    self.balloonView.height = self.contentView.height-headerHight-timeHight;
    
    
    
    self.contentImageV.top = headerHight+timeHight;

    self.contentImageV.contentMode = UIViewContentModeScaleAspectFit;
    
    self.contentImageV.backgroundColor = WhiteColor;
    self.contentImageV.layer.cornerRadius = 4;
    self.contentImageV.clipsToBounds = YES;

    self.nameLB.top = timeHight+Height(10);

}














@end
