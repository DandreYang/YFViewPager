//
//  YFViewPager-Swift.swift
//  YFViewPager
//
//  Created by 杨枫 on 15/11/7.
//  Copyright © 2015年 Saxue. All rights reserved.
//

import UIKit

class YFViewPager_Swift: UIView {


    var _pageNum:Int = 0;
    
    var _titleArray:Array<String>?;           /**< 菜单标题 */
    var _views:Array<UIView>!;                /**< 视图 */
    var _titleIconsArray:Array<UIImage>?;      /**< 菜单标题左侧的小图标 */
    var _selectedIconsArray:Array<UIImage>?;   /**< 菜单被选中时左侧的小图标 */
    var _tipsCountArray:Array<String>?;       /**< 菜单右上角的小红点显示的数量 */
    
    
    var scrollView:UIScrollView!
    var pageControl:UIView!
    
    /**
     *  设置viewPager是否允许滚动 默认支持
     */
    var enabledScroll:Bool!
    
    /**
     *  当前选择的菜单索引
     */
    var selectIndex:NSInteger!
    
    /**
     *  菜单按钮背景属性
     */
    var tabBgColor:UIColor!
    var tabSelectedBgColor:UIColor!
    
    /**
     *  菜单按钮下方横线背景属性
     */
    var tabArrowBgColor:UIColor!
    var tabSelectedArrowBgColor:UIColor!
    
    /**
     *  菜单按钮的标题颜色属性
     */
    var tabTitleColor:UIColor!
    var tabSelectedTitleColor:UIColor!
    
    /**
     *  是否显示垂直分割线  默认显示
     */
    var showVLine:Bool!
    
    /**
     *  是否显示底部横线  默认显示
     */
    var showBottomLine:Bool!
    
    /**
     *  选中状态是否显示底部横线  默认显示
     */
    var showSelectedBottomLine:Bool!
    
    /**
     *  是否显示垂直分割线  默认显示
     */
    var showAnimation:Bool!
    
    
    //初始化
    func initWithFrame(frame:CGRect,titles:(Array<String >)!,views:(Array<UIView>)!) -> AnyObject
    {
        var s:YFViewPager_Swift!
        s = YFViewPager_Swift.init(frame: frame)
        if ((s) != nil) {
            _views = views
            _titleArray = titles
            s.backgroundColor = UIColor.grayColor()
    
            s.configSelf()
        }
        return s
    }
    
    //设置默认属性
    func configSelf()
    {
        
        self.userInteractionEnabled = true
        self.tabBgColor = UIColor.whiteColor()

        self.tabArrowBgColor = UIColor(red:204/255.0, green:208/255.0, blue:210/255.0, alpha:1)
        self.tabTitleColor = UIColor(red:12/255.0, green:134/255.0, blue:237/255.0, alpha:1)
        self.tabSelectedBgColor = UIColor.whiteColor()

        self.tabSelectedTitleColor = UIColor(red:12/255.0, green:134/255.0, blue:237/255.0, alpha:1)
        self.tabSelectedArrowBgColor = UIColor(red:12/255.0, green:134/255.0, blue:237/255.0, alpha:1)
        self.showVLine = true
        self.showAnimation = true
        self.showBottomLine = true
        self.showSelectedBottomLine = true
        self.enabledScroll = true
    }
    
    //视图重绘
    override func drawRect(rect:CGRect)
    {
        
        // Drawing code
        self.scrollView = UIScrollView(frame:CGRectMake(0, 2, rect.size.width, rect.size.height - 2))
        
        self.scrollView.userInteractionEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.scrollView.directionalLockEnabled = true
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        var frame:CGRect!
        frame.origin.y = 38
        frame.size.height = self.scrollView.frame.size.height - 40
        frame.size.width = rect.size.width
        
        self.pageControl = UIView(frame:CGRectMake(0, 0, rect.size.width, 40))
        
        _pageNum = _views!.count
        self.pageControl.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        
        //创建菜单按钮下划线
        
        var label =  UILabel(frame:CGRectMake(0, self.pageControl.frame.size.height - 1, self.pageControl.frame.size.width,1))
        
        label.backgroundColor = self.tabArrowBgColor
        label.tag = 200
        
        
        var selectedLabel =  UILabel(frame:CGRectMake(0, (self.pageControl.frame.size.height - 3 ), Int(self.pageControl.frame.size.width)/_pageNum, 3))
        
        selectedLabel.backgroundColor = self.tabSelectedArrowBgColor
        selectedLabel.tag = 300
        
        if (!self.showBottomLine){
            
            var labelFrame =  label.frame
            labelFrame.size.height = 0
            label.frame = labelFrame
        }
        
        if (!self.showSelectedBottomLine) {
            
            var selectedFrame =  selectedLabel.frame
            selectedFrame.size.height = 0
            selectedLabel.frame = selectedFrame
        }
        
        for (NSInteger i = 0; i < _views.count; i++) {
            //创建主视图
            
            var view =  _views.objectAtIndex(i)
            
            frame.origin.x = rect.size.width * i
            view.setFrame(frame)
            
            _scrollView.addSubview(view)
            
            
            
            var _pageframe =  self.pageControl.frame
            _pageframe.size.width = rect.size.width / _pageNum
            _pageframe.origin.x = _pageframe.size.width * i
            
            //创建菜单按钮
            
            var button =  UIButton(type:UIButtonTypeCustom)
            button.setFrame(_pageframe)
            
            button.tag = 100 + i
            button.setTitleColor(_tabTitleColor forState:UIControlStateNormal)
            
            button.setTitleColor(_tabSelectedTitleColor forState:UIControlStateSelected)
            
            button.setBackgroundColor(_tabBgColor)
            
            button.setTitle(_titleArray[i)
                forState:UIControlStateNormal]
                button.titleLabel.font = UIFont.systemFontOfSize(15)
                
                button.addTarget(self action:selector(tabBtnClicked:) forControlEvents:UIControlEventTouchUpInside)
                
                
                //创建菜单右侧小图标
                if (_titleIconsArray.count) {
                button.setImage(_titleIconsArray[i)
                forState:UIControlStateNormal]
                }
                if (_selectedIconsArray.count) {
                button.setImage(_selectedIconsArray[i)
                forState:UIControlStateSelected]
                }
                DLog("titleLabel.frame:x:%lf width:%lf height:%lf",button.titleLabel.frame.origin.x,button.titleLabel.frame.size.width,button.titleLabel.frame.size.height)
                //创建菜单按钮右上角的小红点
                
                var circleLabel =  UILabel(frame:CGRectMake([self, getLabelWidth:_titleArray[i)
                fontSize:15]/2+button.titleLabel.frame.origin.x, 2, 16, 16)]
                circleLabel.backgroundColor = UIColor.redColor()
                
                circleLabel.textColor = UIColor.whiteColor()
                
                
                
                
                
                circleLabel.font = UIFont.systemFontOfSize(12)
                
                circleLabel.textAlignment = NSTextAlignmentCenter
                circleLabel.tag = 600 +i
                circleLabel.layer.cornerRadius = 8
                circleLabel.layer.masksToBounds = true"
                circleLabel.clipsToBounds = true"
                
                if (_tipsCountArray == nil || _tipsCountArray.count == 0) {
                circleLabel.hidden = true"
        }else if ([_tipsCountArray[i] integerValue] == 0){
            circleLabel.hidden = true"
        }else{
            circleLabel.hidden = false"
            circleLabel.text = [_tipsCountArray[i] integerValue]>99?@"99+":NSString(format:"%",_tipsCountArray[i)]
            
            var center =  circleLabel.center
            
            
            var cFrame =  circleLabel.frame
            cFrame.size.width = self.getLabelWidth(circleLabel.text fontSize:12)
            
            +6>16?self.getLabelWidth(circleLabel.text fontSize:12)
            
            +6:16
            
            circleLabel.frame = cFrame
            circleLabel.center = center
            }
            
            
            if (_showVLine) {
            //创建中间分割线
            
            var vlabel =  UILabel(frame:CGRectMake(-1,, 10,, 1,, button.frame.size.height, -, 20))
            
            vlabel.backgroundColor = _tabArrowBgColor
            button.addSubview(vlabel)
            
            
            if (!i) {
            vlabel.hidden = true"
        }
    }
    
        if (!i) {
        button.selected = true"
    }
    if (button.selected) {
        UIView.animateWithDuration(0.3 animations:^{var sframe =  selectedLabel.frame                sframe.origin.x = button.frame.origin.x                selectedLabel.frame = sframe                [button setBackgroundColor:_tabSelectedBgColor)
            
            }]
    }
    button.addSubview(circleLabel)

    self.pageControl.addSubview(button)

    }

    self.pageControl.addSubview(label)

    self.pageControl.addSubview(selectedLabel)


    if (_pageNum == 1) {
        self.pageControl.hidden = true"
    }

    if (_enabledScroll) {
        _scrollView.setContentSize(CGSizeMake(rect.size.width * _views.count + 1, rect.size.height - 2))
        
    }else{
        _scrollView.setContentSize(CGSizeZero)
        
    }
    _scrollView.delegate = self
    self.addSubview(_scrollView)

    self.addSubview(self.pageControl)

    }

    //按钮的点击事件
    func tabBtnClicked(sender:UIButton)
    {
        
        
        var index =  sender.tag - 100
        
        if (_showAnimation) {
            UIView.beginAnimations("navTab" context:nil)
            
            UIView.setAnimationDuration(0.3)
            
            self.setSelectIndex(index)
            
            
            
            _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0)
            UIView.commitAnimations()
        }else{
            self.setSelectIndex(index)
            
            
            
            _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0)
        }
    }

    //设置选择的按钮索引 触发的方法
    func setSelectIndex(index:Int)
    {
        
        if(_block){
            _block(self,index)
        }
        _selectIndex = index
        for (NSInteger i = 0; i<_pageNum; i++) {
            
            var btn =  (UIButton *)self(tag:i + 100)
            btn.backgroundColor = _tabBgColor
            btn.selected = false"
        }
        
        
        var button =  (UIButton *)self.pageControl(tag:index + 100)
        
        var selectedLabel =  (UILabel *)self.pageControl(tag:300)
        button.backgroundColor = _tabSelectedBgColor
        button.selected = true"
        
        if (_showAnimation) {
            UIView.animateWithDuration(0.3 animations:^{var frame =  selectedLabel.frame            frame.origin.x = button.frame.origin.x            selectedLabel.frame = frame        })
            
        }else{
            
            var frame =  selectedLabel.frame
            frame.origin.x = button.frame.origin.x
            selectedLabel.frame = frame
        }
    }

    func scrollViewDidEndDecelerating(scrollView:UIScrollView)
    {
        
        
        var index =  scrollView.contentOffset.x/self.frame.size.width
        self.setSelectIndex(index)
        
        
        
    }

    func setTabSelectedBgColor(tabSelectedBgColor:UIColor)
    {
        
        _tabSelectedBgColor = tabSelectedBgColor
        self.setNeedsDisplay()
    }

    func didSelectedBlock(block:SelectedBlock)
    {
        
        _block = block
    }

    func getLabelWidth(string:NSString, size:CGFloat)->NSInteger
    {
        
        
        var stringSize =  string(attributes:{NSFontAttributeName:UIFont.systemFontOfSize(size)})
        
        
        var width =  stringSize.width
        var width:return!
    }

    #pragma mark - version 2.0

    func initWithFrame(frame:CGRect,            titles:(NSArray<NSString > )titles             icons:(NSArray<UIImage > )icons     selectedIcons:(NSArray<UIImage > )selectedIcons             views:(NSArray<__kindof UIView > )views)AnyObject
        {
            
            self = super(frame:frame)
            if (self) {
                _views = views
                _titleArray = titles
                _titleIconsArray = icons
                _selectedIconsArray = selectedIcons
                self.backgroundColor = UIColor.grayColor()
                
                
                self.configSelf()
            }
            var self:return!
    }

    func setTitleIconsArray((NSArray<UIImage > )icons  selectedIconsArray:(NSArray<UIImage > )selectedIcons)
    {
        
        _titleIconsArray = icons
        _selectedIconsArray = selectedIcons
        
        self.setNeedsDisplay()
    }

    //设置菜单标题右上角小红点上显示的数字
    func setTipsCountArray(tips:NSArray)
    {
        
        _tipsCountArray = tips
        self.setNeedsDisplay()
    }
    
}
