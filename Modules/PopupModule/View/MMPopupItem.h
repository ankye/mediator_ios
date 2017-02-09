//
//  MMActionItem.h
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MMPopupItemHandler)(NSInteger index);

@interface MMPopupItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, assign)   NSInteger channel;

@end

typedef NS_ENUM(NSUInteger, MMItemType) {
    MMItemTypeNormal,
    MMItemTypeHighlight,
    MMItemTypeDisabled
};

NS_INLINE MMPopupItem* MMItemMake(NSString* title, MMItemType type, NSInteger channel)
{
    MMPopupItem *item = [MMPopupItem new];
    
    item.title = title;
    item.channel = channel;
    
    switch (type)
    {
        case MMItemTypeNormal:
        {
            break;
        }
        case MMItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case MMItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}
