//
//  BookCaseViewController.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCaseViewController.h"
#import "BookDetailViewController.h"
#import "BookCaseMainView.h"
#import "BookDatabase.h"

@interface BookCaseViewController ()<BookCaseMainViewDelegate>

@property (weak, nonatomic) IBOutlet BookCaseMainView *mainView;

@property(nonatomic,strong)NSArray * dataArray;

@end

@implementation BookCaseViewController

- (instancetype)init
{
    NSString * identifier = NSStringFromClass([self class]);
    UIStoryboard * sb = [UIStoryboard storyboardWithName:identifier bundle:nil];
    return  [sb instantiateViewControllerWithIdentifier:identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
}

- (void)loadMainView{
    self.requestUtil.isShowProgressHud = false;
    self.mainView.mainViewDelegate = self;
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"追书猫";
}

#pragma mark - BookCaseMainViewDelegate
- (void)itemSelectedWithMainView:(BookCaseMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    BookDetailViewController * con = [BookDetailViewController new];
    con.book = mainView.dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - 
- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    
    if (statusCode==200 && !error) {
        NSDictionary * dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlString isEqualURLWithURL:@"http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fvip.zhuishushenqi.com%2Fchapter%2F5804a6f44623674f2f2511ef%3Fcv%3D1476699892143?k=8a26071af0d9127e&t=1479273837"]) {
            
            NSString * content = dictData[@"chapter"][@"cpContent"];
            
            content =[content stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
            
        //    NSLog(@"-------->%@",content);
            
            return;
        }
        
        
        
        NSInteger errorCode =[dictData[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:dictData[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
        if ([urlString isEqualURLWithURL:URL_GET_BOOKCASE_LAST_LIST]) {
            NSArray * tmpArray = dictData[@"data"];
            
            
            
            for (int i=0; i<tmpArray.count; i++) {
                Book * newsBook = [Book bookWithDict:tmpArray[i]];
                
                Book * collBook = self.dataArray.count>i?self.dataArray[i]:nil;
                
                if (![collBook.last.name isEqualToString:newsBook.last.name]) {
                    collBook.last.isNewChapter = YES;
                }else{
                    collBook.last.isNewChapter = NO;
                }
                collBook.last.name = newsBook.last.name;
            }
            
            [self.mainView reloadData];
        }
    }else{
        
    }
}

#pragma mark - 系统协议
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataArray = [BookDatabase bookDataListFromDatabaseWithNovelId:nil];
    self.mainView.dataArray = self.dataArray;
    
    NSMutableString * ids = [NSMutableString new];
    for (Book * book in self.dataArray) {
        [ids appendFormat:@",%@",book.novel.Id];
    }
    NSString * novelids = ids.length?[ids substringFromIndex:1]:@"";
    
    NSString * url = [NSString stringWithFormat:@"%@?novelids=%@",URL_GET_BOOKCASE_LAST_LIST,novelids];
    
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
    
    
    url = @"http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fvip.zhuishushenqi.com%2Fchapter%2F5804a6f44623674f2f2511ef%3Fcv%3D1476699892143?k=8a26071af0d9127e&t=1479273837";
    
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
    
    
}

@end
