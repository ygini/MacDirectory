//
//  DIRDataViewController.m
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRDataViewController.h"

#import "DIRDataViewControllerForHuman.h"

@interface DIRDataViewController ()
+ (void)registerDefaultRecordTypeToClassName;
@end

@implementation DIRDataViewController

static NSMutableDictionary * DIRDataViewController_recordTypeToClassName = nil;

+(void)load
{
	[self registerDefaultRecordTypeToClassName];
}

+ (void)registerDefaultRecordTypeToClassName
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self registerClassName:@"DIRDataViewControllerForHuman" forRecordType:kODRecordTypePeople];
		[self registerClassName:@"DIRDataViewControllerForHuman" forRecordType:kODRecordTypeUsers];
	});
}

+ (void)registerClassName:(NSString *)className forRecordType:(NSString*)recordType
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		DIRDataViewController_recordTypeToClassName = [NSMutableDictionary new];
	});
	
	[DIRDataViewController_recordTypeToClassName setValue:className forKey:recordType];
}

+ (instancetype)newDataViewControllerForRecord:(DIRRecord*)record
{
	DIRDataViewController *viewController = [self newDataViewControllerForRecordType:record.recordType];
	viewController.record = record;
	return viewController;
}

+ (instancetype)newDataViewControllerForRecordType:(NSString*)recordType
{
	DIRDataViewController *viewController = nil;

	if (recordType) {
		NSString *className = [DIRDataViewController_recordTypeToClassName valueForKey:recordType];
		
		if (className)
		{
			Class TargetClass = NSClassFromString(className);
			viewController = [[TargetClass alloc] initWithNibName:className bundle:[NSBundle bundleForClass:TargetClass]];
		}
		else
		{
			NSLog(@"No data view controller registred for record type %@", recordType);
			viewController = [[DIRDataViewController alloc] initWithNibName:@"DIRDataViewController" bundle:nil];
		}

	}
	return viewController;
}

- (NSSize)minimumDisplaySize
{
	return NSMakeSize(550, 430);
}

- (void)dealloc
{
    _record = nil;
}

@end
