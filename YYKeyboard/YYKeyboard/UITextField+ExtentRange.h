//
//  UITextField+ExtentRange.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/3.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;

@end
