//
//  DIRDataViewControllerForHuman.m
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRDataViewControllerForHuman.h"

@interface DIRDataViewControllerForHuman ()
{
	NSArray *_stringProperties;
}

@end

@implementation DIRDataViewControllerForHuman

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_stringProperties = @[
						  @{@"displayName": kODAttributeTypeFullName},
		@{@"prefix": kODAttributeTypeNamePrefix},
		@{@"firstname": kODAttributeTypeFirstName},
		@{@"middlename": kODAttributeTypeMiddleName},
		@{@"lastname": kODAttributeTypeLastName},
		@{@"suffix": kODAttributeTypeNameSuffix},
		@{@"address1": kODAttributeTypeAddressLine1},
		@{@"address2": kODAttributeTypeAddressLine2},
		@{@"address3": kODAttributeTypeAddressLine3},
		@{@"postalCode": kODAttributeTypePostalCode},
		@{@"state": kODAttributeTypeState},
		@{@"city": kODAttributeTypeCity},
		@{@"countryCode": kODAttributeTypeCountry},
		@{@"company": kODAttributeTypeCompany},
		@{@"jobTitle": kODAttributeTypeJobTitle},
		@{@"department": kODAttributeTypeDepartment},
		@{@"website": kODAttributeTypeWeblogURI},
		@{@"weblog": kODAttributeTypeURL},
		@{@"comments": kODAttributeTypeComment}
		];
		[_stringProperties retain];
	}
    
    return self;
}

- (void)dealloc
{
    [_stringProperties release];
    [super dealloc];
}

-(NSSize)minimumDisplaySize
{
	return NSMakeSize(687, 647);
}

- (void)reloadData
{
	ODRecord *record = self.record;
	NSArray *values = nil;
	NSData *data = nil;
	NSImage *image = nil;
	NSError *err = nil;
	
	for (NSDictionary *propertySet in _stringProperties) {
		values = [record valuesForAttribute:[[propertySet allValues] lastObject] error:&err];
		[self setValue:[values lastObject] forKey:[[propertySet allKeys] lastObject]];
		if (err) {
			NSLog(@"Error when retriving %@:\n%@", [[propertySet allValues] lastObject], err);
		}
	}
	
	
	values = [record valuesForAttribute:kODAttributeTypeJPEGPhoto error:&err];
	data = [values lastObject];
	image = [[NSImage alloc] initWithData:data];
	self.picture = image;
	[image release], image = nil;
	if (err) {
		NSLog(@"Error when retriving %@:\n%@", kODAttributeTypeJPEGPhoto, err);
	}
}

-(void)saveAction
{
	[[[self.view window] firstResponder] resignFirstResponder];
	
	ODRecord *record = self.record;
	NSData *data = nil;
	NSError *err = nil;
	NSString *stringValue;
	
	for (NSDictionary *propertySet in _stringProperties) {
		stringValue = [self valueForKey:[[propertySet allKeys] lastObject]];
		if ([stringValue length] > 0) {
			NSLog(@"set %@ for %@ to %@", stringValue, [[propertySet allValues] lastObject], record.recordName);
			[record setValue:[NSArray arrayWithObject:stringValue]
				forAttribute:[[propertySet allValues] lastObject]
					   error:&err];

		}
		else
		{			
			[record removeValuesForAttribute:[[propertySet allValues] lastObject]
									   error:&err];
		}
		if (err) {
			NSLog(@"Error when saving %@:\n%@", [[propertySet allValues] lastObject], err);
		}
	}
	
	data = [((NSBitmapImageRep *)[[self.picture representations] objectAtIndex:0]) representationUsingType:NSJPEGFileType
																								properties:nil];
	if (data) {
		[record setValue:[NSArray arrayWithObject:data]
			forAttribute:kODAttributeTypeJPEGPhoto
				   error:&err];
	}
	else
	{
		[record removeValuesForAttribute:kODAttributeTypeJPEGPhoto
								   error:&err];
	}
	
	if (err) {
		NSLog(@"Error when saving %@:\n%@", kODAttributeTypeJPEGPhoto, err);
	}
}

@end
