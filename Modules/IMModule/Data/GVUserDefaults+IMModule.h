//
//  GVUserDefaults+IMModule.h
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (IMModule)

@property (nonatomic, weak) NSMutableArray *imServerList;
@property (nonatomic, weak) NSString*       imToken;
@property (nonatomic, weak) NSNumber*       imTime;
@end
