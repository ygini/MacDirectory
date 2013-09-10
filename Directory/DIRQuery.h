//
//  DIRQuery.h
//  Directory
//
//  Created by Yoann Gini on 04/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <OpenDirectory/OpenDirectory.h>

@class DIRQuery;

typedef void(^DIRQueryCompletionHandler)(DIRQuery *inQuery, NSArray *inResults, NSError *inError);

#define kDIRQueryAlreadyUsedException		@"kDIRQueryAlreadyUsedException"

@interface DIRQuery : ODQuery

+(instancetype)queryWithNode:(ODNode *)inNode forRecordTypes:(id)inRecordTypeOrList attribute:(ODAttributeType)inAttribute matchType:(ODMatchType)inMatchType queryValues:(id)inQueryValueOrList returnAttributes:(id)inReturnAttributeOrList maximumResults:(NSInteger)inMaximumResults error:(NSError **)outError;

- (void)runQueryWithCompletionHandler:(DIRQueryCompletionHandler)completionHandler;
- (void)runQueryWithCompletionHandler:(DIRQueryCompletionHandler)completionHandler onRunLoop:(NSRunLoop*)runLoop withMode:(NSString*)runLoopMode;

@end
