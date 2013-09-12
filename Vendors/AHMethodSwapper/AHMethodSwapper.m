//
//  AHMethodSwapper.m
//  SIMBLABCardDavLogguerPlugin
//
//  Created by Aurelien Hugele on 20/11/12.
//  Copyright (c) 2012 stardav. All rights reserved.
//

#import "AHMethodSwapper.h"

static Class targetClass = nil;
static CFMutableDictionaryRef sourceMethodNameToIMP = NULL;

@implementation AHMethodSwapper

+(void)setTargetClass:(Class)aTargetClass
{
    NSLog(@"%s - setTargetClass:%@",__PRETTY_FUNCTION__ ,aTargetClass);
    targetClass = [aTargetClass retain];
}

+(BOOL)swapMethodNamed:(NSString*)aMethodName ofClassNamed:(NSString *)sourceClassName withTargetMethod:(SEL)targetSelector
{
    return [self swapMethodNamed:aMethodName ofClassNamed:(NSString *)sourceClassName withTargetMethod:targetSelector ofClassNamed:NSStringFromClass(targetClass)];
}

+(BOOL)swapMethodNamed:(NSString*)sourceMethodName ofClassNamed:(NSString *)sourceClassName withTargetMethod:(SEL)targetSelector ofClassNamed:(NSString *)targetClassName
{
    if([sourceMethodName length] == 0)
    {
        NSLog(@"%s - invalid source method name!",__PRETTY_FUNCTION__);
        return NO;
    }
    
    if([sourceClassName length] == 0)
    {
        NSLog(@"%s - invalid source class name!",__PRETTY_FUNCTION__);
        return NO;
    }
    
    if([targetClassName length] == 0)
    {
        NSLog(@"%s - invalid target class name!",__PRETTY_FUNCTION__);
        return NO;
    }
    
    Class sourceClass = NSClassFromString(sourceClassName);
    if(sourceClass ==  Nil)
    {
        NSLog(@"%s - invalid source class:%@ (Can't find it with NSClassFromString!)",__PRETTY_FUNCTION__,sourceClassName);
        return NO;
    }
    
    Class targetClass = NSClassFromString(targetClassName);
    if(targetClass ==  Nil)
    {
        NSLog(@"%s - invalid target class:%@ (Can't find it with NSClassFromString!)",__PRETTY_FUNCTION__,targetClassName);
        return NO;
    }
    
    if(targetSelector == NULL)
    {
        NSLog(@"%s - invalid target selector!",__PRETTY_FUNCTION__);
        return NO;
    }
    
    if(sourceMethodNameToIMP == NULL)
    {
        CFDictionaryValueCallBacks pointerValueCallBacks = {0,NULL,NULL,NULL,NULL};
        sourceMethodNameToIMP = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFCopyStringDictionaryKeyCallBacks, &pointerValueCallBacks);
    }
    
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    if(!targetMethod)
    {
        NSLog(@"%s - can't find target selector:%@ in target Class:%@",__PRETTY_FUNCTION__,NSStringFromSelector(targetSelector),targetClassName);
        return NO;
    }
    
    SEL sourceSelector = NSSelectorFromString(sourceMethodName);
    if(sourceSelector == NULL)
    {
        NSLog(@"%s - can't find source selector:%@",__PRETTY_FUNCTION__,sourceMethodName);
        return NO;        
    }
    
    Method sourceMethod = class_getInstanceMethod(sourceClass,sourceSelector);
    if(sourceMethod == NULL)
    {
        NSLog(@"%s - can't find source Method for source selector:%@ in source class:%@",__PRETTY_FUNCTION__,sourceMethodName,sourceClassName);
        return NO;
    }

    
    // the target selector may needs to call the source selector, so we store in in sourceMethodNameToIMP dictionary
	IMP targetIMP = method_getImplementation(targetMethod);
    if(targetIMP == NULL)
    {
        NSLog(@"%s - can't find target IMP for target Method with selector:%@ in source class:%@",__PRETTY_FUNCTION__,NSStringFromSelector(targetSelector),targetClassName);
        return NO;
    }

	IMP sourceIMP = method_setImplementation(sourceMethod, targetIMP);
    if(sourceIMP == NULL)
    {
        NSLog(@"%s - can't find source IMP for source Method with selector:%@ in source class:%@",__PRETTY_FUNCTION__,sourceMethodName,sourceClassName);
        return NO;
    }
    
    // store the sourceIMP for later callback related to both method name (source and target so user can use both!)
    CFDictionaryAddValue(sourceMethodNameToIMP, [[sourceClassName stringByAppendingString:@"#"] stringByAppendingString:sourceMethodName], sourceIMP);
    CFDictionaryAddValue(sourceMethodNameToIMP, [[targetClassName stringByAppendingString:@"#"] stringByAppendingString:NSStringFromSelector(targetSelector)], sourceIMP);
    
    NSLog(@"Swapped '%@' of '%@' with '%@'",sourceMethodName,sourceClassName,NSStringFromSelector(targetSelector));

    return YES;
}

+(IMP)sourceIMPForMethodName:(NSString*)aMethodName ofClassNamed:(NSString*)aClassName;
{
    if(sourceMethodNameToIMP == NULL)
        return NULL;
    
    if([aMethodName length] == 0)
    {
        NSLog(@"%s - invalid method name!",__PRETTY_FUNCTION__);
        return NULL;
    }
    
    if([aClassName length] == 0)
    {
        NSLog(@"%s - invalid class name!",__PRETTY_FUNCTION__);
        return NULL;
    }

    
    return CFDictionaryGetValue(sourceMethodNameToIMP, [[aClassName stringByAppendingString:@"#"] stringByAppendingString:aMethodName]);
}


@end
