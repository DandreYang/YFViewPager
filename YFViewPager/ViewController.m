//
//  ViewController.m
//  YFViewPager
//
//  Created by Saxue on 15/10/31.
//  Copyright © 2015年 Saxue. All rights reserved.
//

#import "ViewController.h"
#import "YFViewPager.h"

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth  [[UIScreen mainScreen] bounds].size.width

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

@interface ViewController ()
{
    YFViewPager         *_viewPager;
    UITableView         *_tableView;
    UICollectionView    *_collectionView;
    UIWebView           *_webView;
    
    UICollectionViewFlowLayout *_flow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - 配置视图
- (void)configUI
{
    _tableView = [self getTableView];
    _collectionView = [self getCollectionView];
    _webView = [[UIWebView alloc] init];
    [_webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:@"https://www.baidu.com"]]];
    
    _tableView.rowHeight = 80;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    _collectionView.backgroundColor = [UIColor grayColor];
    
    NSArray *titles = @[@"菜单一",
                        @"菜单二",
                        @"菜单三"];
    NSArray *icons = @[[UIImage imageNamed:@"issueTree"],
                       [UIImage imageNamed:@"hollow_out_star_blue"],
                       [UIImage imageNamed:@"later_in-tne_chat"]];

    NSArray *views = @[_tableView,
                       _collectionView,
                       _webView];
    
    CGFloat y = IS_IPHONE_X?44:20;
    
    _viewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0, y, kWidth, kHeight - y)
                                             titles:titles
                                              icons:icons
                                      selectedIcons:nil
                                              views:views];
    [self.view addSubview:_viewPager];
    
#pragma mark - YFViewPager 相关属性 方法
//    _viewPager.enabledScroll = NO;
//    _viewPager.showAnimation = NO;
//    _viewPager.showBottomLine = NO;
//    _viewPager.showVLine = NO;
//    _viewPager.bottomLineSelectedBgColor = [UIColor redColor];
//    _viewPager.bottomLineBgColor = [UIColor orangeColor];
//    _viewPager.tabBgColor = [UIColor orangeColor];
//    _viewPager.bottomLineSelectedBgColor = [UIColor brownColor];
//    _viewPager.tabSelectedBgColor = [UIColor redColor];
//    _viewPager.tabSelectedTitleColor = [UIColor blueColor];
//    _viewPager.tabTitleColor = [UIColor grayColor];
//    [_viewPager setTitleIconsArray:icons selectedIconsArray:nil];
    
    // 此方法用于给菜单标题右上角小红点赋值，可动态调用
    [_viewPager setTipsCountArray:@[@100,@8,@0]];
    [_viewPager setTipsCountShowType:YFViewPagerTipsCountShowTypeNumber];
    
    [_viewPager setBottomLineType:YFViewPagerBottomLineTypeFitItemContentWidth];
    
    // 点击菜单时触发
    [_viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
        switch (index) {
            case 0:     // 点击第一个菜单
            {
                
            }
                break;
            case 1:     // 点击第二个菜单
            {
                
            }
                break;
            case 2:     // 点击第三个菜单
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - 获取TableView
- (UITableView *)getTableView;
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}

#pragma mark - 获取集合视图
- (UICollectionView *)getCollectionView
{
    _flow = [[UICollectionViewFlowLayout alloc] init];
    _flow.minimumInteritemSpacing = 0;
    _flow.minimumLineSpacing = 0;
    [_flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:_flow];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    return collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取随机色
- (UIColor *)getRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"my_headportrait"]];
    cell.textLabel.text = [NSString stringWithFormat:@"演示文字-%ld",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"v2.0"];
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"CollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    cell.backgroundColor = [self getRandomColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kWidth/2 , 100);
}

@end
