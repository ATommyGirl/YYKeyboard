//
//  YYKeyboard.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/18.
//

#import "YYKeyboard.h"

@implementation YYKeyboard

+ (UIColor *)keyboardBackgroundColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:62/255.0 alpha:1];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor colorWithRed:214/255.0 green:216/255.0 blue:221/255.0 alpha:1];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *)keyBackgroundColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *)keySelectedBackgroundColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor whiteColor];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *)keyHighlightedBackgroundColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor lightGrayColor];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *)funcKeyHighlightedBackgroundColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor whiteColor];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor grayColor];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor *)titleColor:(YYKeyboardStyle)style {
    UIColor *color = [UIColor orangeColor]; //I like orange.😁
    switch (style) {
        case YYKeyboardStyleDark:
        case YYKeyboardStyleLikeSystemDark:
            color = [UIColor whiteColor];
            break;
        case YYKeyboardStyleLight:
        case YYKeyboardStyleLikeSystemLight:
            color = [UIColor blackColor];
            break;
        default:
            break;
    }
    return color;
}

@end
