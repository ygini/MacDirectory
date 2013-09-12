//
//  DIRRecord.h
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenDirectory/OpenDirectory.h>

@interface DIRRecord : NSObject

+ (instancetype)recordWithODRecord:(ODRecord*)odRecord;

@property (readonly, nonatomic, retain) IBOutlet NSString *smartDisplayName;
@property (readonly, nonatomic, retain) IBOutlet NSString *recordName;
@property (readonly, nonatomic, retain) IBOutlet NSString *recordType;

@end
