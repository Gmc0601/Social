#import <UIKit/UIKit.h>

#pragma mark ----------BaseInfo----------
UIKIT_EXTERN NSString *const XFAMapKey;                 // 高德地图key

#pragma mark ----------Url----------
UIKIT_EXTERN NSString *const XFCircleHotUrl;            // 缘分圈热度----
UIKIT_EXTERN NSString *const XFCircleNearUrl;           // 缘分圈附近----
UIKIT_EXTERN NSString *const XFCircleMyFollowUrl;       // 缘分圈我的关注----
UIKIT_EXTERN NSString *const XFCircleNewUrl;            // 缘分圈最新----
UIKIT_EXTERN NSString *const XFCirclePublishUrl;        // 缘分圈发布动态********
UIKIT_EXTERN NSString *const XFCircleDetailUrl;         // 缘分圈详情----
UIKIT_EXTERN NSString *const XFCircleSendCommentUrl;    // 缘分圈发布评论---
UIKIT_EXTERN NSString *const XFCircleSuggestUrl;        // 缘分圈推荐区域---
UIKIT_EXTERN NSString *const XFCircleShareUrl;          // 缘分圈分享页面
UIKIT_EXTERN NSString *const XFCircleZanUrl;            // 缘分圈点赞--- type 点赞动作 1 点赞 2取消点赞
UIKIT_EXTERN NSString *const XFCircleRewardUrl;         // 缘分圈打赏********
UIKIT_EXTERN NSString *const XFCircleFollowUrl;         // 缘分圈关注---
UIKIT_EXTERN NSString *const XFCircleCommentListUrl;    // 缘分圈详情评论列表---

UIKIT_EXTERN NSString *const XFFriendHomeUrl;           // 有缘人首页---
UIKIT_EXTERN NSString *const XFFriendInfoUrl;           // 有缘人个人资料---
UIKIT_EXTERN NSString *const XFFriendCircleUrl;         // 有缘人缘分圈---
UIKIT_EXTERN NSString *const XFFriendAlbumUrl;          // 有缘人相册---
UIKIT_EXTERN NSString *const XFFriendSuggestMoneyUrl;   // 有缘人建议诚意金---
UIKIT_EXTERN NSString *const XFFriendFollowUrl;         // 有缘人关注---
UIKIT_EXTERN NSString *const XFFriendMapUrl;            // 有缘人地图交友********

UIKIT_EXTERN NSString *const XFMyAccountUrl;            // 我的账户---
UIKIT_EXTERN NSString *const XFMySignUrl;               // 我的个性签名---
UIKIT_EXTERN NSString *const XFMyBasicInfoUpdateUrl;    // 我的基本信息修改---
UIKIT_EXTERN NSString *const XFMyPersonalInfoUpdateUrl; // 我的个人信息修改---
UIKIT_EXTERN NSString *const XFMyMinuteInfoUpdateUrl;   // 我的详细信息修改---
UIKIT_EXTERN NSString *const XFMyAlbumUrl;              // 我的相册---
UIKIT_EXTERN NSString *const XFMyCircleUrl;             // 我的缘分圈---
UIKIT_EXTERN NSString *const XFMyCharmUrl;              // 我的魅力值---
UIKIT_EXTERN NSString *const XFMyFollowUrl;             // 我的关注用户---
UIKIT_EXTERN NSString *const XFMyFansUrl;               // 关注我的用户---
UIKIT_EXTERN NSString *const XFMyFriendsUrl;            // 互相关注的用户---
UIKIT_EXTERN NSString *const XFMyBindAlipayUrl;         // 绑定支付宝---
UIKIT_EXTERN NSString *const XFMyTXUrl;                 // 提现---
UIKIT_EXTERN NSString *const XFMyTradeRecordUrl;        // 交易记录---
UIKIT_EXTERN NSString *const XFMyRechrgeUrl;            // 我的积分充值---
UIKIT_EXTERN NSString *const XFMyRechrgeOrderUrl;       // 积分购买生成订单
UIKIT_EXTERN NSString *const XFMyUserAgreementUrl;      // 用户协议--
UIKIT_EXTERN NSString *const XFMyCharmRuleUrl;          // 我的魅力值规则说明---
UIKIT_EXTERN NSString *const XFMyCarUpdateUrl;          // 我的详细信息车产修改---
UIKIT_EXTERN NSString *const XFMyHouseUpdataUrl;        // 我的详细信息房产修改---
UIKIT_EXTERN NSString *const XFMyInfoUrl;               // 获取用户信息---
UIKIT_EXTERN NSString *const XFMyAliPayBackUrl;         // 支付宝回调---没有界面需求
UIKIT_EXTERN NSString *const XFMyAlbumDeleteUrl;        // 我的相册删除
UIKIT_EXTERN NSString *const XFMyAlbumUploadUrl;        // 我的相册上传
UIKIT_EXTERN NSString *const XFMyHouseCheckUrl;         // 我的房产审核---
UIKIT_EXTERN NSString *const XFMyCarCheckUrl;           // 我的车产审核---
UIKIT_EXTERN NSString *const XFMyCircleDeleteUrl;       // 我的缘分圈删除---
UIKIT_EXTERN NSString *const XFMyBuyIntegralSuccessUrl; // 购买积分成功
UIKIT_EXTERN NSString *const XFMyRecharegListUrl;       // 我的充值选择列表----
UIKIT_EXTERN NSString *const XFMyIntegralDetailUrl;     // 我的可提现积分与不可提现积分---
UIKIT_EXTERN NSString *const XFMyAboutUsUrl;            // 关于我们---
UIKIT_EXTERN NSString *const XFPushSettingUrl;          // 我的聊天延迟设置显示
UIKIT_EXTERN NSString *const XFResetPushSettingUrl;     // 我的聊天延迟申请
UIKIT_EXTERN NSString *const XFAlipayPayUrl;            // 支付宝支付
UIKIT_EXTERN NSString *const XFApplyChatUrl;            // 有缘人申请聊天

#pragma mark ----------Const Str----------
UIKIT_EXTERN NSString *const XFDefaultPageSize;

#pragma mark - -------------------Notification-------------------
UIKIT_EXTERN NSString *const XFBindAliPaySuccessNotification;
UIKIT_EXTERN NSString *const XFLoginSuccessNotification;
UIKIT_EXTERN NSString *const XFLogoutSuccessNotification;

#pragma mark - -------------------UserDefault-------------------
UIKIT_EXTERN NSString *const XFCurrentLatitudeKey;
UIKIT_EXTERN NSString *const XFCurrentLongitudeKey;
UIKIT_EXTERN NSString *const XFCurrentCityKey;
UIKIT_EXTERN NSString *const XFCloseSuggestKey;

#pragma mark ----------Const Num----------
UIKIT_EXTERN CGFloat const XFNavHeight;
UIKIT_EXTERN CGFloat const XFTabHeight;
UIKIT_EXTERN CGFloat const XFCircleTabHeight;
UIKIT_EXTERN CGFloat const XFFriendFilterHeight;
UIKIT_EXTERN CGFloat const XFCircleDetailBottomHeight;
UIKIT_EXTERN CGFloat const XFFriendBottomChatHeight;

