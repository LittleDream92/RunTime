//
//  NSMutableArray+Extension.m
//  MFRunTimeDemo
//
//  Created by Meng Fan on 16/6/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

/* 该方法在类或者类目第一次加载内存的时候自动调用 */
+ (void)load {
    //__NSArrayM是NSMutableArray的真正类型
    Method orginalMethods = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethods = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(gp_addObject:));
    
    /* 交换方法的实现 */
    method_exchangeImplementations(orginalMethods, newMethods);
}

/* 自定义的方法  */
- (void)gp_addObject:(id)object {
    
    //注意：该方法的调用，因为方法已经实现了交换，如果调用addobject方法，会出现死循环
    if (object != nil) {
        [self gp_addObject:object];
    }
}


@end
