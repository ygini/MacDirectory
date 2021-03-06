//
//  DIRDataProvider.h
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenDirectory/OpenDirectory.h>

#import "DIRRecord.h"

@interface DIRDataProvider : NSObject

+ (instancetype)sharedInstance;

- (NSError*)authenticateWithUsername:(NSString*)username andPassword:(NSString*)password;

@property (readonly) NSString *authenticatedAs;

- (NSError*)forgetAuthentication;

- (ODRecord*)currentUser;

- (NSArray*)availableSources;

- (NSError*)setSelectedSource:(NSString *)selectedSource;

- (void)allEntriesOfType:(ODRecordType)recordType withQueryValue:(NSString*)queryValue andMatchType:(ODMatchType)matchType withCompletionHandler:(void(^)(NSArray* entries, NSError* error))completionHandler;

- (ODRecord*)addRecordOfType:(ODRecordType)recordType withName:(NSString*)name andAttributes:(NSDictionary*)attributes;

- (void)deleteRecord:(ODRecord*)record;

@end
