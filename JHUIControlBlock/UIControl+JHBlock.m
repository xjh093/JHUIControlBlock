//
//  UIControl+JHBlock.m
//  JHKit
//
//  Created by mac1 on 2018/10/22.
//  Copyright © 2018年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UIControl+JHBlock.h"
#import <objc/runtime.h>

static const char *JHControlDicKey;

@interface JHUIControlWrapper : NSObject

@property (nonatomic,    weak) id target;
@property (nonatomic,    weak) id sender;
@property (nonatomic,    copy) JHUIControlBlock block;

- (id)initWithTarget:(id)target sender:(id)sender block:(JHUIControlBlock)block;

@end

@implementation JHUIControlWrapper

- (id)initWithTarget:(id)target sender:(id)sender block:(JHUIControlBlock)block{
    if (self = [super init]) {
        self.target = target;
        self.sender = sender;
        self.block = block;
    }
    return self;
}

- (void)action:(id)sender{
    self.block(_target, _sender);
}

- (void)dealloc{
    _target = nil;
    _sender = nil;
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
        
        JHUIControlWrapper *wrapper = [[JHUIControlWrapper alloc] initWithTarget:target sender:self block:block];
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
