//
//  TLDBGroupSQL.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#ifndef TLDBUserGroupMemberSQL_h
#define TLDBUserGroupMemberSQL_h


#define     TABLE_NAMGE_GROUP_MEMBER            @"user_group_member"

#define     SQL_CREATE_TABLE_GROUP_MEMBER      @"CREATE TABLE IF NOT EXISTS %@(\
                                                uid TEXT,\
                                                gid TEXT,\
                                                fid TEXT,\
                                                username TEXT,\
                                                nickname TEXT, \
                                                avatar TEXT,\
                                                remark TEXT,\
                                                ext1 TEXT,\
                                                ext2 TEXT,\
                                                ext3 TEXT,\
                                                ext4 TEXT,\
                                                ext5 TEXT,\
                                                PRIMARY KEY(uid, gid, fid))"

#define     SQL_INSERT_OR_REPLACE_GROUP_MEMBER             @"REPLACE INTO %@ ( uid, gid, fid, username, nickname, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"




#endif /* TLDBUserGroupMemberSQL_h */
