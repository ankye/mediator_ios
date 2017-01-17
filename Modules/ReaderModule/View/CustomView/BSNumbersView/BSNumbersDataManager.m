//
//  BSNumbersDataManager.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersDataManager.h"
#import "NSObject+BSNumbersExtension.h"
#import "NSString+BSNumbersExtension.h"
@interface BSNumbersDataManager ()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *flatData;

- (void)setupFlatData;

- (void)configureData;
- (void)caculateWidths;

@end

@implementation BSNumbersDataManager

#pragma mark - Override


#pragma mark - Private

- (void)setupFlatData {
    NSMutableArray *flatData = @[].mutableCopy;
    if (self.headerData) {
        [flatData addObject:self.headerData];
    }
    if (self.bodyData) {
        for (NSObject *bodyData in self.bodyData) {
            [flatData addObject:[bodyData getPropertiesValues]];
        }
    }
    self.flatData = flatData.copy;
}

- (void)configureData {
    NSMutableArray *bodyFreezeData = @[].mutableCopy;
    NSMutableArray *bodySlideData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.flatData.count; i ++) {
        
        NSMutableArray *freezeCollectionViewSectionFlatData = @[].mutableCopy;
        NSMutableArray *slideCollectionViewSectionFlatData = @[].mutableCopy;
        
        NSArray<NSString *> *flatData = self.flatData[i];
        
        for (NSInteger j = 0; j < flatData.count; j ++) {
            
            NSString *value = flatData[j];
            
            if (j < self.freezeColumn) {
                [freezeCollectionViewSectionFlatData addObject:value];
            } else {
                [slideCollectionViewSectionFlatData addObject:value];
            }
        }
        [bodyFreezeData addObject:freezeCollectionViewSectionFlatData];
        [bodySlideData addObject:slideCollectionViewSectionFlatData];
        
    }
    
    if (self.headerData) {
        _headerFreezeData = bodyFreezeData.firstObject;
        _headerSlideData = bodySlideData.firstObject;
        
        _bodyFreezeData = [bodyFreezeData subarrayWithRange:NSMakeRange(1, bodyFreezeData.count - 1)];
        _bodySlideData = [bodySlideData subarrayWithRange:NSMakeRange(1, bodyFreezeData.count - 1)];
    } else {
        _bodyFreezeData = bodyFreezeData.copy;
        _bodySlideData = bodySlideData.copy;
    }

}

- (void)caculateWidths {
    NSMutableArray<NSString *> *freezeItemSize = @[].mutableCopy;
    NSMutableArray<NSString *> *slideItemSize = @[].mutableCopy;

    _freezeWidth = 0;
    _slideWidth = 0;
    
    NSInteger columnsCount = self.flatData.firstObject.count;
    
    //遍历列
    for (NSInteger i = 0; i < columnsCount; i ++) {
        
        CGFloat columnMaxWidth = 0;
        
        //遍历行
        for (NSInteger j = 0; j < self.flatData.count; j ++) {
            
            NSString *columnValue = self.flatData[j][i];
            
            CGSize size = [columnValue sizeWithFont:self.slideBodyFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            if (j == 0) {
                size = [columnValue sizeWithFont:self.headerFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            }
            
            CGFloat targetWidth = size.width + 2 * self.itemTextHorizontalMargin;
            
            if (targetWidth >= columnMaxWidth) {
                columnMaxWidth = targetWidth;
            }
            
            columnMaxWidth = floor(MAX(self.minItemWidth, MIN(self.maxItemWidth, columnMaxWidth)));
        }
        
        if (i < self.freezeColumn) {
            [freezeItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight - 1))];
            _freezeWidth += columnMaxWidth;
        } else {
            [slideItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight - 1))];
            _slideWidth += columnMaxWidth;
        }
    }
    
    _freezeItemSize = freezeItemSize.copy;
    _slideItemSize = slideItemSize.copy;
}

#pragma mark - Public

- (void)caculate {
    [self configureData];
    [self caculateWidths];
}

#pragma mark - Setter

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    [self setupFlatData];
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    [self setupFlatData];
}

#pragma mark - Getter
@end
