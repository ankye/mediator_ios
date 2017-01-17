//
//  UICollectionView+Category.h
//  powerlife
//
//  Created by 陈行 on 16/6/6.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Category)

- (id)collectionViewCellByNibWithIdentifier:(NSString *)identifier andIndexPath:(NSIndexPath *)indexPath;

@end
