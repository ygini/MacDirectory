//
//  DIRHumanRecord.m
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRHumanRecord.h"
#import "DIRRecord_Private.h"

@interface DIRHumanRecord ()

@end

@implementation DIRHumanRecord

#pragma mark Smart Actions

- (void)tryToUpdateFullNameWithOldPrefix:(NSString*)prefix firstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName andSuffix:(NSString*)suffix
{
	[self willChangeValueForKey:@"smartDisplayName"];
	
	NSArray *fullNameFormats = @[
								 @"full_identity",
								 @"fisrtname_lastname",
								 @"lastname_firstname"
							 ];

	NSString *fullName = self.fullName;
	NSString *testName = nil;
	for (NSString *format in fullNameFormats) {
		testName = [NSString stringWithFormat:NSLocalizedStringFromTable(format, @"DIRHumanRecord", @""), prefix, firstName, middleName, lastName, suffix];
		if ([testName isEqualToString:fullName]) {
			self.fullName = [NSString stringWithFormat:format, self.prefixName, self.firstName, self.middleName, self.lastName, self.suffixName];
			break;
		}
	}
	[self didChangeValueForKey:@"smartDisplayName"];
}

#pragma mark Mapping

-(NSString *)smartDisplayName
{
	NSString *firstName = nil;
	NSString *lastName = nil;
	
	NSString *fullName = self.fullName;
	if ([fullName length] > 0) {
		return fullName;
	}

	firstName = self.firstName;
	lastName = self.lastName;
	
	if ([firstName length] > 0 && [lastName length] > 0)
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
	
	return [self recordName];
}

-(NSString *)prefixName
{
	return [self simpleValueForAttribute:kODAttributeTypeNamePrefix];
}

-(void)setPrefixName:(NSString *)prefixName
{
	NSString *oldValue = self.prefixName;
	[self setSimpleValue:prefixName forAttribute:kODAttributeTypeNamePrefix];
	[self tryToUpdateFullNameWithOldPrefix:oldValue firstName:self.firstName middleName:self.middleName lastName:self.lastName andSuffix:self.suffixName];
}

-(NSString *)firstName
{
	return [self simpleValueForAttribute:kODAttributeTypeFirstName];
}

-(void)setFirstName:(NSString *)firstName
{
	NSString *oldValue = self.firstName;
	[self setSimpleValue:firstName forAttribute:kODAttributeTypeFirstName];
	[self tryToUpdateFullNameWithOldPrefix:self.prefixName firstName:oldValue middleName:self.middleName lastName:self.lastName andSuffix:self.suffixName];
}

-(NSString *)middleName
{
	return [self simpleValueForAttribute:kODAttributeTypeMiddleName];
}

-(void)setMiddleName:(NSString *)middleName
{
	NSString *oldValue = self.middleName;
	[self setSimpleValue:middleName forAttribute:kODAttributeTypeMiddleName];
	[self tryToUpdateFullNameWithOldPrefix:self.prefixName firstName:self.firstName middleName:oldValue lastName:self.lastName andSuffix:self.suffixName];
}

-(NSString *)lastName
{
	return [self simpleValueForAttribute:kODAttributeTypeLastName];
}

-(void)setLastName:(NSString *)lastName
{
	NSString *oldValue = self.lastName;
	[self setSimpleValue:lastName forAttribute:kODAttributeTypeLastName];
	[self tryToUpdateFullNameWithOldPrefix:self.prefixName firstName:self.firstName middleName:self.middleName lastName:oldValue andSuffix:self.suffixName];
}

-(NSString *)suffixName
{
	return [self simpleValueForAttribute:kODAttributeTypeNameSuffix];
}

-(void)setSuffixName:(NSString *)suffixName
{
	NSString *oldValue = self.suffixName;
	[self setSimpleValue:suffixName forAttribute:kODAttributeTypeNameSuffix];
	[self tryToUpdateFullNameWithOldPrefix:self.prefixName firstName:self.firstName middleName:self.middleName lastName:self.lastName andSuffix:oldValue];
}

-(NSString *)fullName
{
	return [self simpleValueForAttribute:kODAttributeTypeFullName];
}

-(void)setFullName:(NSString *)fullName
{
	[self willChangeValueForKey:@"smartDisplayName"];
	[self setSimpleValue:fullName forAttribute:kODAttributeTypeFullName];
	[self didChangeValueForKey:@"smartDisplayName"];
}

-(NSString *)streetAddress
{
	return [self simpleValueForAttribute:kODAttributeTypeStreet];
}

-(void)setStreetAddress:(NSString *)streetAddress
{
	[self setSimpleValue:streetAddress forAttribute:kODAttributeTypeStreet];
}

-(NSString *)postalCode
{
	return [self simpleValueForAttribute:kODAttributeTypePostalCode];
}

-(void)setPostalCode:(NSString *)postalCode
{
	[self setSimpleValue:postalCode forAttribute:kODAttributeTypePostalCode];
}

-(NSString *)state
{
	return [self simpleValueForAttribute:kODAttributeTypeState];
}

-(void)setState:(NSString *)state
{
	[self setSimpleValue:state forAttribute:kODAttributeTypeState];
}

-(NSString *)city
{
	return [self simpleValueForAttribute:kODAttributeTypeCity];
}

-(void)setCity:(NSString *)city
{
	[self setSimpleValue:city forAttribute:kODAttributeTypeCity];
}

-(NSString *)countryCode
{
	return [self simpleValueForAttribute:kODAttributeTypeCountry];
}

-(void)setCountryCode:(NSString *)countryCode
{
	[self setSimpleValue:countryCode forAttribute:kODAttributeTypeCountry];
}

-(NSString *)company
{
	return [self simpleValueForAttribute:kODAttributeTypeCompany];
}

-(void)setCompany:(NSString *)company
{
	[self setSimpleValue:company forAttribute:kODAttributeTypeCompany];
}

-(NSString *)jobTitle
{
	return [self simpleValueForAttribute:kODAttributeTypeJobTitle];
}

-(void)setJobTitle:(NSString *)jobTitle
{
	[self setSimpleValue:jobTitle forAttribute:kODAttributeTypeJobTitle];
}

-(NSString *)department
{
	return [self simpleValueForAttribute:kODAttributeTypeDepartment];
}

-(void)setDepartment:(NSString *)department
{
	[self setSimpleValue:department forAttribute:kODAttributeTypeDepartment];
}

-(NSString *)weblog
{
	return [self simpleValueForAttribute:kODAttributeTypeWeblogURI];
}

-(void)setWeblog:(NSString *)weblog
{
	[self setSimpleValue:weblog forAttribute:kODAttributeTypeWeblogURI];
}

-(NSString *)website
{
	return [self simpleValueForAttribute:kODAttributeTypeURL];
}

-(void)setWebsite:(NSString *)website
{
	[self setSimpleValue:website forAttribute:kODAttributeTypeURL];
}

-(NSString *)comment
{
	return [self simpleValueForAttribute:kODAttributeTypeComment];
}

-(void)setComment:(NSString *)comment
{
	[self setSimpleValue:comment forAttribute:kODAttributeTypeComment];
}

-(NSArray *)phones
{
	return [self arrayValueForAttribute:kODAttributeTypePhoneNumber];
}

-(void)setPhones:(NSArray *)phones
{
	[self setArrayValue:phones forAttribute:kODAttributeTypePhoneNumber];
	
}

-(NSArray *)emails
{
	return [self arrayValueForAttribute:kODAttributeTypeEMailAddress];
}

-(void)setEmails:(NSArray *)emails
{
	[self setArrayValue:emails forAttribute:kODAttributeTypeEMailAddress];
	
}

-(NSArray *)instantMessaging
{
	return [self arrayValueForAttribute:kODAttributeTypeIMHandle];
}

-(void)setInstantMessaging:(NSArray *)instantMessaging
{
	[self setArrayValue:instantMessaging forAttribute:kODAttributeTypeIMHandle];
}

@end
