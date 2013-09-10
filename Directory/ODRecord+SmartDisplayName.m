//
//  ODRecord+SmartDisplayName.m
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "ODRecord+SmartDisplayName.h"

#import "DIRDataHelper.h"

@implementation ODRecord (SmartDisplayName)

-(NSString *)smartDisplayName
{
	if ([kODRecordTypeUsers isEqualToString:self.recordType] ||
		[kODRecordTypePeople isEqualToString:self.recordType]) {
		return self.recordName;
//		return [self displayNameForHumanRecord];
	}
	else
	{
		return self.recordName;
	}
}

- (NSString*)displayNameForHumanRecord
{
	NSError *err = nil;
	NSArray *values = nil;
	NSString *firstName = nil;
	NSString *lastName = nil;
	
	// Fullname
	values = [self valuesForAttribute:kODAttributeTypeFullName
								error:&err];
	
	if (err) {
		NSLog(@"Error when retriving fullname for %@", self.recordName);
		NSLog(@"Error when retriving fullname for %@", err);
		err = nil;
	}
	else if ([values count] > 1)
	{
		NSLog(@"Error, multiple fullname available %@", values);
	}
	else if ([values count] == 1)
	{
		return [values lastObject];
	}
	// -Fullname
	
	// Firstname
	values = [self valuesForAttribute:kODAttributeTypeFirstName
								error:&err];
	
	if (err) {
		NSLog(@"Error when retriving firstname for %@", self.recordName);
		NSLog(@"Error when retriving firstname for %@", err);
		err = nil;
	}
	else if ([values count] > 1)
	{
		NSLog(@"Error, multiple firstname available %@", values);
	}
	else if ([values count] == 1)
	{
		firstName = [values lastObject];
	}
	// -Firstname
	
	// Lastname
	values = [self valuesForAttribute:kODAttributeTypeLastName
								error:&err];
	
	if (err) {
		NSLog(@"Error when retriving lastname for %@", self.recordName);
		NSLog(@"Error when retriving lastname for %@", err);
		err = nil;
	}
	else if ([values count] > 1)
	{
		NSLog(@"Error, multiple firstname lastname %@", values);
	}
	else if ([values count] == 1)
	{
		lastName = [values lastObject];
	}
	// -Lastname
	
	if (firstName && lastName)
	{
		return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	}
	else if (firstName)
	{
		return firstName;
	}
	else if (lastName)
	{
		return lastName;
	}
	
	return self.recordName;
}

@end
