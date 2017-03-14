//
//  AdsScrollView.h
//  XncccBox
//
//  Created by djh on 16/4/18.
//  Copyright © 2016年 bos. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AdsDidSelectDelegate<NSObject>
@optional
-(void)adsDidSelectAtIndex:(NSInteger)index;
@end
@interface AdsScrollView : UICollectionReusableView
-(void)reloadImageArray:(NSArray *)imgArray;
@property (nonatomic,assign) id<AdsDidSelectDelegate> delegate;

@end
