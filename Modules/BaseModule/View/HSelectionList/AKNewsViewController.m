//
//  AKNewsViewController.m
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsViewController.h"

#import "HSelectionList.h"

@interface AKNewsViewController () <HSelectionListDelegate, HSelectionListDataSource>

@property (nonatomic, strong) HSelectionList *textSelectionList;
@property (nonatomic, strong) NSArray *carMakes;

@property (nonatomic, strong) UILabel *selectedCarLabel;

@end

@implementation AKNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.textSelectionList = [[HSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.textSelectionList.delegate = self;
    self.textSelectionList.dataSource = self;
    
    self.textSelectionList.selectionIndicatorAnimationMode = HSelectionIndicatorAnimationModeLightBounce;
    self.textSelectionList.showsEdgeFadeEffect = YES;
    
    self.textSelectionList.selectionIndicatorColor = [UIColor redColor];
    [self.textSelectionList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.textSelectionList setTitleFont:[UIFont systemFontOfSize:13] forState:UIControlStateNormal];
    [self.textSelectionList setTitleFont:[UIFont boldSystemFontOfSize:13] forState:UIControlStateSelected];
    [self.textSelectionList setTitleFont:[UIFont boldSystemFontOfSize:13] forState:UIControlStateHighlighted];
    
    self.carMakes = @[@"All cars 1",
                      @"Audi 2",
                      @"Bitter 3",
                      @"BMW 4",
                      @"Büssing 5",
                      @"Gumpert 6",
                      @"MAN 7",
                      @"Mercedes-Benz 8",
                      @"Multicar 9",
                      @"Neoplan 10",
                      @"NSU 11",
                      @"Opel 12",
                      @"Porsche 13",
                      @"Robur 14",
                      @"Volkswagen 15",
                      @"Wiesmann 16"];
    
    [self.view addSubview:self.textSelectionList];
    
    self.selectedCarLabel = [[UILabel alloc] init];
    self.selectedCarLabel.text = self.carMakes[self.textSelectionList.selectedButtonIndex];
    self.selectedCarLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectedCarLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectedCarLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectedCarLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    self.textSelectionList.snapToCenter = YES;
}

#pragma mark - HSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HSelectionList *)selectionList {
    return self.carMakes.count;
}

- (NSString *)selectionList:(HSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.carMakes[index];
}

#pragma mark - HSelectionListDelegate Protocol Methods

- (void)selectionList:(HSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
    self.selectedCarLabel.text = self.carMakes[index];
}

@end
