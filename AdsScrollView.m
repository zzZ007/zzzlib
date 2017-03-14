//
//  AdsScrollView.m
//  XncccBox
//
//  Created by djh on 16/4/18.
//  Copyright © 2016年 bos. All rights reserved.
//

#import "AdsScrollView.h"
#import "UIImageView+WebCache.h"

@interface AdsScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *adScroll;
@property (nonatomic,strong) UIPageControl *pageControl;
//方向
@property (nonatomic) CGFloat frameWidth;//界面宽度
@property (nonatomic,strong) UIImageView *curImageView;//当前视图
@property (nonatomic,strong) UIImageView *otherImageView;//其他视图
@property (nonatomic,assign) NSInteger   curIndex;//当前索引
@property (nonatomic,assign) NSInteger   nextIndex;//下一个索引
@property (nonatomic,strong) NSMutableArray *imageArray;//图片数组

@end
@implementation AdsScrollView
@synthesize adScroll;
@synthesize pageControl;

@synthesize frameWidth;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        adScroll = [[UIScrollView alloc]initWithFrame:self.bounds];
        frameWidth = frame.size.width;
        adScroll.delegate = self;
        adScroll.showsVerticalScrollIndicator = false;
        adScroll.showsHorizontalScrollIndicator = false;
        adScroll.pagingEnabled = true;
        adScroll.scrollsToTop = false;
        adScroll.bounces = false;
        
        self.curImageView = [[UIImageView alloc]init];
        self.curImageView.clipsToBounds = YES;
        [adScroll addSubview:self.curImageView];
        
        self.otherImageView = [[UIImageView alloc]init];
        self.otherImageView.clipsToBounds = YES;
        [adScroll addSubview:self.otherImageView];
        
        [self addSubview:adScroll];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30 ;
        rect.size.height = 30;
        pageControl = [[UIPageControl alloc]initWithFrame:rect];
        pageControl.userInteractionEnabled = false;
        [self addSubview:pageControl];
    }
    
    return self;
}

// 加载图片
-(void)reloadImageArray:(NSArray *)imgArray
{
    if (!imgArray.count) {
        return;
    }
    
    _imageArray = [NSMutableArray arrayWithArray:imgArray];
    
    //防止在滚动过程中重新给imageArray赋值时报错
    if (_curIndex >= _imageArray.count) _curIndex = _imageArray.count - 1;
    self.curImageView.image = _imageArray[_curIndex];
    
    self.pageControl.numberOfPages = _imageArray.count;
    [self layoutSubviews];
}

- (void)setScrollViewContentSize {
    if (_imageArray.count > 1) {
        self.adScroll.contentSize = CGSizeMake(frameWidth * 5, 0);
        self.adScroll.contentOffset = CGPointMake(frameWidth * 2, 0);
        self.curImageView.frame = CGRectMake(frameWidth * 2, 0, frameWidth, self.frame.size.height);
        
    } else {
        //只要一张图片时，scrollview不可滚动，且关闭定时器
        self.adScroll.contentSize = CGSizeZero;
        self.adScroll.contentOffset = CGPointZero;
        self.curImageView.frame = CGRectMake(0, 0, frameWidth, self.frame.size.height);
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //有导航控制器时，会默认在scrollview上方添加64的内边距，这里强制设置为0
    adScroll.contentInset = UIEdgeInsetsZero;
    
    adScroll.frame = self.bounds;
    
    //重新计算pageControl的位置
    //    self.pagePosition = self.pagePosition;
    [self setScrollViewContentSize];
}

#pragma mark 当图片滚动过半时就修改当前页码
- (void)changeCurrentPageWithOffset:(CGFloat)offsetX {
    if (offsetX < frameWidth * 1.5) {
        NSInteger index = self.curIndex - 1;
        if (index < 0) index = self.imageArray.count - 1;
        pageControl.currentPage = index;
    } else if (offsetX > frameWidth * 2.5){
        pageControl.currentPage = (self.curIndex + 1) % self.imageArray.count;
    } else {
        pageControl.currentPage = self.curIndex;
    }
}

#pragma mark- --------UIScrollViewDelegate--------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (CGSizeEqualToSize(CGSizeZero, scrollView.contentSize)) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    //滚动过程中改变pageControl的当前页码
    [self changeCurrentPageWithOffset:offsetX];
    
    //向右滚动
    if (offsetX < frameWidth * 2) {
        self.otherImageView.frame = CGRectMake(frameWidth, 0, frameWidth, self.frame.size.height);
        
        self.nextIndex = self.curIndex - 1;
        if (self.nextIndex < 0) self.nextIndex = self.imageArray.count - 1;
        self.otherImageView.image = self.imageArray[self.nextIndex];
        if (offsetX <= frameWidth) [self changeToNext];
        
        //向左滚动
    } else if (offsetX > frameWidth * 2){
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(_curImageView.frame), 0, frameWidth, self.frame.size.height);
        
        self.nextIndex = (self.curIndex + 1) % self.imageArray.count;
        self.otherImageView.image = self.imageArray[self.nextIndex];
        if (offsetX >= frameWidth * 3) [self changeToNext];
    }
}


- (void)changeToNext {
    
    //切换到下一张图片
    self.curImageView.image = self.otherImageView.image;
    self.adScroll.contentOffset = CGPointMake(frameWidth * 2, 0);
    [self.adScroll layoutSubviews];
    self.curIndex = self.nextIndex;
    self.pageControl.currentPage = self.curIndex;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint pointInSelf = [adScroll convertPoint:_otherImageView.frame.origin toView:self];
    if (ABS(pointInSelf.x) != frameWidth) {
        CGFloat offsetX = adScroll.contentOffset.x + pointInSelf.x;
        [self.adScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}




-(void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (self.delegate) {
        [self.delegate adsDidSelectAtIndex:_curIndex];
    }
}

@end
