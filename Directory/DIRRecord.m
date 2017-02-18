//
//  DIRRecord.m
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRRecord.h"

#import "DIRHumanRecord.h"

@interface DIRRecord ()
@property ODRecord *internalRecord;
@end

@implementation DIRRecord

#pragma mark - Object lifecycle

+ (instancetype)recordWithODRecord:(ODRecord*)odRecord
{
	Class FinalClass = [DIRRecord class];
	if ([kODRecordTypeUsers isEqualToString:odRecord.recordType] ||
		[kODRecordTypePeople isEqualToString:odRecord.recordType]) {
		FinalClass = [DIRHumanRecord class];
	}
	DIRRecord *record = [FinalClass new];
	record.internalRecord = odRecord;
	return record;
}


#pragma mark - Internal Record API

- (id)simpleValueForAttribute:(ODAttributeType)attribute
{
	NSError *err = nil;
	id object = [[self.internalRecord valuesForAttribute:attribute
												   error:&err]
				 lastObject];
	
	if (err)
	{
		NSLog(@"Unable to retrive %@ from %@:\n%@", attribute, self.internalRecord.recordName, err);
	}
	
	return object;
}

- (BOOL)setSimpleValue:(id)value forAttribute:(ODAttributeType)attribute
{
	NSError *err = nil;
	if (value) {
		[self.internalRecord setValue:[NSArray arrayWithObject:value]
						 forAttribute:attribute
								error:&err];
	}
	else
	{
		[self.internalRecord removeValuesForAttribute:attribute
												error:&err];
	}
	
	if (err)
	{
		[NSApp presentError:err];
		return NO;
	}
	
	return YES;
}

- (NSArray*)arrayValueForAttribute:(ODAttributeType)attribute
{
	NSError *err = nil;
	id object = [NSMutableArray array];
	
	for (NSString *value in [self.internalRecord valuesForAttribute:attribute
															  error:&err]) {
		[object addObject:[NSMutableDictionary dictionaryWithObject:value forKey:@"value"]];
	}
	
	if (err)
	{
		NSLog(@"Unable to retrive %@ from %@:\n%@", attribute, self.internalRecord.recordName, err);
	}
	
	return object;
}

- (BOOL)setArrayValue:(NSArray*)value forAttribute:(ODAttributeType)attribute
{
	NSError *err = nil;
	if (value) {
		NSMutableArray *finalValues = [NSMutableArray array];
		NSString *val = nil;
		for (NSDictionary *dict in value) {
			val = [dict valueForKey:@"value"];
			if (!val) {
				val = @"";
			}
			[finalValues addObject:val];
		}
		
		[self.internalRecord setValue:finalValues
						 forAttribute:attribute
								error:&err];
	}
	else
	{
		[self.internalRecord removeValuesForAttribute:attribute
												error:&err];
	}
	
	if (err)
	{
		[NSApp presentError:err];
		return NO;
	}
	
	return YES;
}

#pragma mark Mapping

-(NSString *)recordName
{
	return [self.internalRecord recordName];
}

- (NSString *)recordType
{
	return [self.internalRecord recordType];
}

-(NSString *)smartDisplayName
{
	return [self.internalRecord recordName];
}

@end
