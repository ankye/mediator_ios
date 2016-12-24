//
//  AKNewsManager.m
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsManager.h"
#import "GVUserDefaults+NewsModule.h"
#import "AKNewsChannel.h"

@implementation AKNewsManager

@synthesize selectedChannels = _selectedChannels;
@synthesize unSelectedChannels = _unSelectedChannels;

SINGLETON_IMPL(AKNewsManager)

-(NSMutableArray*)selectedChannels
{
    if(_selectedChannels == nil){
        NSData* data = [GVUserDefaults standardUserDefaults].hNewsSelectedChannels;
        _selectedChannels =(NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(_selectedChannels == nil){
            NSMutableArray* channels =  [[NSMutableArray alloc] init];
             [channels addObject: [[AKNewsChannel alloc] initWithChannel:@"1" withName:@"推荐" withFixed:YES]];
  
            [self setSelectedChannels:channels];
        }
        
        [AK_REQUEST_MANAGER news_requestChannelListWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSData* jsonData = request.responseData;
            NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
            NSArray *list = response[@"returnData"][@"kindList"] ;
            NSMutableArray* channels = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in list) {
                NSInteger channelID = [dic[@"kindId"] integerValue];
                AKNewsChannel* channel = [[AKNewsChannel alloc] initWithChannel:[NSString stringWithFormat:@"%ld",(long)channelID] withName:dic[@"name"] withFixed:NO];
                [channels addObject:channel];
            }
            if(channels && [channels count]>0){
                [self setSelectedChannels:channels];
            }
            
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];

    }
    return _selectedChannels;
}


-(NSMutableArray*)unSelectedChannels
{
    if(_unSelectedChannels == nil){
        NSData* data = [GVUserDefaults standardUserDefaults].hNewsUnSelectedChannels;
        _unSelectedChannels =(NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(_unSelectedChannels == nil){
            _unSelectedChannels =  [[NSMutableArray alloc] init];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"5" withName:@"热点" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"6" withName:@"小说" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"7" withName:@"电影" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"8" withName:@"时尚" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"9" withName:@"旅游" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"10" withName:@"手机" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"11" withName:@"图片" withFixed:NO]];
            [_unSelectedChannels addObject: [[AKNewsChannel alloc] initWithChannel:@"12" withName:@"动漫" withFixed:NO]];
            
            [GVUserDefaults standardUserDefaults].hNewsUnSelectedChannels = [NSKeyedArchiver archivedDataWithRootObject:_unSelectedChannels];
        }
    }
    return _unSelectedChannels;

}

-(void)setSelectedChannels:(NSMutableArray *)selectedChannels
{
    _selectedChannels = selectedChannels;
    [GVUserDefaults standardUserDefaults].hNewsSelectedChannels = [NSKeyedArchiver archivedDataWithRootObject:_selectedChannels];
;
    AK_SIGNAL_MANAGER.onNewsSelectedChannelChange.fire(selectedChannels);
    
}
-(void)setUnSelectedChannels:(NSMutableArray *)unSelectedChannels
{
    _unSelectedChannels = unSelectedChannels;
    [GVUserDefaults standardUserDefaults].hNewsUnSelectedChannels = [NSKeyedArchiver archivedDataWithRootObject:_unSelectedChannels];
;
    AK_SIGNAL_MANAGER.onNewsUnSelectedChannelChange.fire(_unSelectedChannels);
    
}

@end
