//
//  Invocation_MethodSignature.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Invocation_MethodSignature.h"

@implementation Invocation_MethodSignature

- (instancetype)init {
    self = [super init];
    if (self) {
        [self myControl];
    }
    return self;
}

- (void)myControl {
    
    //NSInvocation;用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,
    /*
     NSMethodSignature:签名:再创建NSMethodSignature的时候,必须传递一个签名对象，签名对象的作用：用于获取参数的个数和方法的返回值
     */
    //创建签名对象的时候不是使用NSMethodSignature这个类创建,而是方法属于谁就用谁来创建
    NSMethodSignature*signature = [Invocation_MethodSignature instanceMethodSignatureForSelector:@selector(sendMessageWithNumber:WithContent:)];
    //1、创建NSInvocation对象
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    //invocation中的方法必须和签名中的方法一致。
    invocation.selector = @selector(sendMessageWithNumber:WithContent:);
    /*第一个参数：需要给指定方法传递的值
     第一个参数需要接收一个指针，也就是传递值的时候需要传递地址*/
    //第二个参数：需要给指定方法的第几个参数传值
    NSString *number = @"1111";
    //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
    [invocation setArgument:&number atIndex:2];
    NSString *number2 = @"啊啊啊";
    [invocation setArgument:&number2 atIndex:3];
    //2、调用NSInvocation对象的invoke方法
    //只要调用invocation的invoke方法，就代表需要执行NSInvocation对象中制定对象的指定方法，并且传递指定的参数
    [invocation invoke];
}

- (void)sendMessageWithNumber:(NSString*)number WithContent:(NSString*)content{
    NSLog(@"电话号:%@,内容:%@",number,content);
}

@end
