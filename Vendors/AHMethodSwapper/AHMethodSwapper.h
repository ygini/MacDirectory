//
//  AHMethodSwapper.h
//  SIMBLABCardDavLogguerPlugin
//
//  Created by Aurelien Hugele on 20/11/12.
//  Copyright (c) 2012 stardav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-class.h>

@interface AHMethodSwapper : NSObject

+(void)setTargetClass:(Class)aTargetClass;

+(BOOL)swapMethodNamed:(NSString*)aMethodName ofClassNamed:(NSString *)aClassName withTargetMethod:(SEL)targetSelector;
+(BOOL)swapMethodNamed:(NSString*)sourceMethodName ofClassNamed:(NSString *)sourceClassName withTargetMethod:(SEL)targetSelector ofClassNamed:(NSString *)targetClassName;

+(IMP)sourceIMPForMethodName:(NSString*)aMethodName ofClassNamed:(NSString*)aClassName;

@end
