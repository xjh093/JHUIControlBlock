//
//  UIControl+JHBlock.m
//  JHKit
//
//  Created by mac1 on 2018/10/22.
//  Copyright © 2018年 HaoCold. All rights reserved.
//

#import "UIControl+JHBlock.h"
#import <objc/runtime.h>

static const char *JHControlDicKey;

@interface JHUIControlWrapper : NSObject

@property (nonatomic,    weak) id target;
@property (nonatomic,  assign) UIControlEvents  events;
@property (nonatomic,    copy) JHUIControlBlock block;

- (id)initWithEvents:(UIControlEvents)events target:(id)target block:(JHUIControlBlock)block;

@end

@implementation JHUIControlWrapper

- (id)initWithEvents:(UIControlEvents)events target:(id)target block:(JHUIControlBlock)block{
    if (self = [super init]) {
        self.events = events;
        self.target = target;
        self.block = block;
    }
    return self;
}

- (void)action:(id)sender{
    self.block(_target, self);
}

- (void)dealloc{
    _events = 0;
    _target = nil;
    _block = nil;
}

@end

@implementation UIControl (JHBlock)

- (void)jh_handleEvent:(UIControlEvents)events inTarget:(id)target block:(JHUIControlBlock)block{
    if (block) {
        
        NSMutableDictionary *dic = objc_getAssociatedObject(self, JHControlDicKey);
        if (!dic) {
            dic = @{}.mutableCopy;
            objc_setAssociatedObject(self, JHControlDicKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        NSNumber *key = @(events);
        NSMutableSet *set = dic[key];
        if (!set) {
            set = [NSMutableSet set];
            dic[key] = set;
        }
        
        JHUIControlWrapper *wrapper = [[JHUIControlWrapper alloc] initWithEvents:events target:target block:block];
        [set addObject:wrapper];
        [self addTarget:wrapper action:@selector(action:) forControlEvents:events];
    }
}

- (void)jh_removeEvent:(UIControlEvents)events{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, JHControlDicKey);
    if (!dic) {
        dic = @{}.mutableCopy;
        objc_setAssociatedObject(self, JHControlDicKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(events);
    NSMutableSet *set = dic[key];
    if (!set) {
        return;
    }
    
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:NULL forControlEvents:events];
    }];
    
    [dic removeObjectForKey:key];
}

@end
