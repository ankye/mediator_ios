

#ifndef AKDBBookSQL_H
#define AKDBBookSQL_H

#define     TABLE_NAME_BOOK              @"Book"

#define     SQL_CREATE_TABLE_BOOK        @"CREATE TABLE IF NOT EXISTS %@(\
                                            novel_id	TEXT, \
                                            novel_cover	TEXT, \
                                            novel_name	TEXT, \
                                            novel_intro	TEXT, \
                                            author_name	TEXT, \
                                            lastupdate_chapter_time	TEXT, \
                                            lastupdate_chapter_name	TEXT, \
                                            category_id	TEXT, \
                                            category_name	TEXT, \
                                            read_chapter_section	TEXT, \
                                            read_chapter_row	TEXT, \
                                            download_chapter_section	TEXT, \
                                            download_chapter_row	TEXT, \
                                            source_siteid	TEXT, \
                                            bookmark    TEXT, \
                                            has_sticky  TEXT, \
                                            ext_type    TEXT, \
                                            ext1    TEXT, \
                                            ext2    TEXT, \
                                            ext3    TEXT, \
                                            ext4    TEXT, \
                                            ext5    TEXT, \
                                            PRIMARY KEY(novel_id))"




#define     SQL_INSERT_OR_REPLACE_BOOK               @"REPLACE INTO %@ ( novel_id, novel_cover, novel_name, novel_intro, author_name, lastupdate_chapter_time,lastupdate_chapter_name,category_id,category_name,read_chapter_section,read_chapter_row,download_chapter_section,download_chapter_row,source_siteid,bookmark, has_sticky, ext_type,ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?, ?, ?, ?, ?, ?, ?, ?, ?)"






#endif /* TLDBUSERSQL_H */

