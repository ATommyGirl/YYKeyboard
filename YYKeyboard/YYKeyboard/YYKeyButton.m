//
//  YYKeyButton.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "YYKeyButton.h"

@implementation YYKeyButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initUI];
}

- (void)_initUI {
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.adjustsImageWhenHighlighted = NO;
    [self setBackgroundColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
}

- (void)setSelectStatus:(BOOL)selected {
    self.selected = selected;
    if (selected) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }else {
        [self setBackgroundColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]];
    }
}

- (CGSize)intrinsicContentSize {
    return self.frame.size;
}

@end
