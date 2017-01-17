//
//  AKRequestManager+ReaderModule.h
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@interface AKRequestManager (ReaderModule)

//请求信息
-(BOOL)reader_requestHotListWithPage:(NSInteger)page success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;



@end
