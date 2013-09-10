//
//  DIRDataProvider.m
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRDataProvider.h"

#import "DIRQuery.h"

@interface DIRDataProvider ()
{
	ODNode *_selectedNode;
}

@property (retain, readwrite) NSString *authenticatedAs;

@end

@implementation DIRDataProvider

+ (instancetype)sharedInstance
{
	static DIRDataProvider *sharedInstanceDIRDataProvider = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstanceDIRDataProvider = [DIRDataProvider new];
	});
	
	return sharedInstanceDIRDataProvider;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSError*)authenticateWithUsername:(NSString*)username andPassword:(NSString*)password
{
	NSError *error = nil;
	if ([_selectedNode setCredentialsWithRecordType:kODRecordTypeUsers recordName:username password:password error:&error])
	{
		self.authenticatedAs = username;
	}
	return error;
}

- (NSError*)forgetAuthentication
{
	return [self setSelectedSource:_selectedNode.nodeName];
}

- (ODRecord*)currentUser
{
	return nil;
}

- (NSArray*)availableSources
{
	NSError *err;
	NSArray *filteredNodes = nil;
	NSArray *nodes = [[ODSession defaultSession] nodeNamesAndReturnError:&err];
	
	if (!err) {
		filteredNodes = [nodes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
			return [[evaluatedObject pathComponents] count] > 2;
		}]];
	}
	
	return filteredNodes;
}

- (NSError*)setSelectedSource:(NSString *)selectedSource
{
	NSError *err = nil;
	id oldV = _selectedNode;
	self.authenticatedAs = nil;
	_selectedNode = [[ODNode alloc] initWithSession:[ODSession defaultSession]
											   name:selectedSource
											  error:&err];
	[oldV release];
	return err;
}

- (void)allEntriesOfType:(ODRecordType)recordType withQueryValue:(NSString*)queryValue andMatchType:(ODMatchType)matchType withCompletionHandler:(void(^)(NSArray* entries, NSError* error))completionHandler
{
	NSError *err = nil;
	DIRQuery *query = [DIRQuery queryWithNode:_selectedNode
							   forRecordTypes:recordType
									attribute:kODAttributeTypeAllAttributes
									matchType:matchType
								  queryValues:queryValue
							 returnAttributes:kODAttributeTypeAllAttributes
							   maximumResults:0
										error:&err];
	
	[query runQueryWithCompletionHandler:^(DIRQuery *inQuery, NSArray *inResults, NSError *inError) {
		if (!inError) {
			completionHandler(inResults, nil);
		}
		else
		{
			completionHandler(nil, inError);
		}
	}];
}

@end
