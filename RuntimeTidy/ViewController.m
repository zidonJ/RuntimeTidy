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
