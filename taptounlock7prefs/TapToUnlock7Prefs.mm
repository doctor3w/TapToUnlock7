#import <Preferences/Preferences.h>

#define TTULog(format, ...) NSLog(@"[TapToUnlock7]: %@", [NSString stringWithFormat: format, ## __VA_ARGS__])

#define PREFS_PATH                      [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.taptounlock7.plist", NSHomeDirectory()]
#define ENABLED_KEY						@"enabled"
#define TAP_ANYWHERE_KEY				@"tapAnywhere"
#define CUSTOM_TEXT_KEY					@"customText"
#define DEFAULT_UNLOCK_KEY				@"defaultUnlockDisabled"
#define CHEVRON_KEY						@"hideChevron"
#define USE_IMAGE_KEY					@"useImage"
#define BORDER_KEY						@"buttonBorder"
#define WIDTH_KEY						@"buttonWidth"
#define HEIGHT_KEY						@"buttonHeight"
#define FONT_SIZE_KEY					@"fontSize"
#define ALPHA_KEY						@"alpha"
#define COLOR_KEY						@"color"
#define TITLE_TEXT_KEY					@"titleText"

#define DefaultPrefs         [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], ENABLED_KEY, [NSNumber numberWithBool:NO], TAP_ANYWHERE_KEY, [NSNumber numberWithBool:NO], CUSTOM_TEXT_KEY, [NSNumber numberWithBool: YES], DEFAULT_UNLOCK_KEY, [NSNumber numberWithBool: YES], CHEVRON_KEY, [NSNumber numberWithBool: NO], USE_IMAGE_KEY, [NSNumber numberWithBool: YES], BORDER_KEY, [NSNumber numberWithFloat:200.0f], WIDTH_KEY, [NSNumber numberWithFloat: 40.0f], HEIGHT_KEY, [NSNumber numberWithFloat: 20.0f], FONT_SIZE_KEY, [NSNumber numberWithFloat: 0.90f], ALPHA_KEY, @"#fdfdfd", COLOR_KEY, @"tap tp unlock", TITLE_TEXT_KEY, nil]


@interface TapToUnlock7PrefsListController: PSListController {
}
@property (nonatomic, retain, readwrite) NSMutableDictionary *settings;
@property (retain, nonatomic) UIAlertView *colorAlertView;
@property (retain, nonatomic) UIAlertView *titleAlertView;
- (IBAction)respring:(id)sender;
- (IBAction)follow:(id)arg1;
- (IBAction)donate:(id)arg1;
- (IBAction)visitWebsite:(id)arg1;
- (IBAction)emailSupport:(id)arg1;
- (IBAction)colorText:(id)arg1;
- (IBAction)titleText:(id)arg1;
@end

@implementation TapToUnlock7PrefsListController
- (id)initForContentSize:(CGSize)size {
	if ((self = [super initForContentSize:size])) {
		self.settings = [([NSMutableDictionary dictionaryWithContentsOfFile:PREFS_PATH] ?: DefaultPrefs) retain];
	}
	return self;
}
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"TapToUnlock7Prefs" target:self] retain];
	}
	return _specifiers;
}

- (IBAction)respring:(id)sender {
	system("killall -9 backboardd");
}

- (IBAction)follow:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/drewsdunne"]];
}
- (IBAction)donate:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=UXPEZSPPFFLVC"]];
}
- (IBAction)emailSupport:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:drew@drewsdunne.com"]];
}
- (IBAction)visitWebsite:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://drewsdunne.com/"]];
}

- (IBAction)colorText:(id)arg1 {
	if (!self.colorAlertView) {
		self.colorAlertView = [[UIAlertView alloc] initWithTitle:@"Enter a Hex Color"
		                                                 message:@"The color MUST be a 6 character hex string with the # in front. If anything else is typed in you will go into safemode."
		                                                delegate:self
		                                       cancelButtonTitle:@"Cancel"
		                                       otherButtonTitles:@"Save", nil];
	}

	self.colorAlertView.tag = 10;
	self.colorAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	UITextField *field = [self.colorAlertView textFieldAtIndex:0];
	if ([self.settings objectForKey:COLOR_KEY])
	{
		field.text = [self.settings objectForKey:COLOR_KEY];
	} else {
		field.text = @"#fdfdfd";
	}
	[self.colorAlertView show];
}

- (IBAction)titleText:(id)arg1 {
	if (!self.titleAlertView) {
		self.titleAlertView = [[UIAlertView alloc] initWithTitle:@"Enter a Title"
		                                                 message:@"This will be the title displayed in the button."
		                                                delegate:self
		                                       cancelButtonTitle:@"Cancel"
		                                       otherButtonTitles:@"Save", nil];
	}

	self.titleAlertView.tag = 5;
	self.titleAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	UITextField *field = [self.titleAlertView textFieldAtIndex:0];
	if ([self.settings objectForKey:TITLE_TEXT_KEY])
	{
		field.text = [self.settings objectForKey:TITLE_TEXT_KEY];
	} else {
		field.text = @"tap to unlock";
	}
	[self.titleAlertView show];
}

- (void)writeSettings {
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:self.settings format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];

	if (!data)
		return;
	if (![data writeToFile:PREFS_PATH atomically:NO]) {
		TTULog(@"failed to write preferences. Permissions issue?");
		return;
	}
}

- (void)sendSettings {
	[self writeSettings];

	/*CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterPostNotification(r, (CFStringRef)kZeppelinSettingsChanged, NULL, (CFDictionaryRef)self.settings, true);*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(int)buttonIndex { 
	self.settings = [([NSMutableDictionary dictionaryWithContentsOfFile:PREFS_PATH] ?: DefaultPrefs) retain];
	if (alertView.tag==10)
	{
		if (buttonIndex == 1) {// save
			NSString *text = [[alertView textFieldAtIndex:0] text];

			if (text && text.length==7) {
				[self.settings setObject:text forKey:COLOR_KEY];
			} else {
				[self.settings setObject:@"#fdfdfd" forKey:COLOR_KEY];
			}
		}
	} else if (alertView.tag==5) {
		if (buttonIndex == 1) {// save
			NSString *text = [[alertView textFieldAtIndex:0] text];

			if (text) {
				[self.settings setObject:text forKey:TITLE_TEXT_KEY];
			} else {
				[self.settings setObject:@"tap to unlock" forKey:TITLE_TEXT_KEY];
			}
		}
	}

	[self sendSettings];
}

@end

// vim:ft=objc
