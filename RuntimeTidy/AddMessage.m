//
//  AddMessage.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "AddMessage.h"
#import <objc/runtime.h>

@interface OtherClassObject : NSObject

@end

@implementation OtherClassObject


@end

@implementation AddMessage

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
    [self addMothod];
}

- (void)addMothod
{
    
    Class cls = [OtherClassObject class];
    Method testAdd = class_getInstanceMethod([self class], @selector(testAddMethod));
    //这种方式需要添加一个C的方法
//    class_addMethod(cls, @selector(testAddMethod), (IMP)testAddMethod, method_getTypeEncoding(testAdd));
    class_addMethod(cls, @selector(testAddMethod), method_getImplementation(testAdd), method_getTypeEncoding(testAdd));
    OtherClassObject *other = [OtherClassObject new];
    [other performSelector:@selector(testAddMethod)];
}

- (void)testAddMethod
{
    NSLog(@"添加方法:1234567890");
}

//static void testAddMethod(id self, SEL _cmd) //self和_cmd是必须的，在之后可以随意添加其他参数
//{
//    Ivar v = class_getInstanceVariable([self class], "testProperty");
//    //返回名为itest的ivar的变量的值
//    NSString *propertyName = [[NSString alloc] initWithCString:ivar_getName(v) encoding:NSUTF8StringEncoding];
//    [self setValue:@"andrew" forKey:propertyName];
//    //成功打印出结果
//    NSLog(@"%@--%@", propertyName,[self valueForKey:@"testProperty"]);
//}

@end
