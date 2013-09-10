//
//  DIRDataViewControllerForHuman.h
//  Directory
//
//  Created by Yoann Gini on 06/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DIRDataViewController.h"

@interface DIRDataViewControllerForHuman : DIRDataViewController

@property (retain) IBOutlet NSString *displayName;
@property (retain) IBOutlet NSString *prefix;
@property (retain) IBOutlet NSString *firstname;
@property (retain) IBOutlet NSString *middlename;
@property (retain) IBOutlet NSString *lastname;
@property (retain) IBOutlet NSString *suffix;
@property (retain) IBOutlet NSString *address1;
@property (retain) IBOutlet NSString *address2;
@property (retain) IBOutlet NSString *address3;
@property (retain) IBOutlet NSString *postalCode;
@property (retain) IBOutlet NSString *state;
@property (retain) IBOutlet NSString *city;
@property (retain) IBOutlet NSString *countryCode;
@property (retain) IBOutlet NSString *company;
@property (retain) IBOutlet NSString *jobTitle;
@property (retain) IBOutlet NSString *department;
@property (retain) IBOutlet NSString *website;
@property (retain) IBOutlet NSString *weblog;
@property (retain) IBOutlet NSString *comments;
@property (retain) IBOutlet NSDate *creationDate;
@property (retain) IBOutlet NSDate *modificationDate;
@property (retain) IBOutlet NSImage *picture;

@end
