

#import <Foundation/Foundation.h>

@protocol AKUserChatSettingProtocol <NSObject>


@property (nonatomic, strong) NSString *userID;
//是否置顶
@property (nonatomic, assign) BOOL top;
//免打扰
@property (nonatomic, assign) BOOL noDisturb;
//聊天背景
@property (nonatomic, strong) NSString *chatBGPath;

@end
