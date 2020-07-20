//
//  ViewController.m
//  RuntimeTidy
//
//  Created by 姜泽东 on 2017/11/2.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import "CallMessage.h"
#import "AddMessage.h"
#import "GoodFuncInRunTime.h"
#import "Person.h"
#import "CallMessageOptimize.h"
#import "Invocation_MethodSignature.h"
#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *myCString = @"123456789";
    NSValue *theValue = [NSValue valueWithBytes:&myCString objCType:@encode(NSString)];
    NSLog(@"%@",theValue);
    
    NSString *str;
    
    [theValue getValue:&str];
    NSLog(@"%@", str);
    
    NSLog(@"%@",[CallMessage new]);
    NSLog(@"%@",[GoodFuncInRunTime new]);
    
    NSLog(@"%@",[CallMessageOptimize new]);
    
    NSLog(@"%@",[Invocation_MethodSignature new]);
    
    NSLog(@"%@",[AddMessage new]);
    
    self.tableView.emptyDataSetSource = self;
    
    BOOL isMeta = class_isMetaClass([ViewController class]);
    NSLog(@"是否是元类1：%d",isMeta);
    NSLog(@"是否是元类2：%d",class_isMetaClass([NSObject class]));
    NSLog(@"是否是元类3：%d",class_isMetaClass(self.class));
    
    Class cls = object_getClass(self);
    BOOL clsIsMeta = class_isMetaClass(cls);
    NSLog(@"是否是元类4：%d",clsIsMeta);
    
    Class meta = object_getClass(cls);
    BOOL metaIsMeta = class_isMetaClass(meta);
    NSLog(@"是否是元类5：%d",metaIsMeta);
    
    NSLog(@"类&元类:%@-%@",cls,objc_getMetaClass("ViewController"));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"234";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


@end
