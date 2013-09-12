//
//  DIRHumanRecord.h
//  Directory
//
//  Created by Yoann Gini on 10/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRRecord.h"

@interface DIRHumanRecord : DIRRecord

@property (nonatomic, retain) IBOutlet NSString *prefixName;
@property (nonatomic, retain) IBOutlet NSString *firstName;
@property (nonatomic, retain) IBOutlet NSString *middleName;
@property (nonatomic, retain) IBOutlet NSString *lastName;
@property (nonatomic, retain) IBOutlet NSString *fullName;
@property (nonatomic, retain) IBOutlet NSString *suffixName;
@property (nonatomic, retain) IBOutlet NSString *streetAddress;
@property (nonatomic, retain) IBOutlet NSString *postalCode;
@property (nonatomic, retain) IBOutlet NSString *state;
@property (nonatomic, retain) IBOutlet NSString *city;
@property (nonatomic, retain) IBOutlet NSString *countryCode;
@property (nonatomic, retain) IBOutlet NSString *company;
@property (nonatomic, retain) IBOutlet NSString *jobTitle;
@property (nonatomic, retain) IBOutlet NSString *department;
@property (nonatomic, retain) IBOutlet NSString *website;
@property (nonatomic, retain) IBOutlet NSString *weblog;
@property (nonatomic, retain) IBOutlet NSString *comment;

@end
