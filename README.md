# YYKeyboard
`YYKeyboard` 是一个简单的 iOS 安全键盘，支持输入 英文大小写字母、常用符号、数字。

PS：写这个 demo 纯粹是为了使用一下 `UIStackView` …… 介意的勿用~~🤓

## 使用

* 把工程中的子目录 `YYKeyboard` 添加到工程中。

* 引用  `UITextField` 的一个子类、初始化、设置代理、遵循协议 `YYKBTextFieldDelegate`

```objc
#import "YYKBTextField.h"

@interface ViewController () <YYKBTextFieldDelegate>

//或者纯代码初始化，略过~~
@property (weak, nonatomic) IBOutlet YYKBTextField *textField;

@end

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //...
    self.textField.yy_keyboardDelegate = self;
    //...
}

//...

//textField 内容发生变化，按需实现
- (void)yykb_textField:(YYKBTextField *)textField didEnterCharacters:(NSString *)string {
    NSLog(@"YYKBTextField didEnterCharacters : %@", string);
}

//点击完成按钮，按需实现
- (void)yykb_textFieldDidPressReturn:(YYKBTextField *)textField {
    NSLog(@"YYKBTextField: Login success!");
}
```

