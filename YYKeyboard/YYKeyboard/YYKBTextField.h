//
//  YYKBTextField.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import <UIKit/UIKit.h>

@protocol YYKBTextFieldDelegate;

@interface YYKBTextField : UITextField

@property (nonatomic, assign) id<YYKBTextFieldDelegate> yyDelegate;

@end

@protocol YYKBTextFieldDelegate <NSObject>

@optional
- (void)yykb_textField:(YYKBTextField *)textField didEnterCharacters:(NSString *)string;
- (void)yykb_textFieldDidPressReturn:(YYKBTextField *)textField;
@end
