//
//  BasicPlayerViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/11/7.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "BasicPlayerViewController.h"
#import "AliyunPlayerVodPlayViewController.h"
#import "AliyunPlayerLivePlayViewController.h"

@interface BasicPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong )UITableView *tableView;
@property (nonatomic, strong)UILabel *versionLabel;

@property(nonatomic, strong)NSArray *titlesAry;

@end

@implementation BasicPlayerViewController

-(NSArray *)titlesAry
{
    if (!_titlesAry) {
        _titlesAry = @[NSLocalizedString(@"Basic function demo of Vod", nil),
                       NSLocalizedString(@"Basic function demo of live", nil),
                       ];
    }
    return _titlesAry;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        UIView *footview = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footview;
        
    }
    return  _tableView;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.text = NSLocalizedString(@"version", nil);
        _versionLabel.textColor = [UIColor blackColor];
        _versionLabel.font = [UIFont systemFontOfSize:12.0f];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _versionLabel;
    
}

- (void)initView{
    
    [self.view addSubview:self.tableView];
//    [self.view  addSubview:self.versionLabel];
    
}

- (void)InitNaviBar{
    NSString *backString = NSLocalizedString(@"Back",nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonItemCliceked:)];
}

- (void)returnButtonItemCliceked:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self InitNaviBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.versionLabel.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 40);
}

#pragma mark - tableDelegate/datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.titlesAry.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"democell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];\
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.titlesAry[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
        case 0:
        {
            /*********点播播放功能**********/
            AliyunPlayerVodPlayViewController *demoOne = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"AliyunPlayerVodPlayViewController"];
            demoOne.title = self.titlesAry[indexPath.row];
            [self.navigationController pushViewController:demoOne animated:YES];
            
        }
            break;
            
        case 1:
        {
            /*********直播播放基本功能**********/
            AliyunPlayerLivePlayViewController *demoTwo = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"AliyunPlayerLivePlayViewController"];
            demoTwo.title = self.titlesAry[indexPath.row];
            [self.navigationController pushViewController:demoTwo animated:YES];
            
        }
            break;
            
       
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
