#import <UIKit/UIKit.h>
#import <substrate.h>

#define TTULog(format, ...) NSLog(@"[TapToUnlock7]: %@", [NSString stringWithFormat: format, ## __VA_ARGS__])

#define PREFS_PATH                      [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.taptounlock7.plist", NSHomeDirectory()]
#define CONTENTS_PATH                     @"/Library/Application Support/TapToUnlock7/Contents"

#define ENABLED_KEY						@"enabled"
#define TAP_ANYWHERE_KEY				@"tapAnywhere"
#define DOUBLE_TAP_KEY					@"doubleTap"
#define CUSTOM_TEXT_KEY					@"customText"
#define DEFAULT_UNLOCK_KEY				@"defaultUnlockDisabled"
#define CHEVRON_KEY						@"hideChevron"
#define USE_IMAGE_KEY					@"useImage"
#define BORDER_KEY						@"buttonBorder"
#define WIDTH_KEY						@"buttonWidth"
#define HEIGHT_KEY						@"buttonHeight"
#define INSET_KEY						@"verticalInset"
#define FONT_SIZE_KEY					@"fontSize"
#define ALPHA_KEY						@"alpha"
#define COLOR_KEY						@"color"
#define TITLE_TEXT_KEY					@"titleText"

#define DefaultPrefs         [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], ENABLED_KEY, [NSNumber numberWithBool:NO], TAP_ANYWHERE_KEY, [NSNumber numberWithBool:NO], DOUBLE_TAP_KEY, [NSNumber numberWithBool:NO], CUSTOM_TEXT_KEY, [NSNumber numberWithBool: YES], DEFAULT_UNLOCK_KEY, [NSNumber numberWithBool: YES], CHEVRON_KEY, [NSNumber numberWithBool: NO], USE_IMAGE_KEY, [NSNumber numberWithBool: YES], BORDER_KEY, [NSNumber numberWithFloat:200.0f], WIDTH_KEY, [NSNumber numberWithFloat: 40.0f], HEIGHT_KEY, [NSNumber numberWithFloat: 20.0f], FONT_SIZE_KEY, [NSNumber numberWithFloat: 0.90f], ALPHA_KEY, @"#fdfdfd", COLOR_KEY, @"tap tp unlock", TITLE_TEXT_KEY, [NSNumber numberWithFloat: 20.0f], INSET_KEY, nil]