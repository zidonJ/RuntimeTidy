//
//  CallMessageOptimize.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "CallMessageOptimize.h"

typedef void (*VIMP) (id,SEL,...);

@implementation CallMessageOptimize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self myControl];
    }
    return self;
}

- (void)myControl
{
    [self efficientCallMessage:@selector(test:)];
}

/*
 多个参数
 va_list:用来保存宏 va_start 、va_arg 和 va_end 所需信息的一种类型.为了访问变长参数列表中的参数,必须声明 va_list 类型的一个对象。
 va_start:访问变长参数列表中的参数之前使用的宏,它初始化用 va_list 声明的对象,初始化结果供宏va_arg和va_end使用
 va_arg:展开成一个表达式的宏，该表达式具有变长参数列表中下一个参数的值和类型.
 每次调用 va_arg 都会修改,用 va_list 声明的对象从而使该对象指向参数列表中的下一个参数。
 va_end:该宏使程序能够从变长参数列表用宏 va_start 引用的函数中正常返回。
 
 1、定义一个va_list指针
 2、调用 va_start 初始化这个指针
 3、调用 va_arg 开始取参数，主使抓到了，小弟们自然跑不掉。
 4、调用 va_end 将va_list指针置空
 */
- (void)efficientCallMessage:(SEL)sel ,...
{
    
    if (sel) {
        VIMP imp = (VIMP)[self methodForSelector:sel];
        imp(self,sel,@"5",@"经典的旋律",10);
    }
    
    NSString *objSend;
    
    va_list arg_list;
    va_start(arg_list, sel);
    while (NO) {
        objSend = va_arg(arg_list, NSString *);
        
        if (objSend == nil) {
            break;
        }else{
            NSLog(@"可变参数:%@",objSend);
        }
    }
    //取完之后毁掉va_list指针
    va_end(arg_list);
}

- (void)test:(NSString *)onlyOnePara
{
    NSLog(@"IMP传多个参数只接受1个:%@",onlyOnePara);
}

@end
