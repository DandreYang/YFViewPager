//
//  YFViewPager.m
//  YFViewPager
//
//  Created by Dandre on 15/10/31.
//  Copyright © 2015年 Dandre. All rights reserved.
//

#import "YFViewPager.h"

#ifdef DEBUG
#define DLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog(s, ...)
#endif

@interface YFViewPager ()
{
    NSArray *_titleArray;           /**< 菜单标题 */
    NSArray *_views;                /**< 视图 */
    NSArray *_titleIconsArray;      /**< 菜单标题左侧的小图标 */
    NSArray *_selectedIconsArray;   /**< 菜单被选中时左侧的小图标 */
    NSArray *_tipsCountArray;       /**< 菜单右上角的小红点显示的数量 */
}
@end


@implementation YFViewPager
{
    SelectedBlock _block;
    NSInteger _pageNum;
}

//初始化
- (id)initWithFrame:(CGRect)frame
             titles:(NSArray<NSString *> *)titles
              views:(NSArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = views;
        _titleArray = titles;
        self.backgroundColor = [UIColor grayColor];
        [self configSelf];
    }
    return self;
}

//设置默认属性
- (void)configSelf
{
    self.userInteractionEnabled = YES;
    _tabBgColor = [UIColor whiteColor];
    _bottomLineBgColor = [UIColor colorWithRed:204/255.0 green:208/255.0 blue:210/255.0 alpha:1];
    _tabTitleColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _tabSelectedBgColor = [UIColor whiteColor];
    _tabSelectedTitleColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _bottomLineSelectedBgColor =[UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _showVLine = YES;
    _showAnimation = YES;
    _showBottomLine = YES;
    _showSelectedBottomLine = YES;
    _enabledScroll = YES;
}

//视图重绘
- (void)drawRect:(CGRect)rect
{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    // Drawing code
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2, rect.size.width, rect.size.height - 2)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    CGRect frame;
    frame.origin.y = 38;
    frame.size.height = _scrollView.frame.size.height - 40;
    frame.size.width = rect.size.width;
    
    _pageControl = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 40)];
    _pageNum = _views.count;
    _pageControl.backgroundColor = [UIColor whiteColor];
    
    //创建菜单按钮下划线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,  _pageControl.frame.size.height - 1, _pageControl.frame.size.width, 1)];
    label.backgroundColor = _bottomLineBgColor;
    label.tag = 200;
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    selectedLabel.backgroundColor = _bottomLineSelectedBgColor;
    selectedLabel.tag = 300;
    
#pragma mark - 3.1 Add
    
    switch (_bottomLineType) {
        case YFViewPagerBottomLineTypeHidden:
        {
            label.hidden = YES;
            selectedLabel.hidden = YES;
        }
        break;
        
        case YFViewPagerBottomLineTypeFitItemContentWidth:
        {
            label.hidden = NO;
            selectedLabel.hidden = NO;
            label.frame = CGRectMake(0,  _pageControl.frame.size.height - 1, _pageControl.frame.size.width, 1);
            
            CGFloat selectedLabelWidth = [self getLabelWidth:[_titleArray firstObject] fontSize:15] + ((UIImage *)[_titleIconsArray firstObject]).size.width + 10;
            selectedLabel.frame = CGRectMake(0, _pageControl.frame.size.height -1, selectedLabelWidth, 1);
            selectedLabel.center = CGPointMake((_pageControl.frame.size.width/_pageNum)/2, _pageControl.frame.size.height -1.5);
        }
        break;
        case YFViewPagerBottomLineTypeFullItemWidth:
        default:
        {
            label.hidden = NO;
            selectedLabel.hidden = NO;
            label.frame = CGRectMake(0,  _pageControl.frame.size.height - 1, _pageControl.frame.size.width, 1);
            selectedLabel.frame = CGRectMake(0, _pageControl.frame.size.height -1, _pageControl.frame.size.width/_pageNum, 1);
        }
            break;
    }
    
    if (!_showBottomLine){
        CGRect labelFrame = label.frame;
        labelFrame.size.height = 0;
        label.frame = labelFrame;
    }
    
    if (!_showSelectedBottomLine) {
        CGRect selectedFrame = selectedLabel.frame;
        selectedFrame.size.height = 0;
        selectedLabel.frame = selectedFrame;
    }
    
#pragma mark - Modify By Dandre @2016.05.02 增加支持controller
    UIViewController *superVC = [self getViewControllerOfView:self];
    for (NSInteger i = 0; i < _views.count; i++) {
        //创建主视图
        UIView * view;
        
        if ([_views[i] isKindOfClass:[UIViewController class]]) {
            UIViewController *VC = _views[i];
            view = VC.view;
            [superVC addChildViewController:VC];
        }else{
            view = [_views objectAtIndex:i];
        }
        
        frame.origin.x = rect.size.width * i;
        [view setFrame:frame];
        [_scrollView addSubview:view];
        
        CGRect _pageframe = _pageControl.frame;
        _pageframe.size.width = rect.size.width / _pageNum;
        _pageframe.origin.x = _pageframe.size.width * i;
        
        //创建菜单按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:_pageframe];
        button.tag = 100 + i;
        [button setTitleColor:_tabTitleColor forState:UIControlStateNormal];
        [button setTitleColor:_tabSelectedTitleColor forState:UIControlStateSelected];
        [button setBackgroundColor:_tabBgColor];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(tabBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //创建菜单右侧小图标
        if (_titleIconsArray.count) {
            [button setImage:_titleIconsArray[i] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        if (_selectedIconsArray.count) {
            [button setImage:_selectedIconsArray[i] forState:UIControlStateSelected];
        }
        DLog(@"titleLabel.frame:x:%lf width:%lf height:%lf",button.titleLabel.frame.origin.x,button.titleLabel.frame.size.width,button.titleLabel.frame.size.height);
        
        //创建菜单按钮右上角的小红点
        UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getLabelWidth:_titleArray[i] fontSize:15]/2+button.titleLabel.frame.origin.x, 2, 16, 16)];
        circleLabel.backgroundColor = [UIColor redColor];
        circleLabel.textColor = [UIColor whiteColor];
        circleLabel.font = [UIFont systemFontOfSize:12];
        circleLabel.textAlignment = NSTextAlignmentCenter;
        circleLabel.tag = 600 +i;
        circleLabel.layer.cornerRadius = 8;
        circleLabel.layer.masksToBounds = YES;
        circleLabel.clipsToBounds = YES;
        circleLabel.text = [_tipsCountArray[i] integerValue]>99?@"99+":[NSString stringWithFormat:@"%@",_tipsCountArray[i]];
        CGRect cFrame = circleLabel.frame;
        cFrame.size.width = [self getLabelWidth:circleLabel.text fontSize:12]+6>16?[self getLabelWidth:circleLabel.text fontSize:12]+6:16;
        
        circleLabel.frame = cFrame;
        
        if (_tipsCountShowType == YFViewPagerTipsCountShowTypeRedDot) {
            CGPoint center = circleLabel.center;
            CGRect frame = circleLabel.frame;
            frame.size.width = 6;
            frame.size.height = 6;
            circleLabel.frame = frame;
            circleLabel.text = @"";
            circleLabel.layer.cornerRadius = 3;
            circleLabel.center = center;
        }

        circleLabel.tag = 0x2016+i;
        
        if (_tipsCountArray == nil || _tipsCountArray.count == 0 || [_tipsCountArray[i] integerValue] <= 0) {
            circleLabel.hidden = YES;
        }else{
            circleLabel.hidden = NO;
        }
        
        //创建中间分割线
        if (_showVLine) {
            UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 10, 1, button.frame.size.height - 20)];
            vlabel.backgroundColor = _bottomLineBgColor;
            [button addSubview:vlabel];
            
            if (!i) {
                vlabel.hidden = YES;
            }
        }
        
        if (!i) {
            button.selected = YES;
        }
//        if (button.selected) {
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                selectedLabel.center = CGPointMake(button.center.x, selectedLabel.center.y);
//                [button setBackgroundColor:_tabSelectedBgColor];
//            }];
//        }
        [button addSubview:circleLabel];
        [_pageControl addSubview:button];
    }
    
    [_pageControl addSubview:label];
    [_pageControl addSubview:selectedLabel];
    
    if (_pageNum == 1) {
        _pageControl.hidden = YES;
    }
    
    if (_enabledScroll) {
        [_scrollView setContentSize:CGSizeMake(rect.size.width * _views.count + 1, rect.size.height - 2)];
    }else{
        [_scrollView setContentSize:CGSizeZero];
    }
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width*self.selectIndex, 0);
    [self setSelectIndex:self.selectIndex];
}

//按钮的点击事件
- (void)tabBtnClicked:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    if (_showAnimation) {
        [UIView beginAnimations:@"navTab" context:nil];
        [UIView setAnimationDuration:0.3];
        [self setSelectIndex:index];
        _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0);
        [UIView commitAnimations];
    }else{
        [self setSelectIndex:index];
        _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0);
    }
}

//设置选择的按钮索引 触发的方法
- (void)setSelectIndex:(NSInteger)index
{
    _selectIndex = index;
    if(_block){
        _block(self,index);
    }
    for (NSInteger i = 0; i<_pageNum; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        btn.backgroundColor = _tabBgColor;
        btn.selected = NO;
    }
    
    UIButton *button = (UIButton *)[_pageControl viewWithTag:index + 100];
    UILabel *selectedLabel = (UILabel *)[_pageControl viewWithTag:300];
    button.backgroundColor = _tabSelectedBgColor;
    button.selected = YES;
    
    if (_showAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            selectedLabel.center = CGPointMake(button.center.x, selectedLabel.center.y);
        }];
    }else{
        selectedLabel.center = CGPointMake(button.center.x, selectedLabel.center.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.frame.size.width;
    [self setSelectIndex:index];
}

- (void)setTabSelectedBgColor:(UIColor *)tabSelectedBgColor
{
    _tabSelectedBgColor = tabSelectedBgColor;
    [self setNeedsDisplay];
}

- (void)didSelectedBlock:(SelectedBlock)block
{
    _block = block;
}

- (NSInteger)getLabelWidth:(NSString *)string fontSize:(CGFloat)size
{
    CGSize stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    CGFloat width = stringSize.width;
    return width;
}

#pragma mark - version 2.0

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray<NSString *> *)titles
              icons:(NSArray<UIImage *> *)icons
      selectedIcons:(NSArray<UIImage *> *)selectedIcons
              views:(NSArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = views;
        _titleArray = titles;
        _titleIconsArray = icons;
        _selectedIconsArray = selectedIcons;
        self.backgroundColor = [UIColor grayColor];
        [self configSelf];
    }
    return self;
}

- (void)setTitleIconsArray:(NSArray<UIImage *> *)icons
        selectedIconsArray:(NSArray<UIImage *> *)selectedIcons
{
    _titleIconsArray = icons;
    _selectedIconsArray = selectedIcons;

    [self setNeedsDisplay];
}

//设置菜单标题右上角小红点上显示的数字
- (void)setTipsCountArray:(NSArray *)tips
{
    _tipsCountArray = tips;
    
    for (NSInteger i=0; i<tips.count; i++) {
        UILabel *circleLabel = [self viewWithTag:0x2016+i];
        if (_tipsCountArray == nil || _tipsCountArray.count == 0 || [_tipsCountArray[i] integerValue] <= 0) {
            circleLabel.hidden = YES;
        }else {
            circleLabel.hidden = NO;
            circleLabel.text = [_tipsCountArray[i] integerValue]>99?@"99+":[NSString stringWithFormat:@"%@",_tipsCountArray[i]];
            CGPoint center = circleLabel.center;
            
            CGRect cFrame = circleLabel.frame;
            cFrame.size.width = [self getLabelWidth:circleLabel.text fontSize:12]+6>16?[self getLabelWidth:circleLabel.text fontSize:12]+6:16;
            
            circleLabel.frame = cFrame;
            circleLabel.center = center;
        }
        
        if (_tipsCountShowType == YFViewPagerTipsCountShowTypeRedDot) {
            CGPoint center = circleLabel.center;
            CGRect frame = circleLabel.frame;
            frame.size.width = 6;
            frame.size.height = 6;
            circleLabel.frame = frame;
            circleLabel.text = @"";
            circleLabel.layer.cornerRadius = 3;
            circleLabel.center = center;
        }
    }
}

- (void)setTipsCountShowType:(YFViewPagerTipsCountShowType)tipsCountShowType
{
    if (_tipsCountShowType != tipsCountShowType) {
        _tipsCountShowType  = tipsCountShowType;
        
        [self setTipsCountArray:_tipsCountArray];
    }
}

/**
 * 获取指定view的viewController
 */
- (UIViewController *)getViewControllerOfView:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Version 3.0
- (NSString *)selectTitle
{
    return [_titleArray objectAtIndex:self.selectIndex];
}

#pragma mark - Version 3.1
- (void)setBottomLineType:(YFViewPagerBottomLineType)bottomLineType
{
    if (_bottomLineType != bottomLineType) {
        _bottomLineType = bottomLineType;

         [self setNeedsDisplay];
    }
}

@end
