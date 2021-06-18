//
//  YYKeyButton.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import <UIKit/UIKit.h>
#import "YYKeyboard.h"

typedef NS_ENUM(NSUInteger, YYKeyButtonType) {
    YYKeyButtonTypeNormal,
    YYKeyButtonTypeSpace,
    YYKeyButtonTypeDelete,
    YYKeyButtonTypeCaps
};

@interface YYKeyButton : UIButton

@property (nonatomic, assign) YYKeyButtonType type;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIColor *funcHighlightedBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame style:(YYKeyboardStyle)style;

@end
