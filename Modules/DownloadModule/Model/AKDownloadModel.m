//
//  MusicModel.m
//  test
//
//  Created by chuanshuangzhang chuan shuang on 16/2/23.
//  Copyright © 2016年 chuanshuangzhang. All rights reserved.
//

#import "AKDownloadModel.h"

@implementation AKDownloadModel

-(BOOL)isCompleted
{
    if(self.progress >= 1.0f){
        return YES;
    }else{
        return NO;
    }
}
@end
