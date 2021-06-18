//
//  YYKeyButton.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import <UIKit/UIKit.h>

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

@end
