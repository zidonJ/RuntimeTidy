//
//  ItemProperty.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2018/3/1.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

#import "ItemProperty.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Block.h>

@implementation ItemProperty

- (void)variable {
    //  取得当前类类型
    Class cls = [self class];
    
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量 class_copyPropertyList:只取属性  class_copyIvarList:取所有
    //  Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    objc_property_t *ivars = class_copyPropertyList(cls, &ivarsCnt);//这是一个数组
    
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const objc_property_t *p = ivars; p < ivars + ivarsCnt; ++p){
        objc_property_t const ivar = *p;
        //　获取变量名
        
        //  NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [NSString stringWithUTF8String:property_getName(ivar)];
        NSLog(@"**:%@",key);
        // 若此变量未在类结构体中声明而只声明为Property,则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //　获取变量值
        id value = [self valueForKey:key];
        //value=@"aa";
        NSLog(@"!!:%@",value);
        //　取得变量类型
        // 通过 type[0]可以判断其具体的内置类型
        //        const char *type = ivar_getTypeEncoding(ivar);
        const char *type = property_getAttributes(ivar);
        NSLog(@"::%s",type);
    }
    free(ivars);
}

- (void)associatedObject {
    
    static char overviewKey;
    NSArray *array=[[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", nil];
    NSString * overview = [[NSString alloc] initWithFormat:@"%@",@"First three numbers"];
    objc_setAssociatedObject(array, &overviewKey, overview, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSString *str = (NSString *)objc_getAssociatedObject(array, &overviewKey);
    NSLog(@"获取关联对象:%@",str);
    NSLog(@"befor:%@",array);
    objc_removeAssociatedObjects(array);
    NSLog(@"after:%@",array);
}

@end
