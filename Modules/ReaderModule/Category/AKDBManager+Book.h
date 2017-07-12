//
//  AKDBManager+Book.h
//  Project
//
//  Created by ankye on 2017/2/15.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "Book.h"

@interface AKDBManager (Book)



//AKDB_CREATE_TABLE_INTR(book)
//
//AKDB_INSERT_OR_REPLACE_INTR(book,Book)


-(BOOL)book_updateByID:(NSString*)bookid withAttirbutes:(NSDictionary*)attributes;

-(Book*)book_queryByID:(NSString*)bookid;

-(BOOL)book_deleteByID:(NSString*)bookid;

-(NSArray*)book_queryAll;

@end
