//
//  DeviceDBManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceDBManager.h"

@implementation DeviceDBManager



- (void)insert{

    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
    DeviceDB * device = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceDB" inManagedObjectContext:self.managedObjectContext];

    //2.根据表Student中的键值，给NSManagedObject对象赋值

//    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
//    student.age = arc4random()%20;
//    student.sex = arc4random()%2 == 0 ?  @"美女" : @"帅哥" ;
//    student.height = arc4random()%180;
//    student.number = arc4random()%100
//
//    //   3.保存插入的数据
//    NSError *error = nil;
//    if ([_context save:&error]) {
//        [self alertViewWithMessage:@"数据插入到数据库成功"];
//    }else{
//        [self alertViewWithMessage:[NSString stringWithFormat:@"数据插入到数据库失败, %@",error]];
//    }

}



/**
 查询所有

 @return 所有Devicedb数据
 */
+ (NSArray <DeviceDB *>*)readAll{

    /* 谓词的条件指令
     1.比较运算符 > 、< 、== 、>= 、<= 、!=
     例：@"number >= 99"

     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"

     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"

     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束

     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   // *代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"

     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符

     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex

     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。

     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。

     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K

     */

    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DeviceDB"];
    /*
     //查询条件
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = %@", @"美女"];
     request.predicate = pre;
     */

    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;

    //发送查询请求
    NSArray * results = [[DeviceDBManager shareInstance].managedObjectContext executeFetchRequest:request error:nil];
    return results;

}


@end
