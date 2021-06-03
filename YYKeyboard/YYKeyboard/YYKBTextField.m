//
//  YYKBTextField.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import "YYKBTextField.h"
#import "YYKeyboardView.h"

#define isiPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface YYKBTextField()<YYKeyboardViewDelegate, YYInputAccessoryViewDelegate>

@end

@implementation YYKBTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setKeyboard];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setKeyboard];
}

- (void)_setKeyboard {
    YYKeyboardView *keyboard = [[YYKeyboardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250 - (isiPhoneX ? 34 : 0), SCREEN_WIDTH, 250)];
    keyboard.delegate = self;
    self.inputView = keyboard;
    
    YYInputAccessoryView *inputAccessoryView = [[YYInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    inputAccessoryView.delegate = self;
    self.inputAccessoryView = inputAccessoryView;
}

- (void)yy_KeyboardView:(YYKeyboardView *)keyboard didSelectKey:(NSString *)text {
    self.text = [self.text stringByAppendingString:text];
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSelectDone:(BOOL)done {
    [self endEditing:YES];
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSwitchMode:(YYInputAccessoryViewMode)mode {
    YYKeyboardView *keyboard = (YYKeyboardView *)self.inputView;
    [keyboard switchKeyboardMode:mode];
}

@end
