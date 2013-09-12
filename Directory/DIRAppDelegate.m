//
//  DIRAppDelegate.m
//  Directory
//
//  Created by Yoann Gini on 03/09/13.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import "DIRAppDelegate.h"

#import "DIRDataProvider.h"

#import <libkern/OSAtomic.h>

#import "DIRDataViewController.h"
#import "DIRRecord.h"

typedef NS_ENUM(int, DIRDataType)
{
	kDIRDataTypeUnknown,
	kDIRDataTypeUsers,
	kDIRDataTypeContacts
};

#define kDIRDataTypeUnsuportedException @"kDIRDataTypeUnsuportedException"

@interface DIRAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>
{
	DIRDataType _selectedRecordType;
	
	BOOL _applicationIsReady;
	
	DIRDataViewController *_curentDataViewController;
}

- (void)reloadData;
- (void)reloadAuthenticationState;
- (void)reloadDetailViewForRecord:(DIRRecord*)record;

- (ODRecordType)selectedODRecordType;

- (void)authenticateWithLogin:(NSString*)login andPassword:(NSString*)password;

-(void)masterSelectionDidChange;

@end

@implementation DIRAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
//	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints": @YES}];
	
	[[DIRDataProvider sharedInstance] addObserver:self forKeyPath:@"authenticatedAs" options:0 context:NULL];
	[self.masterViewArrayController addObserver:self forKeyPath:@"selectionIndexes" options:0 context:NULL];
	
	NSMenuItem *menuItem = nil;
	for (NSString *source in [[DIRDataProvider sharedInstance] availableSources]) {
		menuItem = [[NSMenuItem alloc] initWithTitle:source
											  action:@selector(selectedSourceHasChanged:)
									   keyEquivalent:@""];
		[menuItem setTarget:self];
		[self.sourcePopUpButton.menu addItem:menuItem];
		[menuItem release];
	}
	
	[self.sourcePopUpButton selectItemAtIndex:0];
	[self.dataTypeSegmentedControl setSelectedSegment:0];
	
	[self selectedDataTypeHasChanged:self];
	[self selectedSourceHasChanged:self];
	
	_applicationIsReady = YES;
	
	[self reloadData];
}

- (void)dealloc
{
	[[DIRDataProvider sharedInstance] removeObserver:self forKeyPath:@"authenticatedAs"];
	[_finalList release], _finalList = nil;
    [super dealloc];
}

#pragma mark Actions

- (IBAction)selectedSourceHasChanged:(id)sender {
	[[DIRDataProvider sharedInstance] setSelectedSource:self.sourcePopUpButton.selectedItem.title];
	[self reloadDetailViewForRecord:nil];
	[self reloadData];
}

- (IBAction)selectedDataTypeHasChanged:(id)sender {
	switch (self.dataTypeSegmentedControl.selectedSegment) {
		case 0:
			_selectedRecordType = kDIRDataTypeUsers;
			break;
		case 1:
			_selectedRecordType = kDIRDataTypeContacts;
			break;
		default:
			[NSException raise:kDIRDataTypeUnsuportedException format:@"The selected data type (%ld) isn't supported", (long)self.dataTypeSegmentedControl.selectedTag];
			break;
	}
	[self reloadDetailViewForRecord:nil];
	[self reloadData];
}

- (IBAction)masterSearchFieldDidChange:(id)sender {
	[self reloadData];
}

- (IBAction)showLoginPanelAction:(id)sender {
	if ([[[DIRDataProvider sharedInstance] authenticatedAs] length] == 0)
	{
		if (!self.loginWindow.isVisible)
		{
			if (sender != self)
			{
				self.loginWindowUserField.stringValue = @"";
				self.loginWindowPasswordField.stringValue = @"";
			}
			
			[NSApp beginSheet:self.loginWindow
			   modalForWindow:self.window
				modalDelegate:self
			   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
				  contextInfo:NULL];
			
			[self.loginWindow makeFirstResponder:self.loginWindowUserField];
		}
	}
	else
	{
		[[DIRDataProvider sharedInstance] forgetAuthentication];
	}
}

- (IBAction)loginWindowOKAction:(id)sender {
	[NSApp endSheet:self.loginWindow returnCode:NSOKButton];
}

- (IBAction)loginWindowCancelAction:(id)sender {
	[NSApp endSheet:self.loginWindow returnCode:NSCancelButton];
}

#pragma mark Login

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	
	if (NSOKButton == returnCode)
	{
		[self authenticateWithLogin:self.loginWindowUserField.stringValue andPassword:self.loginWindowPasswordField.stringValue];
	}
	
	[self reloadAuthenticationState];
	
	if (![[[DIRDataProvider sharedInstance] authenticatedAs] isEqualToString:self.loginWindowUserField.stringValue] &&
		NSOKButton == returnCode) {
		[self showLoginPanelAction:self];
	}
	else
	{
		self.loginWindowUserField.stringValue = @"";
		self.loginWindowPasswordField.stringValue = @"";
	}
}


#pragma mark UI handling

- (void)reloadData
{
	if (!_applicationIsReady) {
		return;
	}
	
	self.finalList = [NSArray array];
	
	[[DIRDataProvider sharedInstance] allEntriesOfType:[self selectedODRecordType]
										withQueryValue:[self.masterSearchField.stringValue length] > 0 ? self.masterSearchField.stringValue : nil
										  andMatchType:kODMatchInsensitiveContains
								 withCompletionHandler:^(NSArray *entries, NSError *error) {
									 
									 if (!error)
									 {
										 self.finalList = [self.finalList arrayByAddingObjectsFromArray:entries];
									 }
									 else
									 {
										 NSLog(@"Error when retriving entries %@", error);
									 }
								 }];
}

- (void)reloadAuthenticationState
{
	NSString *authenticatedAs = [[DIRDataProvider sharedInstance] authenticatedAs];
	if ([authenticatedAs length] > 0) {
		self.loginButton.image = [NSImage imageNamed:@"NSLockUnlockedTemplate"];
		self.loginStateField.stringValue = [NSString stringWithFormat:@"Authenticated as %@", authenticatedAs];
	}
	else
	{
		self.loginButton.image = [NSImage imageNamed:@"NSLockLockedTemplate"];
		self.loginStateField.stringValue = @"";
	}
	
//	NSIndexSet *indexes = self.masterViewArrayController.selectionIndexes;
//	[self reloadData];
	
//	if (![self.masterViewArrayController.selectionIndexes isEqualToIndexSet:indexes]) {
//		[self.masterViewArrayController setSelectionIndexes:indexes];
//	}
}

- (void)reloadDetailViewForRecord:(DIRRecord*)record
{
	if (_curentDataViewController) {
		[_curentDataViewController.view removeFromSuperview];
		[_curentDataViewController release];
	}
	
	_curentDataViewController = [DIRDataViewController newDataViewControllerForRecord:record];

	if (_curentDataViewController) {
		NSSize detailSuperviewSize = self.detailSuperview.frame.size;
		NSSize detailViewSize = [_curentDataViewController minimumDisplaySize];
		
		CGFloat wDiff = detailViewSize.width - detailSuperviewSize.width;
		CGFloat hDiff = detailViewSize.height - detailSuperviewSize.height;
		
		NSRect windowFrame = self.window.frame;
		
//		if (wDiff > 0)
//		{
			windowFrame.size.width += wDiff;
//		}
//		
//		if (hDiff > 0) {
			windowFrame.size.height += hDiff;
//		}
		
		[self.window setFrame:windowFrame display:YES animate:YES];
		[self.window setMinSize:windowFrame.size];
		
		[self.detailSuperview addSubview:_curentDataViewController.view];
		
		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self.detailSuperview
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1
																		  constant:0]];
		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
																		 attribute:NSLayoutAttributeTrailing
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self.detailSuperview
																		 attribute:NSLayoutAttributeTrailing
																		multiplier:1
																		  constant:0]];
		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
																		 attribute:NSLayoutAttributeTop
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self.detailSuperview
																		 attribute:NSLayoutAttributeTop
																		multiplier:1
																		  constant:0]];
		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
																		 attribute:NSLayoutAttributeBottom
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self.detailSuperview
																		 attribute:NSLayoutAttributeBottom
																		multiplier:1
																		  constant:0]];
		
//		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
//																		 attribute:NSLayoutAttributeWidth
//																		 relatedBy:NSLayoutRelationGreaterThanOrEqual
//																			toItem:self.detailSuperview
//																		 attribute:NSLayoutAttributeWidth
//																		multiplier:1
//																		  constant:detailViewSize.width]];
//		
//		[self.detailSuperview addConstraint:[NSLayoutConstraint constraintWithItem:_curentDataViewController.view
//																		 attribute:NSLayoutAttributeHeight
//																		 relatedBy:NSLayoutRelationGreaterThanOrEqual
//																			toItem:self.detailSuperview
//																		 attribute:NSLayoutAttributeHeight
//																		multiplier:1
//																		  constant:detailViewSize.height]];
	}
}

#pragma mark Adaptors

- (ODRecordType)selectedODRecordType
{
	switch (_selectedRecordType) {
		case kDIRDataTypeUsers:
			return kODRecordTypeUsers;
			break;
			
		case kDIRDataTypeContacts:
			return kODRecordTypePeople;
			break;
			
		default:
			return nil;
			break;
	}
}

#pragma mark TableView

-(void)masterSelectionDidChange
{
	NSArray *selectedObjects = self.masterViewArrayController.selectedObjects;

	if ([selectedObjects count] == 0) {
		[self reloadDetailViewForRecord:nil];
	}
	else if ([selectedObjects count] == 1) {
		DIRRecord *selectedRecord = [selectedObjects lastObject];
		[self reloadDetailViewForRecord:selectedRecord];
	}
	else
	{
		[self reloadDetailViewForRecord:nil];
	}
}

#pragma mark Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([DIRDataProvider sharedInstance] == object)
	{
		if ([@"authenticatedAs" isEqualToString:keyPath])
		{
			[self reloadAuthenticationState];
		}
	}
	else if (self.masterViewArrayController == object)
	{
		if ([@"selectionIndexes" isEqualToString:keyPath]) {
			[self masterSelectionDidChange];
		}
	}
}

#pragma mark - Internal

- (void)authenticateWithLogin:(NSString*)login andPassword:(NSString*)password
{
	NSError *error = [[DIRDataProvider sharedInstance] authenticateWithUsername:login andPassword:password];
	
	if (error) {
		NSLog(@"Authentication error %@", error);
	}
}

@end
