//
//  YYKBTextField.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import "YYKBTextField.h"
#import "YYKeyboardView.h"
#import "UITextField+ExtentRange.h"

@interface YYKBTextField()<YYKeyboardViewDelegate>

@end

@implementation YYKBTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)setKeyboard {
    CGRect keyboardFrame  = CGRectMake(0, 0, SCREEN_WIDTH, MAX(210, SCREEN_HEIGHT * 0.305) + (isiPhoneX ? 34 : 0));
    YYKeyboardView *keyboard = [[YYKeyboardView alloc] initWithFrame:keyboardFrame style:(YYKeyboardStyleLight)];
    keyboard.delegate = self;
    self.inputView = keyboard;
    self.inputAccessoryView = [keyboard inputAccessoryView];
}

- (void)yy_keyboardView:(YYKeyboardView *)keyboard didSelectKey:(YYKeyButtonType)type text:(NSString *)text {
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

- (void)yy_keyboardViewDidEndEditing:(YYKeyboardView *)keyboard {
    [self endEditing:YES];
}

- (void)textFieldTextDidChange {
}

- (void)textFieldTextDidBeginEditing {
    [self setKeyboard];
}

- (void)dealloc {
    NSLog(@"YYKBTextField dealloc.");
}

@end
