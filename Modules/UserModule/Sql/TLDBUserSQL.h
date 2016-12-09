//
//  TLDBUserSQL.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/22.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#ifndef TLDBUSERSQL_H
#define TLDBUSERSQL_H

#define     USER_TABLE_NAME              @"User"

#define     SQL_CREATE_USER_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
                                            uid TEXT,\
                                            fid TEXT,\
                                            username TEXT,\
                                            nikename TEXT, \
                                            avatar TEXT,\
                                            remark TEXT,\
                                            ext1 TEXT,\
                                            ext2 TEXT,\
                                            ext3 TEXT,\
                                            ext4 TEXT,\
                                            ext5 TEXT,\
                                            PRIMARY KEY(uid, fid))"

#define     SQL_UPDATE_USER               @"REPLACE INTO %@ ( uid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_USERS              @"SELECT * FROM %@ WHERE uid = %@"

#define     SQL_DELETE_USER               @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"

#endif /* TLDBUSERSQL_H */
