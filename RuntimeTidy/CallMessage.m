//
//  CallMessage.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "CallMessage.h"
#import <objc/runtime.h>

@implementation CallMessage

+ (void)test:(NSInteger)a {
    NSLog(@"------:%ld",a);
}

- (void)testa:(NSInteger)b {
    NSLog(@"------:%ld",b);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [self performSelector:@selector(test:) withObject:@1];
//        [self performSelector:@selector(testa:) withObject:@1];
        
//        [CallMessage performSelector:@selector(test:) withObject:@5];
//        [CallMessage performSelector:@selector(testa:) withObject:@6];
        
        [self myControl];
    }
    return self;
}

- (void)myControl
{
    [self performSelector:@selector(test:) withObject:nil afterDelay:0];
}

#if 0

- (void)anotherTest
{
    NSLog(@"验证OC的方法调用拯救机制第一步");
}

#else
- (void)anotherTestLast
{
    NSLog(@"验证OC的方法调用拯救机制最后一步");
}


#endif


/*
 第一次机会
 允许用户在此时为该 Class 动态添加实现。如果有实现了，则调用并返回YES，那么重新开始objc_msgSend流程。
 这一次对象会响应这个选择器，一般是因为它已经调用过class_addMethod。如果仍没实现，继续下面的动作。
 */

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if(sel == @selector(nilSymbol)){
        IMP imp = [self methodForSelector:@selector(anotherTest)];
        class_addMethod([self class],sel,imp,"v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
    
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if(sel == @selector(nilSymbol)){
        IMP imp = [self methodForSelector:@selector(anotherTest)];
        class_addMethod([self class],sel,imp,"v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
/*
 第二次机会,方法转发,返回一个可以执行这个方法的对象
 如果实现了这个方法就会被调用 不写默认本类
 */
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return self;
}

/*
 方法签名验证
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {  // 如果不能处理这个方法
        if ([self respondsToSelector:@selector(anotherTestLast)]) {
            // 返回另一个函数的方法签名,这个函数不一定要定义在本类中
            signature =  [CallMessage instanceMethodSignatureForSelector:@selector(anotherTestLast)];
        }
    }
    return signature;
}

/**
 *  这个函数中可以修改很多信息，比如可以替换选方法的处理者，替换选择子，修改参数等等
 *
 *  @param anInvocation 被转发的选择子
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation setSelector:@selector(anotherTestLast)];  // 设置需要调用的SEL
    [anInvocation invokeWithTarget:self];  // 设置消息的接收者，不一定必须是self
    
}

@end
