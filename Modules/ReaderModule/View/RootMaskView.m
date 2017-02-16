//
//  RootMaskView.m
//  powerlife
//
//  Created by 陈行 on 16/6/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "RootMaskView.h"


@interface RootMaskView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RootMaskView

+ (instancetype)viewFromNib{
    NSString * nibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] firstObject];
}

+ (instancetype)maskViewWithSuperView:(UIView *)superView{
    RootMaskView * maskView = [self viewFromNib];
    maskView.frame=[UIScreen mainScreen].bounds;
    maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    maskView.hidden=YES;
    
    UISwipeGestureRecognizer * sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:maskView action:@selector(swipeDirectionRight:)];
    sgr.direction=UISwipeGestureRecognizerDirectionRight;
    [maskView addGestureRecognizer:sgr];
    
    [superView addSubview:maskView];
    [maskView initTableView];
    return maskView;
}

- (void)initTableView{
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self isRespondsToSelector:@selector(numberOfSectionsInMaskView:)]) {
        return [self.delegate numberOfSectionsInMaskView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self isRespondsToSelector:@selector(maskView:numberOfRowsInSection:)]) {
        return [self.delegate maskView:self numberOfRowsInSection:section];
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isRespondsToSelector:@selector(maskView:andTableView:cellForRowAtIndexPath:)]) {
        UITableViewCell * cell = [self.delegate maskView:self andTableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell!=nil) {
            return cell;
        }
    }
    
    static NSString * identifier=@"RootStandardTableCell";
    RootStandardTableCell * cell= nil;//[tableView tableViewCellByNibWithIdentifier:identifier];
    NSString * obj = self.dataArray[indexPath.row];;
    if (self.key) {
        obj = [obj valueForKey:self.key];
    }
    cell.titleLabel.text = obj;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isRespondsToSelector:@selector(maskView:didSelectRowAtIndexPath:)]) {
        [self.delegate maskView:self didSelectRowAtIndexPath:indexPath];
    }else{
        [self hiddenViewWithAnimation:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self isRespondsToSelector:@selector(maskView:andTableView:viewForHeaderInSection:)]) {
        return [self.delegate maskView:self andTableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isRespondsToSelector:@selector(maskView:heightForRowAtIndexPath:)]) {
        return [self.delegate maskView:self heightForRowAtIndexPath:indexPath];
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self isRespondsToSelector:@selector(maskView:heightForHeaderInSection:)]) {
        return [self.delegate maskView:self heightForHeaderInSection:section];
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self isRespondsToSelector:@selector(maskView:heightForFooterInSection:)]) {
        return [self.delegate maskView:self heightForFooterInSection:section];
    }
    return 0.1;
}

- (void)selectedIndexPath:(NSIndexPath *)indexPath{
    __block UITableView * tableView = self.tableView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    });
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

#pragma mark - private
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self hiddenView];
}

- (void)swipeDirectionRight:(UISwipeGestureRecognizer *)sgr{
    [self hiddenView];
}

- (void)hiddenView{
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform=CGAffineTransformMakeTranslation(self.containerView.width, 0);
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}

- (BOOL)isRespondsToSelector:(SEL)sel{
    if ([self.delegate respondsToSelector:sel]) {
        return YES;
    }
    return NO;
}

#pragma mark - public
- (void)hiddenViewWithAnimation:(BOOL)animation{
    if (animation) {
        [self hiddenView];
    }else{
        self.hidden=YES;
        self.containerView.transform=CGAffineTransformMakeTranslation(self.containerView.width, 0);
    }
}

- (void)showView{
    self.hidden=NO;
    self.containerView.transform=CGAffineTransformMakeTranslation(self.containerView.width, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform=CGAffineTransformIdentity;
    }];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self.tableView reloadData];
}

#pragma mark - 系统协议
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenViewWithAnimation:YES];
}

@end
