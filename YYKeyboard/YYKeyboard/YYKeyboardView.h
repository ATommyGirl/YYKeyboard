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

@class YYKeyboardView;
@protocol YYKeyboardViewDelegate <NSObject>
@optional

- (void)yy_KeyboardView:(YYKeyboardView *)keyboard didSelectKey:(YYKeyButtonType)type text:(NSString *)text;

@end

@interface YYKeyboardView : UIView

@property (weak, nonatomic) id<YYKeyboardViewDelegate> delegate;

- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode;

@end
