//
//  YYKBTextField.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import "YYKBTextField.h"
#import "YYKeyboardView.h"
#import "UITextField+ExtentRange.h"

@interface YYKBTextField()<YYKeyboardViewDelegate, YYInputAccessoryViewDelegate>

@end

@implementation YYKBTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}

- (void)_setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldTextDidBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)_setKeyboard {
    CGRect keyboardFrame  = CGRectMake(0, 0, SCREEN_WIDTH, MAX(210, SCREEN_HEIGHT * 0.3) + (isiPhoneX ? 34 : 0));
    YYKeyboardView *keyboard = [[YYKeyboardView alloc] initWithFrame:keyboardFrame style:(YYKeyboardStyleLight)];
    keyboard.delegate = self;
    self.inputView = keyboard;
    
    YYInputAccessoryView *inputAccessoryView = [[YYInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    inputAccessoryView.delegate = self;
    self.inputAccessoryView = inputAccessoryView;
}

- (void)yy_KeyboardView:(YYKeyboardView *)keyboard didSelectKey:(YYKeyButtonType)type text:(NSString *)text {
    NSRange range = [self selectedRange];
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return;
    }
    
    switch (type) {
        case YYKeyButtonTypeNormal:
        case YYKeyButtonTypeSpace:
        {
            self.text = [self.text stringByReplacingCharactersInRange:range withString:text];
            [self setSelectedRange:NSMakeRange(range.location + text.length, 0)];
            break;
        }
        case YYKeyButtonTypeDelete:
        {
            if (range.length > 0) {
                //Slected part text.
                self.text = [self.text stringByReplacingCharactersInRange:range withString:@""];
                [self setSelectedRange:NSMakeRange(range.location, 0)];
                return;
            }else if (range.location > 0) {
                self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(range.location - 1, 1) withString:@""];
                [self setSelectedRange:NSMakeRange(range.location - 1, 0)];
            }else {
                //NSLog(@"Delete range: {%lu %lu}", (unsigned long)range.location, (unsigned long)range.length);
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSelectDone:(BOOL)done {
    [self endEditing:YES];
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSwitchMode:(YYInputAccessoryViewMode)mode {
    YYKeyboardView *keyboard = (YYKeyboardView *)self.inputView;
    [keyboard switchKeyboardMode:mode];
}

- (void)_textFieldTextDidChange {
}

- (void)_textFieldTextDidBeginEditing {
    [self _setKeyboard];
}

- (void)dealloc {
    NSLog(@"YYKBTextField dealloc.");
}

@end
