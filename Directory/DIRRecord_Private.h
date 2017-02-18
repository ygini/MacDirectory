//
//  DIRRecord_Private.h
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRRecord.h"

@interface DIRRecord ()

@property (readonly) ODRecord *internalRecord;

- (id)simpleValueForAttribute:(ODAttributeType)attribute;
- (BOOL)setSimpleValue:(id)value forAttribute:(ODAttributeType)attribute;

- (NSArray*)arrayValueForAttribute:(ODAttributeType)attribute;
- (BOOL)setArrayValue:(NSArray*)value forAttribute:(ODAttributeType)attribute;

@end
