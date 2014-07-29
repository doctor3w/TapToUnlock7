//
//
//    Created by drewsdunne 
//        April 4 2014
//
// 

#import "defines.h"
#import "UIColor_Categories.h"

#define PREFS_PATH                      [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.taptounlock7.plist", NSHomeDirectory()]
#define contentsPath                     @"/Library/Application Support/TapToUnlock7/Contents"
//#define buttonImageName                  [NSString stringWithFormat:@"button.png"]
//#define buttonPressedImageName           [NSString stringWithFormat:@"button_pressed.png"]

BOOL _enabled;
BOOL _tapAnywhere;
BOOL _doubleTap;
BOOL _tapToUnlockText;
BOOL _defaultUnlockDisabled;
BOOL _hideChevron;
NSString *_titleText;
BOOL _useImage;
float _buttonWidth;
float _buttonHeight;
float _verticalInset;
float _fontSize;
NSString *_tapColor;
float _buttonAlpha;
BOOL _buttonBorder;

float numberOfTaps;
long timeOfLastTap;

@interface SBLockScreenBounceAnimator
- (void)_handleTapGesture:(id)arg1;
-(void)addTapExcludedView:(id)arg1;
-(id)initWithView:(id)arg1;
@end

@interface SBAlert : UIViewController
@end

@interface SBLockScreenViewControllerBase : SBAlert
@end

@interface SBLockScreenViewController : SBLockScreenViewControllerBase
- (id)lockScreenScrollView;
@end

@interface SBLockScreenManager
@property(readonly, nonatomic) SBLockScreenViewControllerBase *lockScreenViewController;
+ (id)sharedInstance;
- (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
@end

@interface SBAlertView : UIView
@end

@interface SBLockScreenScrollView : UIScrollView
@end

@interface SBLockScreenView : SBAlertView {
	SBLockScreenScrollView *_foregroundScrollView;
}
- (id)_defaultSlideToUnlockText;
- (void)_layoutSlideToUnlockView;
- (void)tapToUnlockAction;
@property(readonly, nonatomic) UIScrollView *scrollView;
- (void)_layoutScrollView;
- (void)setCustomSlideToUnlockText:(id)arg1;
@end

@interface SBFGlintyStringView
- (void)setChevron:(id)arg1;
-(int)chevronStyle;
 -(void)setChevronStyle:(int) style;
@end

void load_settings()
{
	NSMutableDictionary *defaultSettings = [[[NSMutableDictionary alloc] init] autorelease];
	[defaultSettings setObject:@"1" forKey:@"enabled"];
	[defaultSettings setObject:@"0" forKey:@"tapAnywhere"];
	[defaultSettings setObject:@"1" forKey:@"numberOfTaps"];
	[defaultSettings setObject:@"0" forKey:@"customText"];
	[defaultSettings setObject:@"1" forKey:@"defaultUnlockDisabled"];
	[defaultSettings setObject:@"1" forKey:@"hideChevron"];
	[defaultSettings setObject:@"0" forKey:@"useImage"];
	[defaultSettings setObject:@"1" forKey:@"buttonBorder"];
	[defaultSettings setObject:@"200" forKey:@"buttonWidth"];
	[defaultSettings setObject:@"40" forKey:@"buttonHeight"];
	[defaultSettings setObject:@"20" forKey:@"fontSize"];
	[defaultSettings setObject:@"0.9" forKey:@"alpha"];
	[defaultSettings setObject:@"#fdfdfd" forKey:@"color"];
	[defaultSettings setObject:@"tap to unlock" forKey:@"titleText"];
	[defaultSettings setObject:@"20" forKey:@"verticalInset"];

	NSDictionary *prefDict = [[[NSDictionary alloc] initWithContentsOfFile:PREFS_PATH] autorelease];
	if (!prefDict)
	{
		prefDict = [[NSDictionary alloc] initWithDictionary:defaultSettings];
	}

	if ([prefDict objectForKey:@"enabled"])
	{
		_enabled = [(NSString *)[prefDict objectForKey:@"enabled"] boolValue];
	} else {
		_enabled = [(NSString *)[defaultSettings objectForKey:@"enabled"] boolValue];
	}

	if ([prefDict objectForKey:@"tapAnywhere"])
	{
		_tapAnywhere = [(NSString *)[prefDict objectForKey:@"tapAnywhere"] boolValue];
	} else {
		_tapAnywhere = [(NSString *)[defaultSettings objectForKey:@"tapAnywhere"] boolValue];
	}

	if ([prefDict objectForKey:@"numberOfTaps"])
	{
		if ([[prefDict objectForKey:@"numberOfTaps"] isEqualToString:@"1"])
		{
			_doubleTap = NO;
		} else {
			_doubleTap = YES;
		}
	} else {
		if ([[defaultSettings objectForKey:@"numberOfTaps"] isEqualToString:@"1"])
		{
			_doubleTap = NO;
		} else {
			_doubleTap = YES;
		}
	}

	if ([prefDict objectForKey:@"customText"])
	{
		_tapToUnlockText = [(NSString *)[prefDict objectForKey:@"customText"] boolValue];
	} else {
		_tapToUnlockText = [(NSString *)[defaultSettings objectForKey:@"customText"] boolValue];
	}
	
	if ([prefDict objectForKey:@"buttonBorder"])
	{
		_buttonBorder = [(NSString *)[prefDict objectForKey:@"buttonBorder"] boolValue];
	} else {
		_buttonBorder = [(NSString *)[defaultSettings objectForKey:@"buttonBorder"] boolValue];
	}
	
	if ([prefDict objectForKey:@"defaultUnlockDisabled"])
	{
		_defaultUnlockDisabled = [(NSString *)[prefDict objectForKey:@"defaultUnlockDisabled"] boolValue];
	} else {
		_defaultUnlockDisabled = [(NSString *)[defaultSettings objectForKey:@"defaultUnlockDisabled"] boolValue];
	}

	if ([prefDict objectForKey:@"hideChevron"])
	{
		_hideChevron = [(NSString *)[prefDict objectForKey:@"hideChevron"] boolValue];
	} else {
		_hideChevron = [(NSString *)[defaultSettings objectForKey:@"hideChevron"] boolValue];
	}

	if ([prefDict objectForKey:@"verticalInset"])
	{
		_verticalInset = [(NSString *)[prefDict objectForKey:@"verticalInset"] floatValue];
	} else {
		_verticalInset = [(NSString *)[defaultSettings objectForKey:@"verticalInset"] floatValue];
	}
	
	long imageCount = [(NSArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:contentsPath error:nil] count];
	//_useImage = [[NSFileManager defaultManager] fileExistsAtPath:[contentsPath stringByAppendingPathComponent:buttonImageName]];

	if ([prefDict objectForKey:@"useImage"])
	{
		_useImage = [(NSString *)[prefDict objectForKey:@"useImage"] boolValue];
	} else {
		_useImage = [(NSString *)[defaultSettings objectForKey:@"useImage"] boolValue];
	}

	if (imageCount > 0)
	{
		if (_useImage)
		{
			NSString *imageName = [(NSArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:contentsPath error:nil] objectAtIndex:0];
			UIImage *image = [[UIImage alloc] initWithContentsOfFile:[contentsPath stringByAppendingPathComponent:imageName]];
			_buttonHeight = image.size.height;
			_buttonWidth = image.size.width;
		} else {
			if ([prefDict objectForKey:@"buttonHeight"])
			{
				_buttonHeight = [(NSString *)[prefDict objectForKey:@"buttonHeight"] floatValue];
			} else {
				_buttonHeight = [(NSString *)[defaultSettings objectForKey:@"buttonHeight"] floatValue];
			}
		
			if ([prefDict objectForKey:@"buttonWidth"])
			{
				_buttonWidth = [(NSString *)[prefDict objectForKey:@"buttonWidth"] floatValue];
			} else {
				_buttonWidth = [(NSString *)[defaultSettings objectForKey:@"buttonWidth"] floatValue];
			}
		
			if (_buttonWidth == 0)
			{
				_buttonWidth = 300;
				_buttonHeight = 50;
			}
		}
	} else {
		_useImage = NO;

		if ([prefDict objectForKey:@"buttonHeight"])
		{
			_buttonHeight = [(NSString *)[prefDict objectForKey:@"buttonHeight"] floatValue];
		} else {
			_buttonHeight = [(NSString *)[defaultSettings objectForKey:@"buttonHeight"] floatValue];
		}
		
		if ([prefDict objectForKey:@"buttonWidth"])
		{
			_buttonWidth = [(NSString *)[prefDict objectForKey:@"buttonWidth"] floatValue];
		} else {
			_buttonWidth = [(NSString *)[defaultSettings objectForKey:@"buttonWidth"] floatValue];
		}
		
		if (_buttonWidth == 0)
		{
			_buttonWidth = 300;
			_buttonHeight = 50;
		}
	}

	if ([prefDict objectForKey:@"fontSize"])
	{
		_fontSize = [(NSString *)[prefDict objectForKey:@"fontSize"] floatValue];
	} else {
		_fontSize = [(NSString *)[defaultSettings objectForKey:@"fontSize"] floatValue];
	}
	
	if ([prefDict objectForKey:@"alpha"])
	{
		_buttonAlpha = [(NSString *)[prefDict objectForKey:@"alpha"] floatValue];
	} else {
		_buttonAlpha = [(NSString *)[defaultSettings objectForKey:@"alpha"] floatValue];
	}
	
	if (_buttonAlpha==0)
	{
		_buttonAlpha = 0.1;
	}

	if ([prefDict objectForKey:@"color"])
	{
		NSString *colorHex = (NSString *)[prefDict objectForKey:@"color"];
		if (colorHex.length < 7)
		{
			_tapColor = (NSString *)[defaultSettings objectForKey:@"color"];
		} else {
			_tapColor = colorHex;
		}
	} else {
		_tapColor = (NSString *)[defaultSettings objectForKey:@"color"];
	}

	if ([prefDict objectForKey:@"titleText"])
	{
		_titleText = (NSString *)[prefDict objectForKey:@"titleText"];
	} else {
		_titleText = (NSString *)[defaultSettings objectForKey:@"titleText"];
	}
	NSLog(@"[TapToUnlock7]: Set Text: %@",_titleText);

	numberOfTaps = 0;
	timeOfLastTap = 100;

	//[prefDict release];
	[defaultSettings release];
}

%hook SBLockScreenBounceAnimator

- (void)_handleTapGesture:(id)arg1 {
	UITapGestureRecognizer *tap = arg1;
	if (_enabled && _tapAnywhere)
	{
		CGPoint tapPoint = [tap locationInView:nil];
		UIView *viewAtBottomOfHeirachy = [[(SBLockScreenViewController *)[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] view] hitTest:tapPoint withEvent:nil];
    	if (![viewAtBottomOfHeirachy isKindOfClass:[UIButton class]]) {
			if (_doubleTap)
			{
				long interTapTime = (long)[[NSDate date] timeIntervalSince1970] - timeOfLastTap;
				if (numberOfTaps == 1 && interTapTime <= 1.5)
				{
					[[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:0 withOptions:nil];
					timeOfLastTap = (long)[[NSDate date] timeIntervalSince1970];
					numberOfTaps = 0;
				} else {
					numberOfTaps++;
					if (numberOfTaps > 1)
					{
						numberOfTaps = 0;
					}
					timeOfLastTap = (long)[[NSDate date] timeIntervalSince1970];
				}
			} else {
				[[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:0 withOptions:nil];
			}
    	} else {
    		%orig;
    	}
		
	} else {
		%orig;
	}
}

%end

SBLockScreenScrollView *scrollView;
//SBLockScreenView *SBLSView;

%hook SBLockScreenView

- (id)_defaultSlideToUnlockText {
	if (_enabled)
	{
		if (_tapToUnlockText)
		{
			return _titleText;
		} else {
			return @"tap to unlock";
		}
	} else {
		return %orig;
	}
}

- (void)_layoutSlideToUnlockView {
	if (_enabled)
	{
		if (!_tapAnywhere)
		{
			//SBLSView = self;
			scrollView = MSHookIvar<SBLockScreenScrollView*>([(SBLockScreenViewController *)[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] view], "_foregroundScrollView");
			for (UIButton *button in [scrollView subviews])
			{
				if (button.tag == 8656)
				{
					[button removeFromSuperview];
				}
			}
			//UIScrollView *scrollView = [(SBLockScreenViewController *)[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] lockScreenScrollView];

			UIButton *tapToUnlock = [UIButton buttonWithType:UIButtonTypeSystem];

			[tapToUnlock setFrame:CGRectMake(scrollView.frame.size.width+(scrollView.frame.size.width-_buttonWidth)/2,scrollView.frame.size.height-_buttonHeight-_verticalInset,_buttonWidth,_buttonHeight)];

			[tapToUnlock setTag:8656];

			if (_tapToUnlockText)
			{
				[tapToUnlock setTitle:_titleText forState:UIControlStateNormal];
			} else {
				[tapToUnlock setTitle:@"tap to unlock" forState:UIControlStateNormal];
			}
			
			if (_useImage)
			{
				NSString *imageName = [(NSArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:contentsPath error:nil] objectAtIndex:0];
				UIImage *image = [[UIImage alloc] initWithContentsOfFile:[contentsPath stringByAppendingPathComponent:imageName]];
				[tapToUnlock setImage:image forState:UIControlStateNormal];

				//UIImage *highlighted = [UIImage imageNamed:[contentsPath stringByAppendingPathComponent:buttonPressedImageName]];
				//[tapToUnlock setImage:[UIImage imageNamed:[contentsPath stringByAppendingPathComponent:buttonPressedImageName]] forState:UIControlStateHighlighted];
			}

			UIColor *color = [UIColor colorWithHexString:_tapColor andAlpha:_buttonAlpha];

			[tapToUnlock setTitleColor:color forState:UIControlStateNormal];
			[tapToUnlock setTintColor:color];

			//[tapToUnlock setAlpha:_buttonAlpha];

			[tapToUnlock.titleLabel setFont:[UIFont systemFontOfSize:_fontSize]];

			[tapToUnlock addTarget:self action:@selector(tapToUnlockAction) forControlEvents:UIControlEventTouchUpInside];

			if (_buttonBorder)
			{
				tapToUnlock.layer.cornerRadius = 10.0f;
				tapToUnlock.layer.borderWidth = 1.0f;
				tapToUnlock.layer.borderColor = [color CGColor];
			}

			[scrollView addSubview:tapToUnlock];
			scrollView.scrollEnabled = NO;
			//[tapToUnlock release];
		} else {
			%orig;
		}
	} else {
		%orig;
	}
	
	
}

- (void)setCustomSlideToUnlockText:(id)arg1 {
	%orig;
	//Turn off scrolling on lockscreen
	if (_enabled)
	{
		if (_defaultUnlockDisabled)
		{
			scrollView = MSHookIvar<SBLockScreenScrollView*>([(SBLockScreenViewController *)[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] view], "_foregroundScrollView");
			scrollView.scrollEnabled = NO;
		}
	}
}

- (void)_layoutScrollView {
	%orig;
	//Turn off scrolling on lockscreen
	if (_enabled)
	{
		if (_defaultUnlockDisabled)
		{
			scrollView = MSHookIvar<SBLockScreenScrollView*>([(SBLockScreenViewController *)[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] view], "_foregroundScrollView");
			scrollView.scrollEnabled = NO;
		}
	}
}

%new
- (void)tapToUnlockAction {
	[[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:0 withOptions:nil];
}

%end

%hook SBFGlintyStringView
/*- (void)setChevron:(id)arg1 {
	if (!_hideChevron)
	{
		%orig;
	}
}*/
-(int)chevronStyle {
	if (_hideChevron)
	{
		return 0;
	} else {
		return %orig;
	}
}

 -(void)setChevronStyle:(int) style {
	if (_hideChevron)
	{
		%orig(0);
	} else {
		%orig;
	}
}
%end

%ctor {
	load_settings();
}
