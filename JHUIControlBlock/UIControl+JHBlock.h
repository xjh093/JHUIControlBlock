//
//  UIControl+JHBlock.h
//  JHKit
//
//  Created by mac1 on 2018/10/22.
//  Copyright © 2018年 HaoCold. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JHUIControlBlock)(id target, id sender);

@interface UIControl (JHBlock)

- (void)jh_handleEvent:(UIControlEvents)events inTarget:(id)target block:(JHUIControlBlock)block;

@end

NS_ASSUME_NONNULL_END
