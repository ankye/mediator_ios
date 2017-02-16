//
//  AKDataObjectProtocol.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
@protocol AKDataObjectProtocol <NSObject>



/**
 填充数据，禁止直接覆盖
 @param object 填充数据
 */
-(void)fillData:(id<AKDataObjectProtocol>)object;

-(void)resultSetToModel:(FMResultSet*)set;

-(NSArray*)modelToDBRecord;

-(NSArray*)modelDBProperties;

@end


