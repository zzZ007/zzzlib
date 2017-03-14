/*********************************************************************
 * 版权所有   magic_Zzz
 *
 * 文件名称： UserData.h 用户数据存储实体
 * 内容摘要： 用户数据存储实体
 * 其它说明： 实现文件
 * 作 成 者： ZGD
 * 完成日期： 2016年03月08日
 * 修改记录1：
 * 修改日期：
 * 修 改 人：
 * 修改内容：
 * 修改记录2：
 **********************************************************************/

#import "UserData.h"

#import "MJExtension.h"
#import "Common.h"

@implementation UserData


static UserData *sui;

/***********************************************************************
* 方法名称： +(UserData *)getUserData
* 功能描述： 获取静态的用户信息
* 输入参数：
* 输出参数：
* 返 回 值：
***********************************************************************/
+ (UserData *)getUserData
{
    @synchronized(self) {
        if (!sui)
        {
            sui = [[UserData alloc] init];
        }

        return sui;
    }
}


/***********************************************************************
* 方法名称： - (void)initUserData:(NSDictionary *)userDict
* 功能描述： 登录时初始化Data
* 输入参数：
* 输出参数：
* 返 回 值：
***********************************************************************/
- (void)initUserData:(NSDictionary *)userDict
{
    sui = [UserData mj_objectWithKeyValues:userDict];
    
    sui.uid = userDict[@"id"];
    if (!userDict[@"face"]) {
        sui.face = @"chatListCellHead";
    }
    sui.userlist = [NSArray array];
}

// 是否登录
-(BOOL)isLogin
{
    if ([Common isBlankString:sui.uid]) {
        return NO;
    }
    return YES;
}

- (void)signOutUser
{
    NSUserDefaults *userLogin = [NSUserDefaults standardUserDefaults];
    [userLogin removeObjectForKey:@"password"];
   
    sui.uid = nil;
    sui.uuid = nil;
    sui.groupid = nil;
    sui.username = nil;
    sui.type = nil;
    sui.nickname = nil;
    sui.realname = nil;
    sui.balance = nil;
    sui.qqnumber = nil;
    sui.phone = nil;
}

@end
