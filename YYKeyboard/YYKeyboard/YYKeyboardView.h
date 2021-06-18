//
//  YYKeyboardView.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import <UIKit/UIKit.h>
#import "YYInputAccessoryView.h"
#import "YYKeyButton.h"

#define isiPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSUInteger, YYKeyboardViewStyle) {
    YYKeyboardViewStyleDark = 0,
    YYKeyboardViewStyleLight,
    YYKeyboardViewStyleLikeSystemDark,
    YYKeyboardViewStyleLikeSystemLight
};

@class YYKeyboardView;
@protocol YYKeyboardViewDelegate <NSObject>
@optional

- (void)yy_KeyboardView:(YYKeyboardView *)keyboard didSelectKey:(YYKeyButtonType)type text:(NSString *)text;

@end

@interface YYKeyboardView : UIView

@property (nonatomic, weak) id<YYKeyboardViewDelegate> delegate;
@property (nonatomic, assign) YYKeyboardViewStyle style;

- (instancetype)initWithFrame:(CGRect)frame style:(YYKeyboardViewStyle)style;
- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode;

@end
