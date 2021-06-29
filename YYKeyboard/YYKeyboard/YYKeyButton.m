//
//  YYKeyButton.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "YYKeyButton.h"

@implementation YYKeyButton

- (instancetype)initWithFrame:(CGRect)frame style:(YYKeyboardStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        [self initStyle:style];
        [self initUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initStyle:(YYKeyboardStyleDark)];
        [self initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initStyle:(YYKeyboardStyle)style {
    self.normalBackgroundColor = [YYKeyboard keyBackgroundColor:style];
    self.selectedBackgroundColor = [YYKeyboard keySelectedBackgroundColor:style];
    self.highlightedBackgroundColor = [YYKeyboard keyHighlightedBackgroundColor:style];
    self.funcHighlightedBackgroundColor = [YYKeyboard funcKeyHighlightedBackgroundColor:style];
    
    [self setBackgroundColor:self.normalBackgroundColor];
    [self setTitleColor:[YYKeyboard titleColor:style] forState:(UIControlStateNormal)];
}

- (void)initUI {
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.adjustsImageWhenHighlighted = NO;
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
    UIColor *baseColor = self.normalBackgroundColor;
    UIColor *highColor = _type == YYKeyButtonTypeNormal ? self.highlightedBackgroundColor : self.funcHighlightedBackgroundColor;
    self.backgroundColor = highlighted ? highColor : baseColor;
    
    if (self.isSelected) {
        [self setSelectStatus:YES];
    }
}

- (CGSize)intrinsicContentSize {
    return self.frame.size;
}

@end
