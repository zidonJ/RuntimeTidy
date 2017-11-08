//
//  UIViewController+MethodSwizzling.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/8.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

/*
iOS方法
name 表示的是方法的名称，用于唯一标识某个方法，比如 @selector(viewWillAppear:) ；
types 表示的是方法的返回值和参数类型（详细信息可以查阅苹果官方文档中的 Type Encodings ）；
imp 是一个函数指针，指向方法的实现；
SortBySELAddress 顾名思义，是一个根据 name 的地址对方法进行排序的函数。
 
typedef struct method_t *Method;
struct method_t {
    SEL name;
    const char *types;
    IMP imp;
    
    struct SortBySELAddress :
    public std::binary_function<const method_t&,
    const method_t&, bool>
    {
        bool operator() (const method_t& lhs,
                         const method_t& rhs)
        { return lhs.name < rhs.name; }
    };
};
 
*/

@implementation UIViewController (MethodSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mt_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        /*
         class_addMethod Apple官方解释
         YES if the method was added successfully, otherwise NO
         (for example, the class already contains a method implementation with that name).
         主类本身有实现需要替换的方法,也就是 class_addMethod 方法返回 NO
         主类本身没有实现需要替换的方法，而是继承了父类的实现,即 class_addMethod 方法返回 YES.
         这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法
         */
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)mt_viewWillAppear:(BOOL)animated
{
    [self mt_viewWillAppear:animated];
    NSLog(@"将要进入界面");
}

@end
