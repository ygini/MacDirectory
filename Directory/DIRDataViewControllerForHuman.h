//
//  DIRDataViewControllerForHuman.h
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DIRDataViewController.h"
#import "DIRHumanRecord.h"

@interface DIRDataViewControllerForHuman : DIRDataViewController

@property IBOutlet DIRHumanRecord *record;

@end
