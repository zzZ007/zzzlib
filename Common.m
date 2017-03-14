/*********************************************************************
 * 版权所有   成都阿普匠科技<<<<apj_Zzz>>>>
 *
 * 文件名称： common
 * 内容摘要： 公用类、方法
 * 其它说明： 实现文件
 * 作 成 者： ZGD
 * 完成日期： 2016年08月04日
 * 修改记录1：
 * 修改日期：
 * 修 改 人：
 * 修改内容：
 * 修改记录2：
 **********************************************************************/

#import "Common.h"
#import "UserData.h"
#import "AFNetworking.h"
#import <ImageIO/ImageIO.h>
#import "Base64.h"
#import "UIImage+GIF.h"
#import "UIImage+MultiFormat.h"
#import <CommonCrypto/CommonDigest.h>  
#import <AdSupport/AdSupport.h>

static Common *sui;
@implementation Common

+ (Common *)shareInstence
{
    @synchronized(self) {
        if (!sui)
        {
            sui = [[Common alloc] init];
        }
        
        return sui;
    }
}


/***********************************************************************
 * 方法名称： + (BOOL) isBlankString:(NSString *)string
 * 功能描述： 判断字符串string是否为空
 * 输入参数：
 * 输出参数：
 * 返 回 值：BOOL
 ***********************************************************************/
+ (BOOL)isBlankString:(NSString *)string
{
    if ((string == nil) || (string == NULL))
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    
    return NO;
}

+(int)getMonthDayByYM:(NSString *)YM{
    
    NSString *tempyear=[YM substringFromIndex:4];
    NSString *tempmonth=[YM substringToIndex:4];
    int rint=30;
    int intyear=[tempmonth intValue];
    int intmonth=[tempyear intValue];
    
    if(intmonth==1||intmonth==3||intmonth==5||intmonth==7||intmonth==8||intmonth==10||intmonth==12){
        rint=31;
    }
    if(intmonth==2){
        if((intyear%400==0)||(intyear%4==0&&intyear%100!=0)){
            rint=29;
        }else{
            rint=28;
        }
    }
    
    // NSLog(@"getMonthDayByYM  r:%d i:%@",rint,YM);
    
    return rint;
}
+(NSString *)getSystemTime:(NSString *)ymd{
    NSDate * senddate=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSInteger hour = [conponent hour];
    NSInteger minute = [conponent minute];
    
    if([ymd isEqualToString:@"year"]){
        return [NSString stringWithFormat:@"%d",(int)year];
    }
    if([ymd isEqualToString:@"month"]){
        return [NSString stringWithFormat:@"%02d",(int)month];
    }
    if([ymd isEqualToString:@"day"]){
        return [NSString stringWithFormat:@"%02d",(int)day];
    }
    if([ymd isEqualToString:@"hour"]){
        NSLog(@"当前时间:%d",(int)hour);
        return [NSString stringWithFormat:@"%02d",(int)hour];
    }
    if([ymd isEqualToString:@"minute"]){
        return [NSString stringWithFormat:@"%02d",(int)minute];
    }
    return @"0";
}
+(NSString *)getTimeSinceNow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    return timeString;
}

+ (NSString *)getSystemTime
{
    NSDate *senddate                = [NSDate date];
    
    NSDateFormatter *dateformatter  = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    
    NSString *locationString        = [dateformatter stringFromDate:senddate];
    return locationString;
}

+ (NSString *)libCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"gifCache/"];
}

+(NSString *)formatTimeWithStr:(NSString *)dateStr
{
    NSTimeInterval time=[dateStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+(NSString *)getMessageId
{
    NSString *time = [Common getSystemTime];
    NSString *lastId = [NSString stringWithFormat:@"%@-%@",@"ios",time];
    return lastId;
}
// 定义成方法方便多个label调用 增加代码的复用性
+(CGSize)msgSizeWithString:(NSString *)str
{// 10 + 40 + 5 头像间距 = 55 , 边距 10 10 10 10
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 110 - 20, 2048)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: MSGFONT}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

+(CGSize)msgSizeWithString:(NSString *)str font:(UIFont *)font limit:(CGSize)size
{
    CGRect rect = [str boundingRectWithSize:size//限制最大的宽度和高度
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                 attributes:@{NSFontAttributeName: font}//传人的字体字典
                                    context:nil];
    
    return rect.size;
}
 

//max kImgMaxWidth
+(CGSize)zoomImageSize:(CGSize)aSize
{
    NSLog(@"传入的scale :%f",aSize.width/aSize.height);
    if (aSize.width < 0.0001 || aSize.height < 0.0001) {// 意外情况
        return CGSizeMake(80, 80);
    }
    CGFloat maxW = SCREEN_WIDTH - 100.0f;
    CGFloat maxH = 300.0f;
    CGFloat scale = aSize.width/aSize.height;
    
    if (aSize.width <= maxW && aSize.height <= maxH) {
        return aSize;
    }
    else if (aSize.width > maxW && aSize.height <= maxH)
    {
        return CGSizeMake(maxW, maxW / scale);
    }
    else if (aSize.width <= maxW && aSize.height > maxH)
    {
        return CGSizeMake(maxH * scale, maxH);
    }
    else if (aSize.width > maxW && aSize.height > maxH)
    {
        CGFloat tmpW = maxH * scale;
        NSLog(@"max w :%f---%f",maxW,tmpW);
        if (tmpW - maxW > 0.000001) {
            
            return CGSizeMake(maxW, maxW/scale);
        }else{
            NSLog(@"max 222w :%f---%f",maxW,maxW/scale);
            return CGSizeMake(maxH * scale, maxH);
        }
        
    }
    
    return CGSizeMake(80, 80);
}

+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}



//转换成时分秒

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    if (totalSeconds < 3600) {
        return [NSString stringWithFormat:@"%02d : %02d", minutes, seconds];
    }
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

// af接口封装get
+(void)requestGET:(NSString *)action params:(NSDictionary *)params block:(APJRequestBlock)block
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",WEB_HOST,action];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary *lastParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [lastParams setObject:API_KEY forKey:@"api_key"];
    [manager GET:urlStr parameters:lastParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,0);
    }];
}

// af接口封装post
+(void)requestPOST:(NSString *)action params:(NSDictionary *)params block:(APJRequestBlock)block
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",WEB_HOST,action];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary *lastParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [lastParams setObject:API_KEY forKey:@"api_key"];
    [manager POST:urlStr parameters:lastParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        block(nil,0);
    }];
}


// 计算sign
+(NSString *)getSignStr:(NSDictionary *)aDict
{
    NSArray *keys = [aDict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *midStr = @"";
    
    for (int i=0; i<sortedArray.count; i++) {
        NSString *keyStr = sortedArray[i];
        NSString *valStr = aDict[keyStr];
        midStr = [NSString stringWithFormat:@"%@%@%@",midStr,keyStr,valStr];
    }
    
    NSString *lastStr = [NSString stringWithFormat:@"%@%@%@",API_KEY,midStr,API_KEY];
    
    return [Common md5WithString:lastStr];
}

// MD5加密方法
+ (NSString *)md5WithString:(NSString *)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}
// 判断等级并添加光环
+ (void)imageAddLevel:(UIImageView *)aImageView
{
    CGFloat tSizeWidth = aImageView.frame.size.width + 6;
    UIImage *imgLevel = [UIImage imageNamed:@"userLevel1"];
    CGFloat tSizeHeight = imgLevel.size.height*tSizeWidth / imgLevel.size.width;
    
    UIImageView *levelImg = [[UIImageView alloc]initWithFrame:CGRectMake(-3, -3, tSizeWidth, tSizeHeight)];
    levelImg.image = imgLevel;
    [aImageView addSubview:levelImg];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

// 添加到本地
+(BOOL)addGifLocal:(NSData *)tGif
{
    UIImage *imgTmp = [UIImage sd_imageWithData:tGif];
    
    if (!tGif) {
        
        return NO;
    }
    NSString *path = [Common libCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建附件存储目录
    if (![fileManager fileExistsAtPath:path]) {
         [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *sufStr = @"jpg";
    BOOL     flag = NO;
    
    if ([imgTmp isGIF]) {
        NSLog(@"是gif文件");
        sufStr = @"gif";
        flag   = YES;
    }
    
    NSString *gifName = [NSString stringWithFormat:@"%@.%@",[Common getSystemTime],sufStr];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,gifName];
    
    
    return [fileManager createFileAtPath:filePath contents:tGif attributes:nil];
  
}

// 删除本地图片
+(void)deleGifLocal:(NSString *)imgPath
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:imgPath error:nil];
    NSString *path = [Common libCachePath];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [dataDict removeObjectForKey:imgPath];
    [dataDict  writeToFile:path atomically:YES];
}

//判断文件是否已经在沙盒中已经存在？
+(BOOL) isFileExist:(NSString *)fileName
{
    NSString *path = [Common libCachePath];
    
    NSRange foundObj=[fileName rangeOfString:path options:NSCaseInsensitiveSearch];
    
    if(foundObj.length>0) {
        return YES;
    } else {
        return  NO;
    }
}

+(BOOL)isGifSource:(NSData *)imgData
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imgData,
                                                                (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
    // Early return on failure!
    if (!imageSource) {
        return NO;
    }
    
    // Early return if not GIF!
    CFStringRef imageSourceContainerType = CGImageSourceGetType(imageSource);
    BOOL isGIFData = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
    if (!isGIFData) {
        
        return NO;
    }
    return YES;
}

 
+(NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", digest[i]];
    
    
    
    return  output;
    
}

/**
 *获取版本
 */
+(void)checkVersionBlock:(APJRequestBlock)xBlock
{
    [Common requestPOST:@"/Version/canUse" params:nil block:xBlock];
}

@end
