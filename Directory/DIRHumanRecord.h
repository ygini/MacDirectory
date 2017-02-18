//
//  DIRHumanRecord.h
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRRecord.h"

@interface DIRHumanRecord : DIRRecord

@property (nonatomic) IBOutlet NSString *prefixName;
@property (nonatomic) IBOutlet NSString *firstName;
@property (nonatomic) IBOutlet NSString *middleName;
@property (nonatomic) IBOutlet NSString *lastName;
@property (nonatomic) IBOutlet NSString *fullName;
@property (nonatomic) IBOutlet NSString *suffixName;
@property (nonatomic) IBOutlet NSString *streetAddress;
@property (nonatomic) IBOutlet NSString *postalCode;
@property (nonatomic) IBOutlet NSString *state;
@property (nonatomic) IBOutlet NSString *city;
@property (nonatomic) IBOutlet NSString *countryCode;
@property (nonatomic) IBOutlet NSString *company;
@property (nonatomic) IBOutlet NSString *jobTitle;
@property (nonatomic) IBOutlet NSString *department;
@property (nonatomic) IBOutlet NSString *website;
@property (nonatomic) IBOutlet NSString *weblog;
@property (nonatomic) IBOutlet NSString *comment;

@property (nonatomic) IBOutlet NSArray *phones;
@property (nonatomic) IBOutlet NSArray *emails;
@property (nonatomic) IBOutlet NSArray *instantMessaging;

@end
