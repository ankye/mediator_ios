//
//  HSelectionList.h
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSelectionListProtocol.h"

typedef NS_ENUM(NSInteger, HSelectionIndicatorStyle) {
    HSelectionIndicatorStyleBottomBar,           // Default
    HSelectionIndicatorStyleButtonBorder,
    HSelectionIndicatorStyleNone
};

typedef NS_ENUM(NSInteger, HSelectionIndicatorAnimationMode) {
    HSelectionIndicatorAnimationModeHeavyBounce,     // Default
    HSelectionIndicatorAnimationModeLightBounce,
    HSelectionIndicatorAnimationModeNoBounce
};

NS_ASSUME_NONNULL_BEGIN

@interface HSelectionList : UIView<HSelectionListProtocol>

/**
    Returns selected button index or -1 if nothing selected.  To animate changing the selected button, use -setSelectedButtonIndex:animated:.
    NOTE: this value will persist between calls to -reloadData.
 */
@property (nonatomic) NSInteger selectedButtonIndex;

@property (nonatomic, weak, nullable) id<HSelectionListDataSource> dataSource;
@property (nonatomic, weak, nullable) id<HSelectionListDelegate> delegate;

@property (nonatomic) CGFloat horizontalMargin;
@property (nonatomic) CGFloat selectionIndicatorHeight;
@property (nonatomic) CGFloat selectionIndicatorHorizontalPadding;
@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, strong) UIColor *bottomTrimColor;

/// Default is NO
@property (nonatomic) BOOL bottomTrimHidden;

/// Default is NO.  If set to YES, the buttons will fade away near the edges of the list.
@property (nonatomic) BOOL showsEdgeFadeEffect;

/// Default is NO.  Centers buttons within the selection list.  Has no effect if the buttons do not fill the space horizontally.
@property (nonatomic) BOOL centerButtons;

/// Default is YES.  Controls how buttons are aligned when centered.  Has no effect if `centerButtons` is NO.
/// When set to YES, buttons will be spaced evenly within the selection list.
/// If NO, buttons will clustered together in the center of the selection list (with the standard button padding between adjacent items).
@property (nonatomic) BOOL evenlySpaceButtons;

/// Default is NO.  If YES, the selected button will be centered on selection.
@property (nonatomic) BOOL centerOnSelection;

/// Default is NO.  If YES, forces the centermost button to be centered after dragging.
@property (nonatomic) BOOL snapToCenter;

/// Default is NO.  If YES, as the user drags the selection list, the central button will automatically become selected.
@property (nonatomic) BOOL autoselectCentralItem;

@property (nonatomic) HSelectionIndicatorAnimationMode selectionIndicatorAnimationMode;

@property (nonatomic) UIEdgeInsets buttonInsets;

@property (nonatomic) HSelectionIndicatorStyle selectionIndicatorStyle;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

- (void)reloadData;

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated;

@end



NS_ASSUME_NONNULL_END
