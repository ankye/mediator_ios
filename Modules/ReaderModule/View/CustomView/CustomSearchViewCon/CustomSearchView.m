//
//  CustomSearchBar.m
//  TestSearchViewController
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomSearchView.h"

#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height

@interface CustomSearchView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (weak, nonatomic) UISearchBar * searchBar;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property(nonatomic,assign)BOOL isEditing;

@end



@implementation CustomSearchView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxRowCount = 5;
        [self loadSearchView];
    }
    return self;
}


- (void)loadSearchView{
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    
    //设置背景View
//    UIView * backgroundView = [[UIView alloc]initWithFrame:self.bounds];
//    
//    UIImageView * imageView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"search_icon_searchbig"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    imageView.frame=CGRectMake(0, 0, 90, 90);
//    imageView.center=backgroundView.center;
//    CGRect frame = imageView.frame;
//    frame.origin.y=99;
//    imageView.frame=frame;
//    [backgroundView addSubview:imageView];
//    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 112, 20)];
//    label.center=self.center;
//    frame = imageView.frame;
//    frame.origin.y=CGRectGetMaxY(imageView.frame)+18;
//    imageView.frame=frame;
//    label.text=@"没有搜索历史记录";
//    label.font=[UIFont systemFontOfSize:14];
//    label.textColor=[UIColor colorWithRed:0.608 green:0.612 blue:0.690 alpha:1.000];
//    [backgroundView addSubview:label];
//    
//    tableView.backgroundView=backgroundView;
    
    
    //设置背景View
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"search_icon_searchbig"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    imageView.frame=CGRectMake(0, 0, 90, 86);
    imageView.center=backgroundView.center;
    CGRect frame = imageView.frame;
    frame.origin.y=99;
    imageView.frame=frame;
    [backgroundView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+18, WIDTH, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"没有搜索历史记录";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor colorWithRed:0.608 green:0.612 blue:0.690 alpha:1.000];
    [backgroundView addSubview:label];
    
    tableView.backgroundView=backgroundView;
    //以上设置tableView背景View
    
    
    self.tableView= tableView;
    [self addSubview:tableView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH, 64)];
    headerView.backgroundColor=[UIColor whiteColor];
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(8, 22, SELFWIDTH-16-70, 40)];
    searchBar.keyboardType = UIKeyboardAppearanceDefault;
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    searchBar.showsBookmarkButton=YES;
    self.searchBar=searchBar;
    [headerView addSubview:searchBar];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(SELFWIDTH-70, 27, 70, 30);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    self.tableView.tableHeaderView=headerView;
    
    self.searchArray = self.filterArray =[self getSearchArrayByUserDefaults];
}

#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num = self.filterArray.count>self.maxRowCount?self.maxRowCount:self.filterArray.count;
    
    //无消息背景View显示
    if(num==0){
        self.tableView.backgroundView.hidden=NO;
    }else{
        self.tableView.backgroundView.hidden=YES;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"UITableViewCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.textLabel.text = [self.filterArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    self.isEditing=false;
    [self.delegate customSearchBar:self andSearchValue:self.filterArray[indexPath.row]];
    self.searchBar.text=self.filterArray[indexPath.row];
    [self.searchArray removeAllObjects];
    [self.filterArray removeAllObjects];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.filterArray.count?44:0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.filterArray.count==0){
        return nil;
    }
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor whiteColor];
    btn.frame=CGRectMake(0, 0, SELFWIDTH, 44);
    [btn setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(clearBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clearBtnTouch{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchText"];
    [self.searchArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCHTEXT];
    [self.filterArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

#pragma mark - searchbar协议方法
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText==nil || searchText.length==0){
        self.searchArray = self.filterArray = [self getSearchArrayByUserDefaults];
        [self.tableView reloadData];
        return;
    }
    
    
    NSString *filterString = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", filterString];
    self.filterArray = [NSMutableArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self setSearchArrayByUserDefaults:searchBar.text];
    self.searchArray=nil;
    self.filterArray=nil;
    [self.tableView reloadData];
    [self endEditing:YES];
    [self.delegate customSearchBar:self andSearchValue:searchBar.text];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
}

- (void)cancleBtnTouch:(UIButton *)btn{
    if(self.isEditing){
        [self endEditing:YES];
        self.isEditing=false;
    }else{
        [self.delegate customSearchBar:self andCancleBtn:btn];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)getSearchArrayByUserDefaults{
    NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
    return [NSMutableArray arrayWithArray:[def objectForKey:SEARCHTEXT]];
}

- (void)setSearchArrayByUserDefaults:(NSString *)value{
    if(value==nil || value.length==0){
        return;
    }
    NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
    NSMutableArray * array = [def objectForKey:SEARCHTEXT];
    if(array==nil){
        array=[[NSMutableArray alloc]init];
        [array addObject:value];
    }else{
        array = [NSMutableArray arrayWithArray:array];
        for (NSString * tmpVal in array) {
            if([tmpVal isEqualToString:value]){
                return;
            }
        }
        [array addObject:value];
    }
    [def setObject:array forKey:SEARCHTEXT];
}

@end
