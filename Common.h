/*********************************************************************
 * 版权所有   成都阿普匠科技<<<<apj_Zzz>>>>
 *
 * 文件名称： common
 * 内容摘要： 公用类、方法
 * 其它说明： 头文件
 * 作 成 者： ZGD
 * 完成日期： 2016年08月04日
 * 修改记录1：
 * 修改日期：
 * 修 改 人：
 * 修改内容：
 * 修改记录2：
 **********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
// 聊天消息间距
#define CHAT_MARGIN 5

#define ZZZRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ZZZIMG(name) [UIImage imageNamed:name]

#define VIEW_BGCOLOR    ZZZRGB(240, 240, 240)


//线条颜色
#define MT_LINE_COLOR [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]
//cell颜色
#define MT_CELL_COLOR [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1]

#define kContentFontSize        16.0f   //内容字体大小
#define MSGFONT  [UIFont systemFontOfSize:kContentFontSize]


#define WEB_HOST @"http://happy.appjobs.cc"

#define API_KEY @"56ab24c15b72a457069c5ea42fcfc640"

//--------- 通知相关  ---------
// 需要刷新时间
#define TimeCountUpDate @"noticeUpdateTime"
//需要刷新历史数据
#define TimeNoticeUpdate @"historyShouldUpdate"
//历史刷新延迟10秒
#define TimeDelayToUpdate 65
// 截止投注提前时间
#define TimeBettingStop  60

// 投注成功跳转
#define BettingSuccessClose @"bettingSuccessClose"

// 投注截止相关
#define BettingStopNotice @"bettingStopNotice"

/**  判断文字中是否包含表情 */
#define IsTextContainFace(text) [text containsString:@"["] &&  [text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]

#define kPadding                5.0f    //控件间隙
#define kImgPadding            15.0f    //图片间隙
#define kEdgeInsetsWidth       20.0f   //内容内边距宽度
#define kImgMaxWidth           (SCREEN_WIDTH - 200.0f) // 图片最大宽度
#define kImgMaxHeight          300.0f // 图片最大高度

@class MessageData;

typedef void  (^APJBlock)(void);//完成通知回调

// 点击按钮回调 --- 无返回
typedef void (^APJClickBtnBlock)(NSInteger index);

// 点击按钮回调 --- 有返回
typedef void (^APJClickBlock)(id aDict,NSInteger index);

// 请求回调
typedef void (^APJRequestBlock)(id aDict,int errCode);

typedef NS_ENUM(NSUInteger,HCUploadType) {
    HCUploadTypeJPG = 1,// 图片
    HCUploadTypeMP4 ,// 视频
    HCUploadTypeGif // gif
};
@interface Common : NSObject

+ (Common *)shareInstence;


/***********************************************************************
 * 方法名称： + (BOOL) isBlankString:(NSString *)string
 * 功能描述： 判断字符串string是否为空
 * 输入参数：
 * 输出参数：
 * 返 回 值：BOOL
 ***********************************************************************/
+ (BOOL)isBlankString:(NSString *)string;

// 获取当前时间 yMdhmsS
+ (NSString *)getSystemTime;
+(NSString *)getMediaVideoUrl;
+(int)getMonthDayByYM:(NSString *)YM;
+(NSString *)getSystemTime:(NSString *)ymd;
// 获取当前时间戳
+(NSString *)getTimeSinceNow;

+(NSString *)formatTimeWithStr:(NSString *)dateStr;

// 缩放图片
+(CGSize)zoomImageSize:(CGSize)size;

//转换成时分秒
+ (NSString *)timeFormatted:(int)totalSeconds;

// 缓存地址
+ (NSString *)libCachePath;

// 得到消息框的大小
+(CGSize)msgSizeWithString:(NSString *)str;
+(CGSize)msgSizeWithString:(NSString *)str font:(UIFont *)font limit:(CGSize)size;

//textfiled 左边padding
+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth;

// 获取消息id messageid
+(NSString *)getMessageId;

// af接口封装get
+(void)requestGET:(NSString *)action params:(NSDictionary *)params block:(APJRequestBlock)block;

// af接口封装post
+(void)requestPOST:(NSString *)action params:(NSDictionary *)params block:(APJRequestBlock)block;

// 计算sign
+(NSString *)getSignStr:(NSDictionary *)aDict;

// MD5加密方法
+ (NSString *)md5WithString:(NSString *)input;

// 验证手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 判断等级并添加光环
+ (void)imageAddLevel:(UIImageView *)aImageView;

// json 转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//判断文件是否已经在沙盒中已经存在？
+(BOOL) isFileExist:(NSString *)fileName;

// 添加到本地
+(BOOL)addGifLocal:(NSData *)tGif;
// 删除本地图片
+(void)deleGifLocal:(NSString *)imgPath;

// 查询所有图片
+(NSArray *)getLocalGif;


+(BOOL)isGifSource:(NSData *)imgData;

/**
 *计算开奖结果标注
 */
+(NSDictionary *)calResults:(NSArray *)numsArr;

/**
 *计算当前期号
 */
+(NSString *)getCurrentPeriod;

/**
 *计算期号
 */
+(NSString *)getCurrentPeriodSix;

/**
 *计算期号
 */
+(NSString *)getPeriodByType:(NSString *)cType;
/**
 *根据type获取当前中奖类型
 */
+(NSString *)getTypeNameByKey:(NSString *)tKey;

+(NSArray *)arrayWithJsonString:(NSString *)jsonString;

+ (NSString *) md5:(NSString *) input;

+(void)checkVersionBlock:(APJRequestBlock)xBlock;
@end
