#import "Person.h"
#import <objc/runtime.h>
void dynamicMethod(id self,SEL _cmd,float w)
{
    printf("dynamicMethod-%s\n",[NSStringFromSelector(_cmd) cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("%f\n",w);
}
@implementation Person
@synthesize name;
@synthesize weight;
@dynamic height;
-(Person*) initWithWeight: (float) w{
    self=[super init];
    if (self) {
        weight=w;
    }
    return self;
}

-(void)print
{
    NSLog(@"%@",name);
//    return @"系统IMP默认带返回值 不能获取没有返回值的方法";
}

+(BOOL) resolveInstanceMethod: (SEL) sel{
    
    NSString *methodName=NSStringFromSelector(sel);
    BOOL result=NO;
    if ([methodName isEqualToString:@"setHeight:"]) {
        class_addMethod([self class], sel, (IMP)dynamicMethod,"v@:f");
        result=YES;
    }
    return result;
}
-(void) dealloc
{
    [self setName:nil];
}
@end
