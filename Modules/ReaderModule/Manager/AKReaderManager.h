//
//  AKReaderManager.h
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKReaderManager : NSObject


@property (nonatomic,strong) NSMutableArray*    bookShelf;
@property (nonatomic,strong) NSMutableDictionary* books;


//@property (nonatomic, assign) double systemBattery;



SINGLETON_INTR(AKReaderManager)

-(Book*)addBook:(Book*)book;

//-(void)moduleInitConfigure;

-(void)loadBookShelf;

//收藏书
-(void)bookmark:(Book*)book;
//取消收藏
-(void)unBookmark:(Book*)book;

-(void)requestBookChapters:(Book*)book;

-(AKDownloadGroupModel*)startDownloadBook:(Book*)book atIndex:(NSInteger)index;

@end
