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
    self.normalBackgroundColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
    self.selectedBackgroundColor = [UIColor whiteColor];
    [self setBackgroundColor:self.normalBackgroundColor];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
}

- (void)setSelectStatus:(BOOL)selected {
    if (selected) {
        [self setBackgroundColor:self.selectedBackgroundColor];
    }else {
        [self setBackgroundColor:self.normalBackgroundColor];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setSelectStatus:selected];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    UIColor *baseColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
    UIColor *highColor = _type == YYKeyButtonTypeNormal ? [UIColor lightGrayColor] : [UIColor whiteColor];
    self.backgroundColor = highlighted ? highColor : baseColor;
    
    if (self.isSelected) {
        [self setSelectStatus:YES];
    }
}

- (CGSize)intrinsicContentSize {
    return self.frame.size;
}

@end
