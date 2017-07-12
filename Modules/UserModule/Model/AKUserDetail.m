//
//  AKUserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserDetail.h"
#import "UserModuleDefine.h"

@implementation AKUserDetail

+ (NSString *)databaseIdentifier {
    return [FileHelper getFMDBPath:KAK_USER_DBNAME];
}

+ (nullable NSString *)tableName
{
    return @"user_detail";
}

+ (nullable NSArray<NSArray<NSString *> *> *)uniqueKeys
{
    return @[@[@"uid"]];
}


//-(void)fillData:(id<AKUserDetailProtocol>)user
//{
//    self.uid = user.uid;
//    self.sex = user.sex;
//    self.location = user.location;
//    self.phoneNumber = user.phoneNumber;
//    self.qqNumber = user.qqNumber;
//    self.email = user.email;
//    self.albumArray = user.albumArray;
//    self.motto = user.motto;
//    self.momentsWallURL = user.momentsWallURL;
//    self.address = user.address;
//    self.birthday = user.birthday;
//    self.hometown = user.hometown;
//    self.latitude = user.latitude;
//    self.longitude = user.longitude;
//    self.remarkInfo = user.remarkInfo;
//    self.remarkImagePath = user.remarkImagePath;
//    self.remarkImageURL = user.remarkImageURL;
//    self.tags = user.tags;
//}
//
//-(void)resultSetToModel:(FMResultSet*)retSet
//{
//
//    self.uid =  [retSet stringForColumn:@"uid"];
//    self.sex =  [retSet intForColumn:@"sex"];
//    self.location =  [retSet stringForColumn:@"location"];
//    self.phoneNumber =  [retSet stringForColumn:@"phoneNumber"];
//    self.qqNumber =  [retSet stringForColumn:@"qqNumber"];
//    self.email =  [retSet stringForColumn:@"email"];
//    NSArray* arr = [[retSet stringForColumn:@"albumArray"] componentsSeparatedByString:@","];
//    self.albumArray = [[NSMutableArray alloc] initWithArray:arr];
//    self.motto =  [retSet stringForColumn:@"motto"];
//    self.momentsWallURL =  [retSet stringForColumn:@"momentsWallURL"];
//    self.address =  [retSet stringForColumn:@"address"];
//    self.birthday =  [retSet stringForColumn:@"birthday"];
//    self.hometown = [retSet stringForColumn:@"hometown"];
//    self.latitude =  [retSet doubleForColumn:@"latitude"];
//    self.longitude =  [retSet doubleForColumn:@"longitude"];
//    self.remarkInfo =  [retSet stringForColumn:@"remarkInfo"];
//    self.remarkImagePath = [retSet stringForColumn:@"remarkImagePath"];
//    self.remarkImageURL =  [retSet stringForColumn:@"remarkImageURL"];
//    NSArray* tags =  [[retSet stringForColumn:@"tags"] componentsSeparatedByString:@","];
//    self.tags = [[NSMutableArray alloc] initWithArray:tags];
//
//}
//
//-(NSArray*)fetchDBRecord
//{
//    NSArray *arrPara = [NSArray arrayWithObjects:
//                        AKNoNilString(self.uid),
//                        AKNoNilNumber([NSNumber numberWithInteger:self.sex]),
//                        AKNoNilString(self.location),
//                        AKNoNilString(self.phoneNumber),
//                        AKNoNilString(self.qqNumber),
//                        AKNoNilString(self.email),
//                        AKNoNilString([self.albumArray componentsJoinedByString:@","]),
//                        AKNoNilString(self.motto),
//                        AKNoNilString(self.momentsWallURL),
//                        AKNoNilString(self.address),
//                        AKNoNilString(self.birthday),
//                        AKNoNilString(self.hometown),
//                        AKNoNilNumber([NSNumber numberWithDouble:self.latitude]),
//                        AKNoNilNumber([NSNumber numberWithDouble:self.longitude]),
//                        AKNoNilString(self.remarkInfo),
//                        AKNoNilString(self.remarkImagePath),
//                        AKNoNilString(self.remarkImageURL),
//                        AKNoNilString([self.tags componentsJoinedByString:@","]),
//                        @"", @"", @"", @"", @"", nil];
//    return arrPara;
//}

@end
