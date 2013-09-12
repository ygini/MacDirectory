//
//  DIRQuery.m
//  Directory
//
//  Created by Yoann Gini on 04/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRQuery.h"
#import "DIRRecord.h"

@interface DIRQuery () <ODQueryDelegate>
{
	DIRQueryCompletionHandler _completionHandler;
}

@end

@implementation DIRQuery

#pragma mark Object lifecycle

- (void)dealloc
{
    [_completionHandler release], _completionHandler = nil;
    [super dealloc];
}

#pragma mark Overriding

+(instancetype)queryWithNode:(ODNode *)inNode forRecordTypes:(id)inRecordTypeOrList attribute:(ODAttributeType)inAttribute matchType:(ODMatchType)inMatchType queryValues:(id)inQueryValueOrList returnAttributes:(id)inReturnAttributeOrList maximumResults:(NSInteger)inMaximumResults error:(NSError **)outError
{
	return (DIRQuery *)[super queryWithNode:inNode forRecordTypes:inRecordTypeOrList attribute:inAttribute matchType:inMatchType queryValues:inQueryValueOrList returnAttributes:inReturnAttributeOrList maximumResults:inMaximumResults error:outError];
}

#pragma mark Addons

- (void)runQueryWithCompletionHandler:(DIRQueryCompletionHandler)completionHandler
{
	[self runQueryWithCompletionHandler:completionHandler onRunLoop:[NSRunLoop currentRunLoop] withMode:NSDefaultRunLoopMode];
}

- (void)runQueryWithCompletionHandler:(DIRQueryCompletionHandler)completionHandler onRunLoop:(NSRunLoop*)runLoop withMode:(NSString*)runLoopMode
{
	if (!_completionHandler) {
		_completionHandler = [completionHandler copy];
		
		[self setDelegate:self];
		[self scheduleInRunLoop:runLoop forMode:runLoopMode];
	}
	else
	{
		[NSException raise:kDIRQueryAlreadyUsedException format:@"Trying to run an already used query, behavior not supported"];
	}
}

#pragma mark self delegate

-(void)query:(DIRQuery *)inQuery foundResults:(NSArray *)inResults error:(NSError *)inError
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[inResults count]];
	
	for (ODRecord *record in inResults) {
		[results addObject:[DIRRecord recordWithODRecord:record]];
	}
	
	_completionHandler(inQuery, results, inError);
}

@end
