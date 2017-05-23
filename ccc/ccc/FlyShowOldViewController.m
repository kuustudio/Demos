//
//  FlyShowOldViewController.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyShowOldViewController.h"
#import "FlyDetailTableViewCell.h"
#import "FlyHttpManager.h"

#define HTTP_ADRESS   @"http://f.apiplus.net"

@interface FlyShowOldViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation FlyShowOldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _showTitle;
    _dataArr = [NSMutableArray array];
    self.view.backgroundColor =[UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    NSString *url = [NSString stringWithFormat:@"%@/%@-20.json",HTTP_ADRESS,[_urlStr lowercaseString]];
    [_dataArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [[FlyHttpManager sharedInstance].manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = responseObject[@"data"];
            for (NSDictionary *dic in dataDic) {
                FlyDetailModel *model = [[FlyDetailModel alloc] initWithDic:dic];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"网络加载失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf getData];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CELL";
    FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row < _dataArr.count) {
        FlyDetailModel *model = _dataArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
