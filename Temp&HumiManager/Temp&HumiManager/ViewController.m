//
//  ViewController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "ViewController.h"

#import "HTTP_MemberManager.h"

typedef void(^IntBlock)(int);

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray <NSMutableArray *>* datasArray;

@end

@implementation ViewController
{
    int brekvalue;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSArray * arr = @[@"1",@"1",@"1",@"1"];
//    goto 必须放在方法中

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

//    NSLog(@"%@",keyPath);
//    NSLog(@"%@",object);
//    NSLog(@"%@",change);
    if ([keyPath isEqualToString:@"contentSize"] && [object isKindOfClass:[UITableView class]]) {
        UITableView * tb = (UITableView *)object;
        CGRect frame = tb.frame;
        frame.size = tb.contentSize;
        tb.frame = frame;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * reuseIdentifer = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row-%ld",(long)indexPath.row];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * vv = [[UILabel alloc]init];
    vv.text = [NSString stringWithFormat:@"sec-%ld",(long)section];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];



}

- (void)timerChange1{

    for (int i=0; i<self.datasArray.count; i++) {
        for (int j=0 ; j<self.datasArray[i].count; j++) {
            [self likeQuery:^{
                NSLog(@"%d - %d",i,j);
                [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:j inSection:i]] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
    NSLog(@"\n");
}

- (void)timerChange{

    self.datasArray = [NSMutableArray array];

    for (int i=0; i<arc4random_uniform(3)+1; i++) {
        NSMutableArray * marr = [NSMutableArray array];
        for (int j=0; j<arc4random_uniform(3)+1; j++) {
            [marr addObject:@""];
        }
        [self.datasArray addObject:marr];
    }

    [self.tableview reloadData];

}

- (void)likeQuery:(void(^)(void))block{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(3)+1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}



@end
