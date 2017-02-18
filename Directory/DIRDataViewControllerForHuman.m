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
}

@end

@implementation DIRDataViewControllerForHuman

@dynamic record;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

	}
    
    return self;
}


-(NSSize)minimumDisplaySize
{
	return NSMakeSize(687, 562);
}

@end
