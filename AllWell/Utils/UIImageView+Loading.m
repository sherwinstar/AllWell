//
//  UIImageView+Loading.m
//  GegeTuan
//
//  Created by kiefer on 16/1/18.
//  Copyright (c) 2016年 xiaojian. All rights reserved.
//

#import "UIImageView+Loading.h"

static const CGFloat kImageFadeDuration = 0.6;

@implementation UIImageView (Loading)

/**
 *  加载网络图片
 *
 *  @param url      图片url
 *  @param animated 淡入淡出动画
 */
- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated {
    [self setImageWithURL:url placeholderImage:nil animated:animated];
}

/**
 *  加载网络图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图
 *  @param animated    淡入淡出动画
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated {
    [self setImageWithURL:url placeholderImage:placeholder animated:animated completed:nil];
}

/**
 *  加载网络图片
 *
 *  @param url            图片url
 *  @param placeholder    占位图
 *  @param animated       淡入淡出动画
 *  @param completed 图片加载完成Block
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated completed:(void (^)(UIImage *image))completed {
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (imageURL.absoluteString.length > 0) {
            weakSelf.contentMode = UIViewContentModeScaleAspectFill;
            if (completed) {
                completed(image);
            }
            if (cacheType == SDImageCacheTypeNone && animated) {
                CATransition *anim = [CATransition animation];
                anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                anim.duration = kImageFadeDuration;
                anim.type = kCATransitionFade;
                anim.delegate = weakSelf;
                [weakSelf.layer addAnimation:anim forKey:@"fade"];
            }
        }
    }];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) [self.layer removeAnimationForKey:@"fade"];
}

@end
