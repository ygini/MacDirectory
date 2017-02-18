//
//  DIRDataViewController.h
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DIRRecord.h"

@interface DIRDataViewController : NSViewController

@property IBOutlet DIRRecord *record;

- (NSSize)minimumDisplaySize;

+ (void)registerClassName:(NSString *)className forRecordType:(NSString*)recordType;

+ (instancetype)newDataViewControllerForRecord:(DIRRecord*)record;
+ (instancetype)newDataViewControllerForRecordType:(NSString*)recordType;

@end
