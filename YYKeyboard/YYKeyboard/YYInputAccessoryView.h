//
//  YYInputAccessoryView.h
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/2.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YYInputAccessoryViewMode){
    YYInputAccessoryViewModeAbc = 0,
    YYInputAccessoryViewModeSymbol,
    YYInputAccessoryViewModeNumber
};

@class YYInputAccessoryView;
@protocol YYInputAccessoryViewDelegate <NSObject>
@optional

- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSelectDone:(BOOL)done;
- (void)yy_inputAccessoryView:(YYInputAccessoryView *)inputAccessoryView didSwitchMode:(YYInputAccessoryViewMode)mode;

@end

@interface YYInputAccessoryView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIColor *itemColor;
@property (assign, nonatomic) YYInputAccessoryViewMode mode;
@property (weak, nonatomic) id<YYInputAccessoryViewDelegate> delegate;

@end
