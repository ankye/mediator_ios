//
//  AKCollectionLayoutFactory.h
//  Project
//
//  Created by ankye on 2017/1/10.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKCollectionLayout.h"

typedef enum CollectionLayoutType{
    CollectionLayoutTypeOneCollum = 1,
    CollectionLayoutTypeTwoCollum = 2,
    CollectionLayoutTypeThridCollum = 3,

}CollectionLayoutType;

@interface AKCollectionFactory : NSObject

SINGLETON_INTR(AKCollectionFactory)

+(AKCollectionLayout*)createLayout:(CollectionLayoutType)type;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerCellsToView:(UICollectionView*)view;


@end
