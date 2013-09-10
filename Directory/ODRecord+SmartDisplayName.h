//
//  ODRecord+SmartDisplayName.h
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <OpenDirectory/OpenDirectory.h>

@interface ODRecord (SmartDisplayName)

@property (readonly, nonatomic, retain) IBOutlet NSString *smartDisplayName;

@end
