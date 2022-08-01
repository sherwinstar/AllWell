//
//  UIImageView+Loading.h
//  GegeTuan
//
//  Created by kiefer on 16/1/18.
//  Copyright (c) 2016年 xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

@interface UIImageView (Loading) <CAAnimationDelegate>

/**
 *  加载网络图片
 *
 *  @param url      图片url
 *  @param animated 淡入淡出动画
 */
- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated;

/**
 *  加载网络图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图
 *  @param animated    淡入淡出动画
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated;

/**
 *  加载网络图片
 *
 *  @param url            图片url
 *  @param placeholder    占位图
 *  @param animated       淡入淡出动画
 *  @param completed      图片加载完成Block
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated completed:(void (^)(UIImage *image))completed;

@end
