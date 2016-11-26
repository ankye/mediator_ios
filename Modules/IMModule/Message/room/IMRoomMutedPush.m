//
//  IMRoomMutedPush.m
//  BanLiTV
//
//  Created by 栾有数 on 16/5/25.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomMutedPush.h"

static NSString * IMRoomMuted = @"IMRoomMuted";
@implementation IMRoomMutedPush
-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
    NSArray * modelArr = info[1];
    IMRoomMutedPushModel * model = [IMRoomMutedPushModel gotModelFromArr:modelArr];
    if(model){
    [[NSNotificationCenter defaultCenter] postNotificationName:IMRoomMuted object:nil
                                                      userInfo:@{@"data":model}];
    }
    return YES;
}
@end

@implementation IMRoomMutedPushModel

MJExtensionCodingImplementation
+ (IMRoomMutedPushModel *)gotModelFromArr:(NSArray *)arr{
//    @property (strong, nonatomic)NSString * time;               //被禁言时间
//    @property (strong, nonatomic)NSString * toRoomuid;          //目标room_uid
//    @property (strong, nonatomic)NSString * mutedUid;           //被禁言，uid
//    @property (strong, nonatomic)NSString * mutedNick;          //被禁言，昵称
//    @property (strong, nonatomic)NSString * mutedForwarddata;   //被禁言，ud.forwarddata
//    @property (strong, nonatomic)NSString * mutedAvatorUrl;     //被禁言 头像
//    @property (strong, nonatomic)NSString * manager;            //是否是房管 0不是，1是（房管不可以被禁
    IMRoomMutedPushModel * mutedModel = [IMRoomMutedPushModel new];
    if (arr[0]) {
        mutedModel.time         = arr[0];
    }
    if (arr[1]) {
        mutedModel.toRoomuid    = arr[1];

    }
    if (arr[2]) {
        mutedModel.mutedUid     = arr[2];
    }
    if (arr[3]) {
        mutedModel.mutedNick    = arr[3];
    }
    if (arr[4]) {
        mutedModel.mutedForwarddata     = arr[4];
    }
    if (arr[5]) {
        mutedModel.mutedAvatorUrl       = arr[5];
    }
    if (arr[6]) {
        mutedModel.manager              = arr[6];
    }
    return mutedModel;
}
@end