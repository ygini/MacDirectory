//
//  DIRDataHelper.h
//  Directory
//
//  Created by Yoann Gini on 04/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenDirectory/OpenDirectory.h>

@interface DIRDataHelper : NSObject

+ (NSString*)displayNameForRecord:(ODRecord*)record;

@end
