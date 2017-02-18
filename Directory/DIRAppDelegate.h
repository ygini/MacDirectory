//
//  DIRAppDelegate.h
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DIRAppDelegate : NSObject <NSApplicationDelegate>

@property IBOutlet NSWindow *window;
@property IBOutlet NSTableView *masterTableView;
@property IBOutlet NSView *detailSuperview;

@property IBOutlet NSPopUpButton *sourcePopUpButton;
- (IBAction)selectedSourceHasChanged:(id)sender;

@property IBOutlet NSSegmentedControl *dataTypeSegmentedControl;
- (IBAction)selectedDataTypeHasChanged:(id)sender;

@property IBOutlet NSSearchField *masterSearchField;
- (IBAction)masterSearchFieldDidChange:(id)sender;

@property IBOutlet NSButton *loginButton;
@property IBOutlet NSWindow *loginWindow;
@property IBOutlet NSTextField *loginWindowUserField;
@property IBOutlet NSSecureTextField *loginWindowPasswordField;
@property IBOutlet NSTextField *loginStateField;
- (IBAction)showLoginPanelAction:(id)sender;
- (IBAction)loginWindowOKAction:(id)sender;
- (IBAction)loginWindowCancelAction:(id)sender;

@property IBOutlet NSArray *finalList;
@property IBOutlet NSArrayController *masterViewArrayController;

- (IBAction)addNodeAction:(id)sender;
- (IBAction)removeNodeAction:(id)sender;
@end
