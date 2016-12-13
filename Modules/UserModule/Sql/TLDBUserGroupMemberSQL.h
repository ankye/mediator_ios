//
//  TLDBGroupSQL.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#ifndef TLDBUserGroupMemberSQL_h
#define TLDBUserGroupMemberSQL_h


#define     TABLE_NAMGE_GROUPMEMBER            @"user_group_members"

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

#define     SQL_UPDATE_GROUP_MEMBER             @"REPLACE INTO %@ ( uid, gid, fid, username, nickname, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_GROUP_MEMBERS            @"SELECT * FROM %@ WHERE uid = '%@' and gid = '%@'"

#define     SQL_DELETE_GROUP_MEMBER             @"DELETE FROM %@ WHERE uid = '%@' and gid = '%@' and fid = '%@'"


#endif /* TLDBUserGroupMemberSQL_h */
