//
//  YYInputAccessoryView.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import "YYInputAccessoryView.h"

NSNotificationName const YYInputAccessoryDidReturnNotification = @"YYInputAccessoryDidReturnNotification";
NSNotificationName const YYInputAccessoryDidSwitchModeNotification = @"YYInputAccessoryDidSwitchModeNotification";

@interface YYInputAccessoryView()

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftItem1;
@property (weak, nonatomic) IBOutlet UIButton *leftItem2;

@end

@implementation YYInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"YYInputAccessoryView" owner:self options:nil] firstObject];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    
    return self;
}

- (IBAction)doneAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_inputAccessoryView:didSelectDone:)]) {
        [self.delegate yy_inputAccessoryView:self didSelectDone:YES];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYInputAccessoryDidReturnNotification object:self];
    }
}

- (IBAction)leftItem1Action:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    _leftItem2.selected = NO;
    self.mode = sender.isSelected ? YYInputAccessoryViewModeSymbol : YYInputAccessoryViewModeAbc;
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_inputAccessoryView:didSwitchMode:)]) {
        [self.delegate yy_inputAccessoryView:self didSwitchMode:self.mode];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYInputAccessoryDidSwitchModeNotification object:@(self.mode)];
    }
}

- (IBAction)leftItem2Action:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    _leftItem1.selected = NO;
    self.mode = sender.isSelected ? YYInputAccessoryViewModeNumber : YYInputAccessoryViewModeAbc;
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_inputAccessoryView:didSwitchMode:)]) {
        [self.delegate yy_inputAccessoryView:self didSwitchMode:self.mode];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYInputAccessoryDidSwitchModeNotification object:@(self.mode)];
    }
}

- (void)setItemColor:(UIColor *)itemColor {
    [self.leftItem1 setTitleColor:itemColor forState:(UIControlStateNormal)];
    [self.leftItem2 setTitleColor:itemColor forState:(UIControlStateNormal)];
    [self.doneBtn setTitleColor:itemColor forState:(UIControlStateNormal)];
}

- (void)setMode:(YYInputAccessoryViewMode)mode {
    _mode = mode;
}

@end
