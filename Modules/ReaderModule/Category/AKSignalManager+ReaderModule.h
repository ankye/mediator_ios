//
//  AKSignalManager+ReaderModule.h
//  Project
//
//  Created by ankye on 2017/2/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKSignalManager.h"

@interface AKSignalManager (ReaderModule)


//书架数据变更
@property (nonatomic, readwrite) UBSignal<MutableArraySignal> *onBookShelfChange;

@end
