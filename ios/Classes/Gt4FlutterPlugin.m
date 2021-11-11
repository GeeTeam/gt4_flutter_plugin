#import "Gt4FlutterPlugin.h"

@interface Gt4FlutterPlugin () <GTCaptcha4SessionTaskDelegate>

@property (nonatomic, strong) GTCaptcha4Session *captchaSession;

@end

@implementation Gt4FlutterPlugin {
  FlutterMethodChannel *_channel;
  FlutterResult  _result;
  FlutterMethodCall  *_call;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                      methodChannelWithName:@"gt4_flutter_plugin"
                                      binaryMessenger:[registrar messenger]];
      
    Gt4FlutterPlugin *instance = [[Gt4FlutterPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (NSString *)getPlatformVersion {
    return [GTCaptcha4Session sdkVersion];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSDictionary *args = call.arguments;
    NSString *captchaID = args[@"captchaId"];
    NSDictionary *params = args[@"config"];

    GTCaptcha4SessionConfiguration *config = [GTCaptcha4SessionConfiguration defaultConfiguration];
    config.additionalParameter = [params mutableCopy];
    self.captchaSession = [GTCaptcha4Session sessionWithCaptchaID:captchaID configuration:config];
    self.captchaSession.delegate = self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *method = call.method;
    if ([@"initWithCaptcha" isEqualToString:method]) {
        [self init:call result:result];
    }
    else if ([@"verify" isEqualToString:method]) {
        [self.captchaSession verify];
    }
    else if ([@"close" isEqualToString:method]) {
        [self.captchaSession cancel];
    }
    else if ([@"getPlatformVersion" isEqualToString:method]) {
        result([GTCaptcha4Session sdkVersion]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark GTCaptcha4SessionTaskDelegate

- (void)gtCaptchaSession:(GTCaptcha4Session *)captchaSession didReceive:(NSString *)status result:(NSDictionary *)result {
    NSLog(@"Captcha4 status: %@, result: %@", status, result);
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    
    [ret setValue:status  forKey:@"status"];
    [ret setValue:result  forKey:@"result"];

    [_channel invokeMethod:@"onResult" arguments:ret];
}

- (void)gtCaptchaSession:(GTCaptcha4Session *)captchaSession didReceiveError:(GTC4Error *)error {
    NSLog(@"Captcha4 error: %@", error.description);

    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    [ret setValue:error.code  forKey:@"code"];
    [ret setValue:error.msg   forKey:@"msg"];
    [ret setValue:error.desc  forKey:@"desc"];
    [_channel invokeMethod:@"onError" arguments:ret];
}

- (void)gtCaptchaSessionWillShow:(GTCaptcha4Session *)captchaSession {
    NSLog(@"Captcha4 will show UI.");

    [_channel invokeMethod:@"onShow" arguments:@{@"show" : @"1"}];
}

@end
