

#ifndef TLDBUSERDETAILSQL_H
#define TLDBUSERDETAILSQL_H

#define     TABLE_NAME_USERDETAIL              @"UserDetail"

#define     SQL_CREATE_TABLE_USERDETAIL    @"CREATE TABLE IF NOT EXISTS %@(\
                                            uid TEXT,\
                                            sex TEXT,\
                                            location TEXT,\
                                            phoneNumber TEXT, \
                                            qqNumber TEXT,\
                                            email TEXT,\
                                            albumArray TEXT,\
                                            motto TEXT,\
                                            momentsWallURL TEXT,\
                                            address TEXT,\
                                            birthday TEXT,\
                                            hometown TEXT,\
                                            latitude TEXT,\
                                            longitude TEXT,\
                                            remarkInfo TEXT,\
                                            remarkImagePath TEXT,\
                                            remarkImageURL TEXT,\
                                            tags TEXT,\
                                            ext1 TEXT,\
                                            ext2 TEXT,\
                                            ext3 TEXT,\
                                            ext4 TEXT,\
                                            ext5 TEXT,\
                                            PRIMARY KEY(uid))"

#define     SQL_INSERT_OR_UPDATE_USERDETAIL               @"REPLACE INTO %@ ( uid, sex,location,phoneNumber, qqNumber,email,albumArray,motto,momentsWallURL,address,birthday,hometown,latitude,longitude,remarkInfo,remarkImagePath,remarkImageURL, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)"



#define     SQL_SELECT_USERDETAIL_ROW              @"SELECT * FROM %@ WHERE uid = %@"

#define     SQL_SELECT_USERDETAIL_ROWS              @"SELECT * FROM %@ WHERE uid IN (%@)"

#define     SQL_DELETE_USERDETAIL                @"DELETE FROM %@ WHERE uid = '%@'"

#endif /* TLDBUSERDETAILSQL_H */


