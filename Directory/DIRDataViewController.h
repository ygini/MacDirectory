//
//  DIRDataViewController.h
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <OpenDirectory/OpenDirectory.h>

@interface DIRDataViewController : NSViewController

@property (retain) ODRecord *record;

- (NSSize)minimumDisplaySize;

+ (void)registerClassName:(NSString *)className forRecordType:(NSString*)recordType;

+ (instancetype)newDataViewControllerForRecord:(ODRecord*)record;

- (void)saveAction;
- (void)cancelAction;

- (void)reloadData;

@end
