//
//  DataBaseManager.h
//  LTDemo
//
//  Created by PeteOu on 16/8/6.
//  Copyright © 2016年 PeteOu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBName @"mydb.sqlite" //数据库名字
#define DBManager [DataBaseManager sharedInstance]

/**
 查询数据的回调

 @param result YES OR NO
 @param modelArray 模型数组
 */
typedef void(^dbQueryResultBlock) (BOOL result, NSMutableArray *modelArray);

/**
 *  插入或者更新数据库的回调
 *
 *  @param BOOL 成功或者失败
 */


/**
 插入或者更新数据库的回调

 @param result YES OR NO
 */
typedef void(^dbUpdateResultBlock)(BOOL result);

/**
 *  数据库操作
 *  ---------------------------------------------
 *
 *  注意事项：
 *
 1.建表的时候，必须指定<主键>，这样才能提高update语句的效率。
 *
 2.目前仅使用一个数据库，一个FMDatebaseQueue的组合，所以任何操作都是按提交顺序执行，队列操作。
 *
 3.block的回调是使用主线程的回调，请注意block中逻辑的性能控制。
 *
 4.FMResultSet尽量不要进行回调，我们这里使用运行时来处理查询的数据，转换成模型对象。
 *
 *  ---------------------------------------------
 *
 */
@interface DataBaseManager : NSObject

+ (instancetype)sharedInstance;

- (void)querySomething:(NSString *)sqlString withBlock:(dbQueryResultBlock)block;

#pragma mark - 直接以模型的类名作为表名，模型的字段作为表字段的一系列操作
/**
 *  根据模型类来创表
 *
 *  @param mClass 模型类
 */
- (void)createTableForModelClass:(Class)mClass;

/**
 *  直接根据sql语句进行查询，查询后将其内容转为mClass的模型实例数组进行回调
 *
 *  @param sqlString sql语句
 *  @param block     查询回调
 *  @param mClass    模型类
 */
- (void)queryWithSql:(NSString *)sqlString withBlock:(dbQueryResultBlock)block toModelClass:(Class)mClass;

/**
 *  更加模型类查找对应表的所有数据
 *
 *  @param mClass 模型类
 *  @param block  查询回调
 */
- (void)queryAllToModelClass:(Class)mClass withBlock:(dbQueryResultBlock)block;

/**
// *  根据模型插入或者更新数据库（单条）
// *
// *  @param model 模型数据
// *  @param block 更新回调
// */
//- (void)insertOrUpdateModel:(id)model withBlock:(dbUpdateResultBlock)block;
//- (void)insertOrUpdateModelArray:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block;

/**
 *  批量插入模型到数据库
 *
 *  @param modelArray 所有元素都要继承自DBBaseObject
 *  @param block      dbUpdateResultBlock
 */
- (void)insertModels:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block;

/**
 *  批量更新模型到数据
 *
 *  @param modelArray 所有元素都要继承自DBBaseObject
 *  @param block      dbUpdateResultBlock
 */
- (void)updateModels:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block;

/**
 *  根据模型删除对应表的数据
 *
 *  @param model 模型数据
 *  @param block 更新回调
 */
- (void)deleteModel:(id)model withBlock:(dbUpdateResultBlock)block;

/**
 *  根据模型数组删除对应表的数据
 *
 *  @param modelArray 模型数据数组
 *  @param block      更新回调
 */
- (void)deleteModelArray:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block;
#pragma mark END*直接以模型的类名作为表名，模型的字段作为表字段的一系列操作*END

#pragma mark - 测试例子
- (void)example;
- (void)example2;
- (void)example3;
- (void)test1;
@end
