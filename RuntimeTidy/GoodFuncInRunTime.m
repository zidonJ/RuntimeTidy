//
//  GoodFuncInRunTime.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "GoodFuncInRunTime.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
 关于IMP指针
 
 通过取得IMP,我们可以跳过Runtime的消息传递机制,直接执行IMP指向的函数实现,
 这样省去了Runtime消息传递过程中所做的一系列查找操作,会比直接向对象发送消息高效一些
 
 Person *person=[[Person alloc] initWithWeight:68];
 person.name=@"Jetta";
 SEL print_sel = @selector(print);
 IMP imp = [person methodForSelector:print_sel];
 NSLog(@"%@",imp(self,print_sel));
 
 系统IMP指针需要修改llvm preprocessing 下的enable strict checking
 置为NO 禁用严格审查 否则会编译报错
 
 typedef void (*VIMP) (id,SEL,...); 自定义IMP指针 不需要修改llvm配置
 */
typedef void (*VIMP) (id,SEL,...);

@interface GoodFuncInRunTime()
{
    NSString *_name;
    NSString *_sex;
}

@property (nonatomic,copy) NSString *doSomeThing;
@property (nonatomic,assign) NSInteger numInt;
@property (nonatomic,assign) long numLong;
@property (nonatomic,assign) double numDouble;

@end

@implementation GoodFuncInRunTime

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
        [self myControl];
    }
    return self;
}

- (void)_init
{
    _name = @"zidonj";
    _sex = @"HandsomeBoy";
    
    _doSomeThing = @"coding";
    _numInt = 132618;
    _numLong = 12345678;
    _numDouble = 12345.6789;
}

- (void)myControl
{
    [self ergodic];
    [self imp_point];
    [self msg_send];
    [self assocatie];
}

/**
 imp指针
 */
- (void)imp_point
{
    VIMP imp = (VIMP)[self methodForSelector:@selector(msgSendTest:p1:p2:)];
    imp(self,@selector(msgSendTest:p1:p2:),5,@"经典的旋律",10);
}

/**
 <objc/message.h>
 objc_msgSend
 */
- (void)msg_send
{
    SEL selector = @selector(msgSendTest:p1:p2:);
    ((void (*)(id,SEL,...))objc_msgSend)(self,selector,5,@"啦啦啦",6);
    SEL selectorBack = @selector(msgSendTestBack:p1:p2:);
    NSInteger temp = ((NSInteger (*)(id,SEL,int,id,int))objc_msgSend)(self,selectorBack,5,@"啦啦啦",6);
    NSLog(@"返回值:%ld",temp);
}


/**
 遍历
 */
- (void)ergodic
{
    
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    
    //遍历所有成员变量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    for (const Ivar *p = ivars; p < ivars + ivarsCnt ; p++){
        
        Ivar ivar = *p;
        //ivar_getName(ivar)  括号里写ivar和*p效果是一样的 为了方便理解
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"key:%@",key);
        id value = [self valueForKey:key];
        NSLog(@"值:%@",value);
        const char *type = ivar_getTypeEncoding(ivar);
        NSString *typeString = [NSString stringWithUTF8String:type];
        NSLog(@"类型:%@",typeString);
        
    }
    free(ivars);
    
    //遍历所有属性
    unsigned int porpCnt = 0;
    objc_property_t *t_property = class_copyPropertyList(cls, &porpCnt);
    for (const objc_property_t *p = t_property; p < porpCnt + t_property; ++p) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(*p)];
        id value = [self valueForKey:key];
        NSLog(@"值:%@",value);
        const char *type = property_getAttributes(*p);
        NSString *attributeString = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSLog(@"%@",attributeString);
    }
    
    free(t_property);
}

/*
    关联
 */
- (void)assocatie
{
    static char overviewKey;
    NSArray *array=[[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", nil];
    NSString * overview = [[NSString alloc] initWithFormat:@"%@",@"First three numbers"];
    objc_setAssociatedObject(array, &overviewKey, overview, OBJC_ASSOCIATION_RETAIN);
    NSString *str = (NSString *)objc_getAssociatedObject(array, &overviewKey);
    NSLog(@"获取关联对象:%@",str);
    NSLog(@"befor:%@",array);
    objc_removeAssociatedObjects(array);
    NSLog(@"after:%@",array);
}

-(NSInteger)msgSendTestBack:(NSInteger)tp p1:(NSString *)p1 p2:(NSInteger)p2
{
    return 1234567890;
}

-(void)msgSendTest:(NSInteger)tp p1:(NSString *)p1 p2:(NSInteger)p2
{
    NSLog(@"%ld_%@_%ld",tp,p1,p2);
}

@end
