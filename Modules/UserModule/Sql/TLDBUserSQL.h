

#ifndef TLDBUSERSQL_H
#define TLDBUSERSQL_H

#define     TABLE_NAME_USER              @"User"

#define     SQL_CREATE_TABLE_USER        @"CREATE TABLE IF NOT EXISTS %@(\
                                            uid TEXT,\
                                            usernum TEXT,\
                                            username TEXT,\
                                            nickname TEXT, \
                                            avatar TEXT,\
                                            avatarHD TEXT,\
                                            avatarPath TEXT,\
                                            remarkName TEXT,\
                                            money TEXT,\
                                            coin TEXT,\
                                            lastNicknameModifyTime TEXT,\
                                            lastLoginTime TEXT,\
                                            lastPayTime TEXT,\
                                            pinyin TEXT,\
                                            pinyinInitial TEXT,\
                                            ext1 TEXT,\
                                            ext2 TEXT,\
                                            ext3 TEXT,\
                                            ext4 TEXT,\
                                            ext5 TEXT,\
                                            PRIMARY KEY(uid))"

#define     SQL_INSERT_OR_UPDATE_USER               @"REPLACE INTO %@ ( uid, usernum, username, nickname, avatar, avatorHD,avatarPath,remarkName,money,coin,lastNicknameModifyTime,lastLoginTime,lastPayTime,pinyin,pinyinInitial, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"



#define     SQL_SELECT_USER_ROW              @"SELECT * FROM %@ WHERE uid = %@"

#define     SQL_SELECT_USER_ROWS              @"SELECT * FROM %@ WHERE uid IN (%@)"

#define     SQL_DELETE_USER               @"DELETE FROM %@ WHERE uid = '%@'"

#endif /* TLDBUSERSQL_H */

