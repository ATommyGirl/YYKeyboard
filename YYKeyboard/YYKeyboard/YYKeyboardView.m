//
//  YYKeyboardView.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "YYKeyboardView.h"
#import "YYKeyButton.h"

static CGFloat spaceH = 5.0f;
static CGFloat spaceV = 8.0f;

@implementation YYKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:62/255.0 alpha:1]];
        [self _setLetterView:frame isCapital:NO];
    }
    
    return self;
}

- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode {
    UIStackView *container = self.subviews.firstObject;
    [container removeFromSuperview];
    if (mode == YYInputAccessoryViewModeAbc) {
        [self _setLetterView:self.frame isCapital:NO];
    } else if (mode == YYInputAccessoryViewModeSymbol) {
        [self _setSymbolView:self.frame];
    }else {
        [self _setNumberView:self.frame];
    }
}

- (void)_setLetterView:(CGRect)frame isCapital:(BOOL)isCapital {
    NSArray *items;
    if (isCapital) {
        items = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"],
                  @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P"],
                  @[@"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L"],/*Caps Lock*/
                  @[@"Z", @"X", @"C", @"V", @"B", @"N", @"M"]];/*Space & Delete*/
    }else {
        items = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"],
                  @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"],
                  @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"],/*Caps Lock*/
                  @[@"z", @"x", @"c", @"v", @"b", @"n", @"m"]];/*Space & Delete*/
    }
    [self _setAbcView:frame item:items];
}

- (void)_setAbcView:(CGRect)frame item:(NSArray *)items {
    //Caps Lock & Space & Delete 单独插入.
    CGFloat itemSpace = 5;
    UIStackView *containerView = [self _setMainContainer:frame item:items itemSpace:itemSpace];
    
    YYKeyButton *capsLock = [[YYKeyButton alloc] initWithFrame:CGRectZero];
    [capsLock setImage:[UIImage imageNamed:@"CapsLock"] forState:(UIControlStateNormal)];
    [capsLock addTarget:self action:@selector(_didSelectCapsLock:) forControlEvents:(UIControlEventTouchUpInside)];
    UIStackView *line3SubContainer = containerView.arrangedSubviews[2];
    [line3SubContainer insertArrangedSubview:capsLock atIndex:0];

    CGSize estimateKeySize = [self _estimateKeySize:frame itemSpace:itemSpace];
    CGFloat estimateWidth  = estimateKeySize.width;
    CGFloat estimateHeight = estimateKeySize.height;
    CGFloat deleteWidth    = estimateWidth + (estimateWidth - itemSpace)*0.5 + spaceH;
    YYKeyButton *space  = [self _spaceKey:CGSizeMake(deleteWidth, estimateHeight)];
    YYKeyButton *delete = [self _deleteKey:CGSizeMake(deleteWidth, estimateHeight)];
    UIStackView *line4SubContainer = containerView.arrangedSubviews[3];
    line4SubContainer.distribution = UIStackViewDistributionFillProportionally;
    [line4SubContainer insertArrangedSubview:space atIndex:0];
    [line4SubContainer addArrangedSubview:delete];
    
    [self addSubview:containerView];
}

- (void)_setSymbolView:(CGRect)frame {
    NSArray *symbols = @[@[@"&", @"\"", @";", @"^", @",", @"|", @"$", @"*", @":", @"'"],
                         @[@"?", @"{", @"[", @"~", @"#", @"}", @".", @"]", @"\\", @"!"],
                         @[@"(", @"%", @"-", @"_", @"+", @"/", @")", @"=", @"<", @"`"],
                         @[@">", @"@"]];/*Space & Delete*/

    CGFloat itemSpace = 5;
    UIStackView *containerView = [self _setMainContainer:frame item:symbols itemSpace:itemSpace];
    
    //Space & Delete 单独插入.
    CGSize estimateKeySize = [self _estimateKeySize:frame itemSpace:itemSpace];
    CGFloat estimateWidth  = estimateKeySize.width;
    CGFloat estimateHeight = estimateKeySize.height;
    CGFloat deleteWidth    = estimateWidth + (estimateWidth - itemSpace)*0.5 + spaceH;
    YYKeyButton *space  = [self _spaceKey:CGSizeMake(deleteWidth + (estimateWidth + itemSpace) * 5, estimateHeight)];
    YYKeyButton *delete = [self _deleteKey:CGSizeMake(deleteWidth, estimateHeight)];
    UIStackView *line4SubContainer = containerView.arrangedSubviews.lastObject;
    line4SubContainer.distribution = UIStackViewDistributionFillProportionally;
    [line4SubContainer addArrangedSubview:space];
    [line4SubContainer addArrangedSubview:delete];

    [self addSubview:containerView];
}

- (void)_setNumberView:(CGRect)frame {
    NSArray *numbers = @[@[@"1", @"2", @"3"],
                         @[@"4", @"5", @"6"],
                         @[@"7", @"8", @"9"],
                         @[@".", @"0", @""]];
    CGFloat itemSpace = 8;
    UIStackView *containerView = [self _setMainContainer:frame item:numbers itemSpace:itemSpace];
    
    [self addSubview:containerView];
}

- (UIStackView *)_setMainContainer:(CGRect)frame item:(NSArray *)items itemSpace:(CGFloat)itemSpace {
    CGRect frame0 = CGRectMake(spaceH, spaceV, CGRectGetWidth(frame) - spaceH*2, CGRectGetHeight(frame) - spaceV*2);
    UIStackView *containerView = ({
        containerView = [[UIStackView alloc] initWithFrame:frame0];
        containerView.axis = UILayoutConstraintAxisVertical;
        containerView.distribution = UIStackViewDistributionFillEqually;
        containerView.spacing = 6;
        containerView;
    });
    
    CGRect itemFrame = [self _estimateKeyFrame:frame itemSpace:itemSpace];
    for (int i = 0; i < items.count; i++) {
        NSArray *line = items[i];
        UIStackView *subContainer = [self _setSubContainer:itemSpace];
        for (int j = 0; j < line.count; j++) {
            YYKeyButton *key = [[YYKeyButton alloc] initWithFrame:itemFrame];
            [key setTitle:line[j] forState:(UIControlStateNormal)];
            [key addTarget:self action:@selector(_didSelectItem:) forControlEvents:(UIControlEventTouchUpInside)];
            [subContainer addArrangedSubview:key];
        }
        [containerView addArrangedSubview:subContainer];
    }
    
    return containerView;
}

- (UIStackView *)_setSubContainer:(CGFloat)space {
    UIStackView *containerView = ({
        containerView = [[UIStackView alloc] initWithFrame:CGRectZero];
        containerView.axis = UILayoutConstraintAxisHorizontal;
        containerView.distribution = UIStackViewDistributionFillEqually;
        containerView.spacing = space;
        containerView;
    });
    
    return containerView;
}

- (YYKeyButton *)_spaceKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *space = [[YYKeyButton alloc] initWithFrame:frame];
    [space setImage:[UIImage imageNamed:@"Space"] forState:(UIControlStateNormal)];
    [space addTarget:self action:@selector(_didSelectSpace:) forControlEvents:(UIControlEventTouchUpInside)];

    return space;
}

- (YYKeyButton *)_deleteKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *delete = [[YYKeyButton alloc] initWithFrame:frame];
    [delete setImage:[UIImage imageNamed:@"Delete"] forState:(UIControlStateNormal)];
    [delete addTarget:self action:@selector(_didSelectDelete:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return delete;
}

- (CGRect)_estimateKeyFrame:(CGRect)superFrame itemSpace:(CGFloat)itemSpace {
    CGFloat estimateWidth = (CGRectGetWidth(superFrame) - itemSpace * 9) / 10;
    CGFloat estimateHeight = (CGRectGetHeight(superFrame) - spaceV * 3) / 4;
    CGRect keyFrame = CGRectMake(0, 0, estimateWidth, estimateHeight);
    
    return keyFrame;
}

- (CGSize)_estimateKeySize:(CGRect)superFrame itemSpace:(CGFloat)itemSpace {
    return [self _estimateKeyFrame:superFrame itemSpace:itemSpace].size;
}

#pragma mark - Action

- (void)_didSelectItem:(YYKeyButton *)sender {
    NSString *text = sender.titleLabel.text;
    NSLog(@"didSelectItem: %@", text);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_KeyboardView:didSelectKey:)]) {
        [self.delegate yy_KeyboardView:self didSelectKey:text];
    }
}

- (void)_didSelectSpace:(YYKeyButton *)sender {
    NSLog(@"didSelectSpace: \" \"");

}

- (void)_didSelectDelete:(YYKeyButton *)sender {
    NSLog(@"didSelectDelete");
}

- (void)_didSelectCapsLock:(YYKeyButton *)sender {
    [sender setSelectStatus:!sender.isSelected];
    NSLog(@"didSelectCapsLock: %d", sender.isSelected);
}

@end
