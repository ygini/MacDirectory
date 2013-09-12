//
//  DIRHumanRecord.m
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRHumanRecord.h"
#import "DIRRecord_Private.h"

@implementation DIRHumanRecord

#pragma mark Smart Actions

- (void)tryToUpdateFullNameWithOldPrefix:(NSString*)prefix firstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName andSuffix:(NSString*)suffix
{
	NSArray *fullNameFormats = @[
							 @"%@ %@ %@ %@ %@",
		@"%2$@ %4$@",
		@"%4$@ %2$@"		
							 ];

	NSString *fullName = self.fullName;
	
	for (NSString *format in fullNameFormats) {
		if ([[NSString stringWithFormat:format, prefix, firstName, middleName, lastName, suffix] isEqualToString:fullName]) {
			self.fullName = [NSString stringWithFormat:format, self.prefixName, self.firstName, self.middleName, self.lastName, self.suffixName];
			break;
		}
	}
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
	[self setSimpleValue:prefixName ForAttribute:kODAttributeTypeNamePrefix];
}

-(NSString *)firstName
{
	return [self simpleValueForAttribute:kODAttributeTypeFirstName];
}

-(void)setFirstName:(NSString *)firstName
{
	NSString *oldValue = self.firstName;
	[self setSimpleValue:firstName ForAttribute:kODAttributeTypeFirstName];
	[self tryToUpdateFullNameWithOldPrefix:self.prefixName firstName:oldValue middleName:self.middleName lastName:self.lastName andSuffix:self.suffixName];
}

-(NSString *)middleName
{
	return [self simpleValueForAttribute:kODAttributeTypeMiddleName];
}

-(void)setMiddleName:(NSString *)middleName
{
	[self setSimpleValue:middleName ForAttribute:kODAttributeTypeMiddleName];
}

-(NSString *)lastName
{
	return [self simpleValueForAttribute:kODAttributeTypeLastName];
}

-(void)setLastName:(NSString *)lastName
{
	[self setSimpleValue:lastName ForAttribute:kODAttributeTypeLastName];
}

-(NSString *)suffixName
{
	return [self simpleValueForAttribute:kODAttributeTypeNameSuffix];
}

-(void)setSuffixName:(NSString *)suffixName
{
	[self setSimpleValue:suffixName ForAttribute:kODAttributeTypeNameSuffix];
}

-(NSString *)fullName
{
	return [self simpleValueForAttribute:kODAttributeTypeFullName];
}

-(void)setFullName:(NSString *)fullName
{
	[self setSimpleValue:fullName ForAttribute:kODAttributeTypeFullName];
}

-(NSString *)streetAddress
{
	return [self simpleValueForAttribute:kODAttributeTypeStreet];
}

-(void)setStreetAddress:(NSString *)streetAddress
{
	[self setSimpleValue:streetAddress ForAttribute:kODAttributeTypeStreet];
}

-(NSString *)postalCode
{
	return [self simpleValueForAttribute:kODAttributeTypePostalCode];
}

-(void)setPostalCode:(NSString *)postalCode
{
	[self setSimpleValue:postalCode ForAttribute:kODAttributeTypePostalCode];
}

-(NSString *)state
{
	return [self simpleValueForAttribute:kODAttributeTypeState];
}

-(void)setState:(NSString *)state
{
	[self setSimpleValue:state ForAttribute:kODAttributeTypeState];
}

-(NSString *)city
{
	return [self simpleValueForAttribute:kODAttributeTypeCity];
}

-(void)setCity:(NSString *)city
{
	[self setSimpleValue:city ForAttribute:kODAttributeTypeCity];
}

-(NSString *)countryCode
{
	return [self simpleValueForAttribute:kODAttributeTypeCountry];
}

-(void)setCountryCode:(NSString *)countryCode
{
	[self setSimpleValue:countryCode ForAttribute:kODAttributeTypeCountry];
}

-(NSString *)company
{
	return [self simpleValueForAttribute:kODAttributeTypeCompany];
}

-(void)setCompany:(NSString *)company
{
	[self setSimpleValue:company ForAttribute:kODAttributeTypeCompany];
}

-(NSString *)jobTitle
{
	return [self simpleValueForAttribute:kODAttributeTypeJobTitle];
}

-(void)setJobTitle:(NSString *)jobTitle
{
	[self setSimpleValue:jobTitle ForAttribute:kODAttributeTypeJobTitle];
}

-(NSString *)department
{
	return [self simpleValueForAttribute:kODAttributeTypeDepartment];
}

-(void)setDepartment:(NSString *)department
{
	[self setSimpleValue:department ForAttribute:kODAttributeTypeDepartment];
}

-(NSString *)weblog
{
	return [self simpleValueForAttribute:kODAttributeTypeWeblogURI];
}

-(void)setWeblog:(NSString *)weblog
{
	[self setSimpleValue:weblog ForAttribute:kODAttributeTypeWeblogURI];
}

-(NSString *)website
{
	return [self simpleValueForAttribute:kODAttributeTypeURL];
}

-(void)setWebsite:(NSString *)website
{
	[self setSimpleValue:website ForAttribute:kODAttributeTypeURL];
}

-(NSString *)comment
{
	return [self simpleValueForAttribute:kODAttributeTypeComment];
}

-(void)setComment:(NSString *)comment
{
	[self setSimpleValue:comment ForAttribute:kODAttributeTypeComment];
}

@end
