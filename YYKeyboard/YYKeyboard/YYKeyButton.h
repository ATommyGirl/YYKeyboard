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

- (void)setSelectStatus:(BOOL)selected;

@end
