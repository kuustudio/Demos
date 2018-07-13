//
//  FlyObject.m
//  Runtime+Demo
//
//  Created by qiuShan on 2018/3/8.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyObject.h"
#import <objc/runtime.h>

@implementation FlyObject

//+ (void)load
//{
//    objc_allocateClassPair([FlyObject class], <#const char * _Nonnull name#>, <#size_t extraBytes#>)
//}

//  第一步
//  在没有找到方法时，会先调用此方法，可用于动态添加方法
//  返回 YES 表示相应 selector 的实现已经被找到并添加到了类中，否则返回 NO
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
}


//  第二步
//  如果第一步的返回 NO 或者直接返回了 YES 而没有添加方法，该方法被调用
//  在这个方法中，我们可以指定一个可以返回一个可以响应该方法的对象
//  如果返回 self 就会死循环
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector == @selector(length)){
        return [[NSString alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

//  第三步
//  如果 `forwardingTargetForSelector:` 返回了 nil，则该方法会被调用，系统会询问我们要一个合法的『类型编码(Type Encoding)』
//  若返回 nil，则不会进入下一步，而是无法处理消息

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

// 当实现了此方法后，-doesNotRecognizeSelector: 将不会被调用
// 如果要测试找不到方法，可以注释掉这一个方法
// 在这里进行消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    [self invocationWithSelstring:NSStringFromSelector(anInvocation.selector)];
}

- (void)invocationWithSelstring:(NSString *)selStr {
    
    // 1. 根据方法创建签名对象sig
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(notFind:)];
    
    // 2. 根据签名对象创建调用对象invocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    
    // 3. 设置调用对象的相关信息
    invocation.target = self;
    invocation.selector = @selector(notFind:);
    
    [invocation setArgument:&selStr atIndex:2];
    
    // 4. 调用方法
    [invocation invoke];
    
    // 5. 获取方法返回值
    NSNumber *num = nil;
    [invocation getReturnValue:&num];
    [invocation retainArguments];
    NSLog(@"返回值：%@",num);
    
}

- (void)notFind:(NSString *)selectorStr {
    NSLog(@"没有实现 -mysteriousMethod 方法，并且成功的转成了 -notFind 方法");
}

@end
