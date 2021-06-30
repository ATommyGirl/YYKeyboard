//
//  ViewController.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/1.
//

#import "ViewController.h"
#import "YYKBTextField.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet YYKBTextField *textField;

@end

#define isiPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(KeyboardWillShow:)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];

    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(KeyboardWillHide:)
                                          name:UIKeyboardWillHideNotification
                                          object:nil];
}


- (void)KeyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375

     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414

     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320

     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768

     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect KeyboardRect = [aValue CGRectValue];
    int height = KeyboardRect.size.height;
    int width = KeyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
}

//当键退出时调用
- (void)KeyboardWillHide:(NSNotification *)aNotification
{
}

- (IBAction)testAction:(id)sender {
    
}

@end
