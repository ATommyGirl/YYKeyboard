//
//  YYKeyboard.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

typedef NS_ENUM(NSUInteger, YYKeyboardStyle) {
    YYKeyboardStyleDark = 0,
    YYKeyboardStyleLight,
    YYKeyboardStyleLikeSystemDark,
    YYKeyboardStyleLikeSystemLight
};

@interface YYKeyboard : NSObject

+ (UIColor *)keyboardBackgroundColor:(YYKeyboardStyle)style;
+ (UIColor *)keyBackgroundColor:(YYKeyboardStyle)style;
+ (UIColor *)keySelectedBackgroundColor:(YYKeyboardStyle)style;
+ (UIColor *)keyHighlightedBackgroundColor:(YYKeyboardStyle)style;
+ (UIColor *)funcKeyHighlightedBackgroundColor:(YYKeyboardStyle)style;
+ (UIColor *)titleColor:(YYKeyboardStyle)style;

@end
