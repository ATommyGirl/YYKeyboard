//
//  UIWebViewController.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/22.
//

#import "UIWebViewController.h"
#import "YYKeyboard/YYKeyboardView.h"
#import "YYKBTextField.h"
#import "YYKBTextField.h"

@interface UIWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) YYKBTextField *forKeyboard;

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(KeyboardWillShow:)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(KeyboardWillHide:)
                                          name:UIKeyboardWillHideNotification
                                          object:nil];
}

- (void)KeyboardWillShow:(NSNotification *)aNotification {
    NSLog(@"--------------");
    UIResponder *first = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    NSLog(@"\n%@\n%@\n%@", first, first.inputView, first.inputAccessoryView);
    NSLog(@"--------------");

}

- (void)KeyboardWillHide:(NSNotification *)aNotification {
    NSLog(@"--------------");
    UIResponder *first = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    NSLog(@"\n%@\n%@\n%@", first, first.inputView, first.inputAccessoryView);
    NSLog(@"--------------");
}

- (YYKBTextField *)forKeyboard {
    if (!_forKeyboard) {
        YYKBTextField *field = [[YYKBTextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _forKeyboard = field;
        [self.view addSubview:field];
    }
    
    return _forKeyboard;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"keyboard"]) {
        //open my keyboard.
        if (self.forKeyboard.canBecomeFocused) {
            
        }
        [self.forKeyboard becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
