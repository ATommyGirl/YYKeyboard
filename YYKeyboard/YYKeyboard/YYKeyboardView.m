//
//  YYKeyboardView.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "YYKeyboardView.h"

static CGFloat spaceH = 5.0f;
static CGFloat spaceV = 8.0f;

@interface YYKeyboardView()

@property (nonatomic, strong) dispatch_source_t dis_delete_timer;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation YYKeyboardView

- (instancetype)initWithFrame:(CGRect)frame style:(YYKeyboardViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        CGRect contentFrame = [self _contentFrameOn:frame];
        [self _setContentView:contentFrame];
        [self _setLetterView:contentFrame isCapital:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentFrame = [self _contentFrameOn:frame];
        [self _setContentView:contentFrame];
        [self _setLetterView:contentFrame isCapital:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode {
    UIStackView *container = self.contentView.subviews.firstObject;
    [container removeFromSuperview];
    CGRect contentFrame = [self _contentFrameOn:self.frame];
    switch (mode) {
        case YYInputAccessoryViewModeAbc:
            [self _setLetterView:contentFrame isCapital:NO];
            break;
        case YYInputAccessoryViewModeABC:
            [self _setLetterView:contentFrame isCapital:YES];
            break;
        case YYInputAccessoryViewModeSymbol:
            [self _setSymbolView:contentFrame];
            break;
        case YYInputAccessoryViewModeNumber:
            [self _setNumberView:contentFrame];
            break;
        default:
            break;
    }
}

- (void)_setContentView:(CGRect)frame {
    UIView *content = [[UIView alloc] initWithFrame:frame];
    [content setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:62/255.0 alpha:1]];
    [self addSubview:content];
    self.contentView = content;
}

- (CGRect)_contentFrameOn:(CGRect)frame {
    CGRect contentFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) - (isiPhoneX ? 34 : 0));
    return contentFrame;;
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
    [self _setAbcView:frame item:items isCapital:isCapital];
}
#pragma mark - Style
- (UIColor *)_keyBackgroundColor {
    UIColor *color = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
    switch (self.style) {
        case YYKeyboardViewStyleDark:
        case YYKeyboardViewStyleLikeSystemDark:
            break;
        case YYKeyboardViewStyleLight:
        case YYKeyboardViewStyleLikeSystemLight:
            color = [UIColor whiteColor];
            break;
    }
    return color;
}

- (UIColor *)_keyboardBackgroundColor {
    UIColor *color = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:62/255.0 alpha:1];
    switch (self.style) {
        case YYKeyboardViewStyleDark:
        case YYKeyboardViewStyleLikeSystemDark:
            break;
        case YYKeyboardViewStyleLight:
        case YYKeyboardViewStyleLikeSystemLight:
            color = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            break;
    }
    return color;
}

- (UIColor *)_keyColor {
    UIColor *color = [UIColor whiteColor];
    switch (self.style) {
        case YYKeyboardViewStyleDark:
        case YYKeyboardViewStyleLikeSystemDark:
            break;
        case YYKeyboardViewStyleLight:
        case YYKeyboardViewStyleLikeSystemLight:
            color = [UIColor blackColor];
            break;
    }
    return color;
}

#pragma mark - UI
- (void)_setAbcView:(CGRect)frame item:(NSArray *)items isCapital:(BOOL)isCapital {
    CGFloat itemSpace = 5;
    UIStackView *containerView = [self _setMainContainer:frame item:items itemSpace:itemSpace];
    
    //Caps Lock & Space & Delete 单独插入.
    YYKeyButton *capsLock = [self _capsLock:isCapital];
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
    
    [self.contentView addSubview:containerView];
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

    [self.contentView addSubview:containerView];
}

- (void)_setNumberView:(CGRect)frame {
    NSArray *numbers = [self _numbers:YES];
    
    CGFloat itemSpace = 8;
    UIStackView *containerView = [self _setMainContainer:frame item:numbers itemSpace:itemSpace];
    YYKeyButton *delete = [self _deleteKey:CGSizeZero];
    UIStackView *line4SubContainer = containerView.arrangedSubviews.lastObject;
    [line4SubContainer addArrangedSubview:delete];
    
    [self.contentView addSubview:containerView];
}

- (NSArray *)_numbers:(BOOL)isUpset {
    if (isUpset) {
        NSArray *sortNumbers = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
        sortNumbers = [sortNumbers sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            int seed = arc4random_uniform(2);
            if (seed) {
                return [str1 compare:str2];
            } else {
                return [str2 compare:str1];
            }
        }];
        
        NSMutableArray<NSMutableArray *> *numbers = [NSMutableArray arrayWithCapacity:4];
        [self _splitArray:sortNumbers count:0 lineCount:3 result:numbers];
        [numbers[3] insertObject:@"." atIndex:0];
        
        return numbers.mutableCopy;
    }
    return @[@[@"1", @"2", @"3"],
             @[@"4", @"5", @"6"],
             @[@"7", @"8", @"9"],
             @[@".", @"0"]];//Delete
}

- (void)_splitArray:(NSArray *)source count:(NSInteger)count lineCount:(NSInteger)lineC result:(NSMutableArray *)result {
    NSMutableArray * tempArray = [NSMutableArray array];
    while (count < source.count) {
        [tempArray addObject:source[count]];
        count++;

        if (count % lineC == 0) {
            break;
        }
        if (count == source.count) {
            [result addObject:tempArray];
            return;
        }
    }
    [result addObject:tempArray];
    [self _splitArray:source count:count lineCount:3 result:result];
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

- (YYKeyButton *)_capsLock:(BOOL)isCapital {
    YYKeyButton *capsLock = [[YYKeyButton alloc] initWithFrame:CGRectZero];
    capsLock.type = YYKeyButtonTypeCaps;
    [capsLock setImage:[UIImage imageNamed:@"CapsLock"] forState:(UIControlStateNormal)];
    [capsLock addTarget:self action:@selector(_didSelectCapsLock:) forControlEvents:(UIControlEventTouchUpInside)];
    [capsLock setSelected:isCapital];
    
    return capsLock;
}

- (YYKeyButton *)_spaceKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *space = [[YYKeyButton alloc] initWithFrame:frame];
    space.type = YYKeyButtonTypeSpace;
    [space setImage:[UIImage imageNamed:@"Space"] forState:(UIControlStateNormal)];
    [space addTarget:self action:@selector(_didSelectSpace:) forControlEvents:(UIControlEventTouchUpInside)];

    return space;
}

- (YYKeyButton *)_deleteKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *delete = [[YYKeyButton alloc] initWithFrame:frame];
    delete.type = YYKeyButtonTypeDelete;
    [delete setImage:[UIImage imageNamed:@"Delete"] forState:(UIControlStateNormal)];
    [delete addTarget:self action:@selector(_didSelectDelete:) forControlEvents:(UIControlEventTouchUpInside)];

    //加个 longPressGesture ，设置如下：
    UILongPressGestureRecognizer *pahGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressGestureRecognizerStateChanged:)];
    pahGestureRecognizer.minimumPressDuration = 0.5;
    [delete addGestureRecognizer:pahGestureRecognizer];
    
    return delete;
}

- (void)_longPressGestureRecognizerStateChanged:(UIGestureRecognizer *)gestureRecognizer {
    YYKeyButton *delete = (YYKeyButton *)gestureRecognizer.view;
    [delete setSelected:YES];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self _dis_delete_timer];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            dispatch_source_cancel(_dis_delete_timer);
            _dis_delete_timer = nil;
            [delete setSelected:NO];
            break;
        }
        default:
            break;
    }
}

- (void)_dis_delete_timer {
    if (!_dis_delete_timer) {
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _deleteAction];
            });
        });
        
        dispatch_resume(timer);
        _dis_delete_timer = timer;
    }
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_KeyboardView:didSelectKey:text:)]) {
        [self.delegate yy_KeyboardView:self didSelectKey:(YYKeyButtonTypeNormal) text:text];
    }
}

- (void)_didSelectSpace:(YYKeyButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_KeyboardView:didSelectKey:text:)]) {
        [self.delegate yy_KeyboardView:self didSelectKey:(YYKeyButtonTypeSpace) text:@" "];
    }
}

- (void)_didSelectDelete:(YYKeyButton *)sender {
    [self _deleteAction];
}

- (void)_deleteAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_KeyboardView:didSelectKey:text:)]) {
        [self.delegate yy_KeyboardView:self didSelectKey:(YYKeyButtonTypeDelete) text:@""];
    }
}

- (void)_didSelectCapsLock:(YYKeyButton *)sender {
    sender.selected = !sender.isSelected;
    
    //Set ABC or abc.
    UIStackView *container = self.contentView.subviews.firstObject;
    for (UIStackView *subContainer in container.arrangedSubviews) {
        for (YYKeyButton *key in subContainer.arrangedSubviews) {
            NSString *currentTitle = key.currentTitle;
            if (sender.isSelected) {
                [key setTitle:[currentTitle uppercaseString] forState:(UIControlStateNormal)];
            }else {
                [key setTitle:[currentTitle lowercaseString] forState:(UIControlStateNormal)];
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_KeyboardView:didSelectKey:text:)]) {
        [self.delegate yy_KeyboardView:self didSelectKey:(YYKeyButtonTypeCaps) text:@""];
    }
}

- (void)dealloc {
    NSLog(@"YYKeyboardView dealloc.");
}

@end
