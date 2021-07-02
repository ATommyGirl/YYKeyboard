//
//  WKWebViewController.m
//  YYKeyboard
//
//  Created by xiaotian on 2021/6/22.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

#import "YYKBTextField.h"

@interface WKWebViewController ()< WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, YYKeyboardViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) YYKBTextField *forKeyboard;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"YYKeyboard"];
    WKWebViewConfiguration *configuration = ({
        configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        if (@available(iOS 10.0, *)) {
            [configuration setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        }
        if (@available(iOS 14.0, *)) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = YES;
        }else {
            configuration.preferences.javaScriptEnabled = YES;
        }
        configuration;
    });
    
    WKWebView *webView = ({
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) configuration:configuration];
        webView.scrollView.bounces = NO;
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        webView;
    });
    self.webView = webView;
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillShow:)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardDidHide:)
                                          name:UIKeyboardDidHideNotification
                                          object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"[:%s",__FUNCTION__);
    UIResponder *first = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    NSLog(@"\n%@\n%@\n%@", first, first.inputView, first.inputAccessoryView);
    NSLog(@"--------------");
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSLog(@"[:%s",__FUNCTION__);
    UIResponder *first = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    NSLog(@"\n%@\n%@\n%@", first, first.inputView, first.inputAccessoryView);
    NSLog(@"--------------");
    
    for (UIView *view in self.webView.scrollView.subviews) {
        if([[view.class description] hasPrefix:@"WKContent"]) {
            [view reloadInputViews];
        }
    }
}

- (void)setInputViewForWKWebView:(WKWebView *)webView {
    UIView *targetView;

    for (UIView *view in webView.scrollView.subviews) {
        if([[view.class description] hasPrefix:@"WKContent"]) {
            targetView = view;
        }
    }

    if (!targetView) {
        return;
    }

    NSString *keyboardViewClassName = [NSString stringWithFormat:@"%@_YYKeyboardView", targetView.class];
    Class newClass = NSClassFromString(keyboardViewClassName);

    if(newClass == nil) {
        newClass = objc_allocateClassPair(targetView.class, [keyboardViewClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
        if(!newClass) {
            return;
        }

        Method method = class_getInstanceMethod([_YYKeyboardView class], @selector(inputView));
        class_addMethod(newClass, @selector(inputView), method_getImplementation(method), method_getTypeEncoding(method));
        Method method1 = class_getInstanceMethod([_YYKeyboardView class], @selector(inputAccessoryView));
        class_addMethod(newClass, @selector(inputAccessoryView), method_getImplementation(method1), method_getTypeEncoding(method1));
        
        objc_registerClassPair(newClass);
    }

    object_setClass(targetView, newClass);
}

- (void)removeInputViewForWKWebView:(WKWebView *)webView {
    UIView *targetView;

    for (UIView *view in webView.scrollView.subviews) {
        if([[view.class description] hasPrefix:@"WKContent"]) {
            targetView = view;
            break;
        }
    }

    if (!targetView) {
        return;
    }

    NSString *contentViewClassName = @"WKContentView";
    Class newClass = NSClassFromString(contentViewClassName);

    if(newClass == nil) {
        newClass = objc_allocateClassPair(targetView.class, [contentViewClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
        if(!newClass) {
            return;
        }
        objc_registerClassPair(newClass);
    }

    object_setClass(targetView, newClass);
}

- (void)yy_keyboardView:(YYKeyboardView *)keyboard didSelectKey:(YYKeyButtonType)type text:(NSString *)text {
    NSLog(@"[:%@]%s", text, __FUNCTION__);
    [self.webView evaluateJavaScript:@"document.getElementById('password').value" completionHandler:^(id result, NSError * _Nullable error) {
        //result就是获取到的内容
        NSString *value = result;
        value = [value stringByAppendingString:text];
        NSString *js = [NSString stringWithFormat:@"document.getElementById('password').value = '%@'", value];
        [self.webView evaluateJavaScript:js completionHandler:^(id newResult, NSError * _Nullable error) {
            NSLog(@"New result : %@", result);
        }];
    }];
}

- (void)yy_keyboardViewDidEndEditing:(YYKeyboardView *)keyboard {
    [self.webView endEditing:YES];
    [self removeInputViewForWKWebView:self.webView];
}

- (YYKBTextField *)forKeyboard {
    if (!_forKeyboard) {
        YYKBTextField *field = [[YYKBTextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _forKeyboard = field;;
        [self.view addSubview:field];
    }
    
    return _forKeyboard;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"[:%s",__FUNCTION__);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"[:%s",__FUNCTION__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"[:%s",__FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[:%s: %@", __FUNCTION__, error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[:%s: %@", __FUNCTION__, error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"[:%s",__FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"[:%s",__FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"[:%s",__FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:a];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:defaultText?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];

    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView contextMenuWillPresentForElement:(WKContextMenuElementInfo *)elementInfo  API_AVAILABLE(ios(13.0)){
    NSLog(@"[:%s",__FUNCTION__);

}

- (void)webView:(WKWebView *)webView contextMenuConfigurationForElement:(WKContextMenuElementInfo *)elementInfo completionHandler:(void (^)(UIContextMenuConfiguration * _Nullable))completionHandler  API_AVAILABLE(ios(13.0)){
    NSLog(@"[:%s",__FUNCTION__);

}

- (void)webView:(WKWebView *)webView contextMenuDidEndForElement:(WKContextMenuElementInfo *)elementInfo  API_AVAILABLE(ios(13.0)){
    NSLog(@"[:%s",__FUNCTION__);

}

- (void)webView:(WKWebView *)webView contextMenuForElement:(WKContextMenuElementInfo *)elementInfo willCommitWithAnimator:(id<UIContextMenuInteractionCommitAnimating>)animator  API_AVAILABLE(ios(13.0)){
    NSLog(@"[:%s",__FUNCTION__);

}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body caseInsensitiveCompare:@"open"] == NSOrderedSame) {
        //Call your keyboard.
        [self setInputViewForWKWebView:self.webView];
        for (UIView *view in self.webView.scrollView.subviews) {
            if([[view.class description] hasPrefix:@"WKContent"]) {
                [view reloadInputViews];
            }
        }
    }else if([message.body caseInsensitiveCompare:@"close"] == NSOrderedSame) {
        
    }
}

@end


@implementation _YYKeyboardView

- (id)inputAccessoryView {
    return [[self inputView] inputAccessoryView];
}

- (YYKeyboardView *)inputView {
    CGRect keyboardFrame  = CGRectMake(0, 0, SCREEN_WIDTH, MAX(210, SCREEN_HEIGHT * 0.305) + (isiPhoneX ? 34 : 0));
    YYKeyboardView *keyboard = [[YYKeyboardView alloc] initWithFrame:keyboardFrame style:(YYKeyboardStyleLight)];
    
    return keyboard;
}

@end
