//
//  TLDBGroupSQL.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#ifndef TLDBUserGroupSQL_h
#define TLDBUserGroupSQL_h

#pragma mark - # GROUP

#define     TABLE_NAME_GROUP               @"user_group"

#define     SQL_CREATE_TABLE_GROUP         @"CREATE TABLE IF NOT EXISTS %@(\
                                            uid TEXT,\
                                            gid TEXT,\
                                            name TEXT,\
                                            ext1 TEXT,\
                                            ext2 TEXT,\
                                            ext3 TEXT,\
                                            ext4 TEXT,\
                                            ext5 TEXT,\
                                            PRIMARY KEY(uid, gid))"

#define     SQL_INSERT_OR_REPLACE_GROUP                @"REPLACE INTO %@ ( uid, gid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"





#endif /* TLDBUserGroupSQL_h */
