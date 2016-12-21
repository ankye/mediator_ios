//
//  AKNewsViewController.m
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsViewController.h"
#import "GVUserDefaults+NewsModule.h"

#import "HSelectionList.h"

@interface AKNewsViewController () <HSelectionListDelegate, HSelectionListDataSource>

@property (nonatomic, strong) HSelectionList *hSelectionList;
@property (nonatomic, strong) NSMutableArray *hSelectionChannels;



@end

@implementation AKNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHSelectionList];
}

-(NSMutableArray*)hSelectionChannels
{
    if(_hSelectionChannels == nil){
        _hSelectionChannels = [GVUserDefaults standardUserDefaults].hSelectionChannels;
        
        if(_hSelectionChannels != nil){
            _hSelectionChannels =  [[NSMutableArray alloc] initWithObjects:@"新闻",@"美图",@"美女",@"a1",@"a2",@"a3",@"a4",@"a5",@"a6",@"a7",@"a8",@"a9",@"b4",@"b5",@"b6",@"b7",@"b8",@"b9" ,nil];
            [GVUserDefaults standardUserDefaults].hSelectionChannels = _hSelectionChannels;
        }
    }
    
    return _hSelectionChannels;
}

-(void)setupHSelectionList
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hSelectionList = [[HSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.hSelectionList.delegate = self;
    self.hSelectionList.dataSource = self;
    self.hSelectionList.showsEdgeFadeEffect = YES;
    self.hSelectionList.snapToCenter = YES;
    self.hSelectionList.selectionIndicatorAnimationMode = HSelectionIndicatorAnimationModeNoBounce;
    self.hSelectionList.selectionIndicatorColor = [UIColor redColor];
    [self.hSelectionList setTitleFont:[UIFont systemFontOfSize:15] forState:UIControlStateNormal];
    [self.hSelectionList setTitleFont:[UIFont boldSystemFontOfSize:18] forState:UIControlStateSelected];
    [self.view addSubview:self.hSelectionList];
}

#pragma mark - HSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(id<HSelectionListProtocol>)selectionList {
    return self.hSelectionChannels.count;
}

- (NSString *)selectionList:(id<HSelectionListProtocol>)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.hSelectionChannels[index];
}

#pragma mark - HSelectionListDelegate Protocol Methods

- (void)selectionList:(id<HSelectionListProtocol>)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
    NSLog(@"selection list %ld",index);
    
}

@end
