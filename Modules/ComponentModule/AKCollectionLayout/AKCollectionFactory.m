//
//  AKCollectionLayoutFactory.m
//  Project
//
//  Created by ankye on 2017/1/10.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCollectionFactory.h"
#import "AKCollectionLayout.h"
#import "AKCollection2Layout.h"
#import "AKCollection3Layout.h"

@interface AKCollectionFactory()

@property (nonatomic,strong) NSMutableDictionary* cellClassPool;
@property (nonatomic,strong) NSMutableDictionary* cellNibPool;


@end

@implementation AKCollectionFactory

SINGLETON_IMPL(AKCollectionFactory)

-(id)init
{
    self = [super init];
    if(self){
        _cellClassPool = [[NSMutableDictionary alloc] init];
        _cellNibPool = [[NSMutableDictionary alloc] init];

    }
    return self;
}

+(AKCollectionLayout*)createLayout:(CollectionLayoutType)type
{
    switch (type) {
        case CollectionLayoutTypeOneCollum:
            return [[AKCollectionLayout alloc] init];
            break;
        case CollectionLayoutTypeTwoCollum:
            return [[AKCollection2Layout alloc] init];
            break;
        case CollectionLayoutTypeThridCollum:
            return [[AKCollection3Layout alloc] init];
        default:
            return [[AKCollectionLayout alloc] init];
            break;
    }
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [_cellClassPool setObject:cellClass forKey:identifier];
}
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
     [_cellNibPool setObject:nib forKey:identifier];
}


- (void)registerCellsToView:(UICollectionView*)view
{
    for(NSString* key in _cellNibPool){
        [view registerNib:_cellNibPool[key] forCellWithReuseIdentifier:key];
    }
    
    for(NSString* key in _cellClassPool){
        [view registerClass:_cellClassPool[key] forCellWithReuseIdentifier:key];
    }
    
}


@end
