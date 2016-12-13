//
//  AKUserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserDetail.h"
#import "AKUserDetailProtocol.h"

@implementation AKUserDetail

-(void)fillData:(id<AKUserDetailProtocol>)user
{
    self.uid = user.uid;
    self.sex = user.sex;
    self.location = user.location;
    self.phoneNumber = user.phoneNumber;
    self.qqNumber = user.qqNumber;
    self.email = user.email;
    self.albumArray = user.albumArray;
    self.motto = user.motto;
    self.momentsWallURL = user.momentsWallURL;
    self.address = user.address;
    self.birthday = user.birthday;
    self.hometown = user.hometown;
    self.latitude = user.latitude;
    self.longitude = user.longitude;
    self.remarkInfo = user.remarkInfo;
    self.remarkImagePath = user.remarkImagePath;
    self.remarkImageURL = user.remarkImageURL;
    self.tags = user.tags;
}

-(void)resultSetToModel:(FMResultSet*)retSet
{

    self.uid =  [retSet stringForColumn:@"uid"];
    self.sex =  [retSet intForColumn:@"sex"];
    self.location =  [retSet stringForColumn:@"location"];
    self.phoneNumber =  [retSet stringForColumn:@"phoneNumber"];
    self.qqNumber =  [retSet stringForColumn:@"qqNumber"];
    self.email =  [retSet stringForColumn:@"email"];
    NSArray* arr = [[retSet stringForColumn:@"albumArray"] componentsSeparatedByString:@","];
    self.albumArray = [[NSMutableArray alloc] initWithArray:arr];
    self.motto =  [retSet stringForColumn:@"motto"];
    self.momentsWallURL =  [retSet stringForColumn:@"momentsWallURL"];
    self.address =  [retSet stringForColumn:@"address"];
    self.birthday =  [retSet stringForColumn:@"birthday"];
    self.hometown = [retSet stringForColumn:@"hometown"];
    self.latitude =  [retSet doubleForColumn:@"latitude"];
    self.longitude =  [retSet doubleForColumn:@"longitude"];
    self.remarkInfo =  [retSet stringForColumn:@"remarkInfo"];
    self.remarkImagePath = [retSet stringForColumn:@"remarkImagePath"];
    self.remarkImageURL =  [retSet stringForColumn:@"remarkImageURL"];
    NSArray* tags =  [[retSet stringForColumn:@"tags"] componentsSeparatedByString:@","];
    self.tags = [[NSMutableArray alloc] initWithArray:tags];

}

-(NSArray*)modelToDBRecord
{
    NSArray *arrPara = [NSArray arrayWithObjects:
                        TLNoNilString(self.uid),
                        TLNoNilNumber([NSNumber numberWithInteger:self.sex]),
                        TLNoNilString(self.location),
                        TLNoNilString(self.phoneNumber),
                        TLNoNilString(self.qqNumber),
                        TLNoNilString(self.email),
                        TLNoNilString([self.albumArray componentsJoinedByString:@","]),
                        TLNoNilString(self.motto),
                        TLNoNilString(self.momentsWallURL),
                        TLNoNilString(self.address),
                        TLNoNilString(self.birthday),
                        TLNoNilString(self.hometown),
                        TLNoNilNumber([NSNumber numberWithDouble:self.latitude]),
                        TLNoNilNumber([NSNumber numberWithDouble:self.longitude]),
                        TLNoNilString(self.remarkInfo),
                        TLNoNilString(self.remarkImagePath),
                        TLNoNilString(self.remarkImageURL),
                        TLNoNilString([self.tags componentsJoinedByString:@","]),
                        @"", @"", @"", @"", @"", nil];
    return arrPara;
}

@end
