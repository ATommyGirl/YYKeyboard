//
//  YYKeyboardView.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import <UIKit/UIKit.h>
#import "YYInputAccessoryView.h"

@class YYKeyboardView;
@protocol YYKeyboardViewDelegate <NSObject>
@optional

- (void)yy_KeyboardView:(YYKeyboardView *)keyboard didSelectKey:(NSString *)text;

@end

@interface YYKeyboardView : UIView

@property (weak, nonatomic) id<YYKeyboardViewDelegate> delegate;

- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode;

@end
