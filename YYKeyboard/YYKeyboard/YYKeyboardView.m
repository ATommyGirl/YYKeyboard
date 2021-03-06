//
//  YYKeyboardView.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "YYKeyboardView.h"
#import <AudioToolbox/AudioToolbox.h>

static CGFloat spaceH = 5.0f;
static CGFloat spaceV = 8.0f;

@interface YYKeyboardView() <YYInputAccessoryViewDelegate>

@property (nonatomic, strong) dispatch_source_t dis_delete_timer;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation YYKeyboardView

- (instancetype)initWithFrame:(CGRect)frame style:(YYKeyboardStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        CGRect contentFrame = [self contentFrameOn:frame];
        [self _setContentView:contentFrame];
        [self setLetterView:contentFrame isCapital:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addYYInputAccessoryViewNotification];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentFrame = [self contentFrameOn:frame];
        [self _setContentView:contentFrame];
        [self setLetterView:contentFrame isCapital:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addYYInputAccessoryViewNotification];
    }
    
    return self;
}

- (void)switchKeyboardMode:(YYInputAccessoryViewMode)mode {
    UIStackView *container = self.contentView.subviews.firstObject;
    [container removeFromSuperview];
    CGRect contentFrame = [self contentFrameOn:self.frame];
    switch (mode) {
        case YYInputAccessoryViewModeAbc:
            [self setLetterView:contentFrame isCapital:NO];
            break;
        case YYInputAccessoryViewModeABC:
            [self setLetterView:contentFrame isCapital:YES];
            break;
        case YYInputAccessoryViewModeSymbol:
            [self setSymbolView:contentFrame];
            break;
        case YYInputAccessoryViewModeNumber:
            [self setNumberView:contentFrame];
            break;
        default:
            break;
    }
}

- (void)_setContentView:(CGRect)frame {
    UIView *content = [[UIView alloc] initWithFrame:frame];
    [content setBackgroundColor:[YYKeyboard keyboardBackgroundColor:self.style]];
    [self addSubview:content];
    self.contentView = content;
}

- (CGRect)contentFrameOn:(CGRect)frame {
    CGRect contentFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) - (isiPhoneX ? (34 + 15) : 0));
    return contentFrame;;
}

#pragma mark - UI
- (void)setLetterView:(CGRect)frame isCapital:(BOOL)isCapital {
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
    [self setAbcView:frame item:items isCapital:isCapital];
}

- (void)setAbcView:(CGRect)frame item:(NSArray *)items isCapital:(BOOL)isCapital {
    CGFloat itemSpace = 5;
    UIStackView *containerView = [self setMainContainer:frame item:items itemSpace:itemSpace];
    
    //Caps Lock & Space & Delete ????????????.
    YYKeyButton *capsLock = [self capsLock:isCapital];
    UIStackView *line3SubContainer = containerView.arrangedSubviews[2];
    [line3SubContainer insertArrangedSubview:capsLock atIndex:0];
    CGSize estimateKeySize = [self estimateKeySize:frame itemSpace:itemSpace];
    CGFloat estimateWidth  = estimateKeySize.width;
    CGFloat estimateHeight = estimateKeySize.height;
    CGFloat deleteWidth    = estimateWidth + (estimateWidth - itemSpace)*0.5 + spaceH;
    YYKeyButton *space  = [self spaceKey:CGSizeMake(deleteWidth, estimateHeight)];
    YYKeyButton *delete = [self deleteKey:CGSizeMake(deleteWidth, estimateHeight)];
    UIStackView *line4SubContainer = containerView.arrangedSubviews[3];
    line4SubContainer.distribution = UIStackViewDistributionFillProportionally;
    [line4SubContainer insertArrangedSubview:space atIndex:0];
    [line4SubContainer addArrangedSubview:delete];
    
    [self.contentView addSubview:containerView];
}

- (void)setSymbolView:(CGRect)frame {
    NSArray *symbols = @[@[@"&", @"\"", @";", @"^", @",", @"|", @"$", @"*", @":", @"'"],
                         @[@"?", @"{", @"[", @"~", @"#", @"}", @".", @"]", @"\\", @"!"],
                         @[@"(", @"%", @"-", @"_", @"+", @"/", @")", @"=", @"<", @"`"],
                         @[@">", @"@"]];/*Space & Delete*/

    CGFloat itemSpace = 5;
    UIStackView *containerView = [self setMainContainer:frame item:symbols itemSpace:itemSpace];
    
    //Space & Delete ????????????.
    CGSize estimateKeySize = [self estimateKeySize:frame itemSpace:itemSpace];
    CGFloat estimateWidth  = estimateKeySize.width;
    CGFloat estimateHeight = estimateKeySize.height;
    CGFloat deleteWidth    = estimateWidth + (estimateWidth - itemSpace)*0.5 + spaceH;
    YYKeyButton *space  = [self spaceKey:CGSizeMake(deleteWidth + (estimateWidth + itemSpace) * 5, estimateHeight)];
    YYKeyButton *delete = [self deleteKey:CGSizeMake(deleteWidth, estimateHeight)];
    UIStackView *line4SubContainer = containerView.arrangedSubviews.lastObject;
    line4SubContainer.distribution = UIStackViewDistributionFillProportionally;
    [line4SubContainer addArrangedSubview:space];
    [line4SubContainer addArrangedSubview:delete];

    [self.contentView addSubview:containerView];
}

- (void)setNumberView:(CGRect)frame {
    NSArray *numbers = [self numbers:YES];
    
    CGFloat itemSpace = 8;
    UIStackView *containerView = [self setMainContainer:frame item:numbers itemSpace:itemSpace];
    YYKeyButton *delete = [self deleteKey:CGSizeZero];
    UIStackView *line4SubContainer = containerView.arrangedSubviews.lastObject;
    [line4SubContainer addArrangedSubview:delete];
    
    [self.contentView addSubview:containerView];
}

- (NSArray *)numbers:(BOOL)isUpset {
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
        [self splitArray:sortNumbers count:0 lineCount:3 result:numbers];
        [numbers[3] insertObject:@"." atIndex:0];
        
        return numbers.mutableCopy;
    }
    return @[@[@"1", @"2", @"3"],
             @[@"4", @"5", @"6"],
             @[@"7", @"8", @"9"],
             @[@".", @"0"]];//Delete
}

- (void)splitArray:(NSArray *)source count:(NSInteger)count lineCount:(NSInteger)lineC result:(NSMutableArray *)result {
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
    [self splitArray:source count:count lineCount:3 result:result];
}

- (UIStackView *)setMainContainer:(CGRect)frame item:(NSArray *)items itemSpace:(CGFloat)itemSpace {
    CGRect frame0 = CGRectMake(spaceH, spaceV, CGRectGetWidth(frame) - spaceH*2, CGRectGetHeight(frame) - spaceV*2);
    UIStackView *containerView = ({
        containerView = [[UIStackView alloc] initWithFrame:frame0];
        containerView.axis = UILayoutConstraintAxisVertical;
        containerView.distribution = UIStackViewDistributionFillEqually;
        containerView.spacing = 6;
        containerView;
    });
    
    CGRect itemFrame = [self estimateKeyFrame:frame itemSpace:itemSpace];
    for (int i = 0; i < items.count; i++) {
        NSArray *line = items[i];
        UIStackView *subContainer = [self setSubContainer:itemSpace];
        for (int j = 0; j < line.count; j++) {
            YYKeyButton *key = [[YYKeyButton alloc] initWithFrame:itemFrame style:self.style];
            [key setTitle:line[j] forState:(UIControlStateNormal)];
            [key addTarget:self action:@selector(didSelectItem:) forControlEvents:(UIControlEventTouchUpInside)];
            [subContainer addArrangedSubview:key];
        }
        [containerView addArrangedSubview:subContainer];
    }
    
    return containerView;
}

- (UIStackView *)setSubContainer:(CGFloat)space {
    UIStackView *containerView = ({
        containerView = [[UIStackView alloc] initWithFrame:CGRectZero];
        containerView.axis = UILayoutConstraintAxisHorizontal;
        containerView.distribution = UIStackViewDistributionFillEqually;
        containerView.spacing = space;
        containerView;
    });
    
    return containerView;
}

- (YYKeyButton *)capsLock:(BOOL)isCapital {
    YYKeyButton *capsLock = [[YYKeyButton alloc] initWithFrame:CGRectZero style:self.style];
    capsLock.type = YYKeyButtonTypeCaps;
    [capsLock setImage:[UIImage imageNamed:@"CapsLock"] forState:(UIControlStateNormal)];
    [capsLock addTarget:self action:@selector(didSelectCapsLock:) forControlEvents:(UIControlEventTouchUpInside)];
    [capsLock setSelected:isCapital];
    
    return capsLock;
}

- (YYKeyButton *)spaceKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *space = [[YYKeyButton alloc] initWithFrame:frame style:self.style];
    space.type = YYKeyButtonTypeSpace;
    [space setImage:[UIImage imageNamed:@"Space"] forState:(UIControlStateNormal)];
    [space addTarget:self action:@selector(didSelectSpace:) forControlEvents:(UIControlEventTouchUpInside)];

    return space;
}

- (YYKeyButton *)deleteKey:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    YYKeyButton *delete = [[YYKeyButton alloc] initWithFrame:frame style:self.style];
    delete.type = YYKeyButtonTypeDelete;
    [delete setImage:[UIImage imageNamed:@"Delete"] forState:(UIControlStateNormal)];
    [delete addTarget:self action:@selector(didSelectDelete:) forControlEvents:(UIControlEventTouchUpInside)];

    //?????? longPressGesture ??????????????????
    UILongPressGestureRecognizer *pahGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerStateChanged:)];
    pahGestureRecognizer.minimumPressDuration = 0.5;
    [delete addGestureRecognizer:pahGestureRecognizer];
    
    return delete;
}

- (void)longPressGestureRecognizerStateChanged:(UIGestureRecognizer *)gestureRecognizer {
    YYKeyButton *delete = (YYKeyButton *)gestureRecognizer.view;
    [delete setSelected:YES];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self dis_delete_timer:delete];
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

- (void)dis_delete_timer:(YYKeyButton *)sender {
    if (!_dis_delete_timer) {
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didSelectDelete:sender];
            });
        });
        
        dispatch_resume(timer);
        _dis_delete_timer = timer;
    }
}

- (CGRect)estimateKeyFrame:(CGRect)superFrame itemSpace:(CGFloat)itemSpace {
    CGFloat estimateWidth = (CGRectGetWidth(superFrame) - itemSpace * 9) / 10;
    CGFloat estimateHeight = (CGRectGetHeight(superFrame) - spaceV * 3) / 4;
    CGRect keyFrame = CGRectMake(0, 0, estimateWidth, estimateHeight);
    
    return keyFrame;
}

- (CGSize)estimateKeySize:(CGRect)superFrame itemSpace:(CGFloat)itemSpace {
    return [self estimateKeyFrame:superFrame itemSpace:itemSpace].size;
}

#pragma mark - Action
- (void)playSystemSound {
    AudioServicesPlaySystemSound(1104);
}

- (void)didSelectItem:(YYKeyButton *)sender {
    NSString *text = sender.titleLabel.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_keyboardView:didSelectKey:text:)]) {
        [self.delegate yy_keyboardView:self didSelectKey:(YYKeyButtonTypeNormal) text:text];
    }
    [self playSystemSound];
}

- (void)didSelectSpace:(YYKeyButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_keyboardView:didSelectKey:text:)]) {
        [self.delegate yy_keyboardView:self didSelectKey:(YYKeyButtonTypeSpace) text:@" "];
    }
    [self playSystemSound];
}

- (void)didSelectDelete:(YYKeyButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_keyboardView:didSelectKey:text:)]) {
        [self.delegate yy_keyboardView:self didSelectKey:(YYKeyButtonTypeDelete) text:@""];
    }
    [self playSystemSound];
}

- (void)didSelectCapsLock:(YYKeyButton *)sender {
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_keyboardView:didSelectKey:text:)]) {
        [self.delegate yy_keyboardView:self didSelectKey:(YYKeyButtonTypeCaps) text:@""];
    }
    [self playSystemSound];
}

- (id<YYKeyboardViewDelegate>)delegate {
    if (!_delegate) {
        _delegate = [self performSelector:@selector(topViewController)];
    }
    
    return _delegate;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    
    if ([resultVC isKindOfClass:[UINavigationController class]]) {
        resultVC = resultVC.childViewControllers.lastObject;
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)dealloc {
    NSLog(@"YYKeyboardView dealloc.");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Input Accessory View

- (void)addYYInputAccessoryViewNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_switchKeyboardMode:) name:YYInputAccessoryDidSwitchModeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yy_inputAccessoryView:didSelectDone:) name:YYInputAccessoryDidReturnNotification object:nil];
}

- (void)_switchKeyboardMode:(NSNotification *)notification {
    YYInputAccessoryViewMode mode = [notification.object integerValue];
    [self switchKeyboardMode:mode];
}

- (YYInputAccessoryView *)inputAccessoryView {
    YYInputAccessoryView *inputAccessoryView = [[YYInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    inputAccessoryView.delegate = self;
    inputAccessoryView.backgroundColor = [YYKeyboard keyboardBackgroundColor:self.style];
    inputAccessoryView.titleLabel.textColor = [YYKeyboard titleColor:self.style];
    
    return inputAccessoryView;
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSelectDone:(BOOL)done {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_keyboardViewDidEndEditing:)]) {
        [self.delegate yy_keyboardViewDidEndEditing:self];
    }
}

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSwitchMode:(YYInputAccessoryViewMode)mode {
    [self switchKeyboardMode:mode];
}

@end
