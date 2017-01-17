//
//  UICollectionView+Category.m
//  powerlife
//
//  Created by 陈行 on 16/6/6.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "UICollectionView+Category.h"

@implementation UICollectionView (Category)

- (id)collectionViewCellByNibWithIdentifier:(NSString *)identifier andIndexPath:(NSIndexPath *)indexPath{
    UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
    UICollectionViewCell * cell=[self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

@end
