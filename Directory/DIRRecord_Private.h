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
- (BOOL)setSimpleValue:(id)value ForAttribute:(ODAttributeType)attribute;

@end
