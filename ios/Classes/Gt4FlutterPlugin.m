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

    self.captchaSession = [GTCaptcha4Session sessionWithCaptchaID:captchaID configuration:[self parseConfig:params]];
    self.captchaSession.delegate = self;
}

- (GTCaptcha4SessionConfiguration *)parseConfig:(NSDictionary *)params {
    GTCaptcha4SessionConfiguration *config = [GTCaptcha4SessionConfiguration defaultConfiguration];
    if (params != nil) {
        if (params[@"resourcePath"]) {
            config.resourcePath = params[@"resourcePath"];
        }
        if (params[@"protocol"]) {
            config.protocol = params[@"protocol"];
        }
        if (params[@"userInterfaceStyle"] && [params[@"userInterfaceStyle"] integerValue]) {
            config.userInterfaceStyle = [params[@"userInterfaceStyle"] integerValue];
        }
        if (params[@"displayStyle"] && [params[@"displayStyle"] integerValue]) {
            config.displayStyle = [params[@"displayStyle"] integerValue];
        }
        if (params[@"backgroundColor"]) {
            config.backgroundColor = [self colorWithHex:params[@"backgroundColor"]];
        }
        if (params[@"debugEnable"] && [params[@"debugEnable"] boolValue]) {
            config.debugEnable = [params[@"debugEnable"] boolValue];
        }
        if (params[@"canceledOnTouchOutside"] && [params[@"canceledOnTouchOutside"] boolValue]) {
            config.backgroundUserInteractionEnable = [params[@"canceledOnTouchOutside"] boolValue];
        }
        if (params[@"timeout"] && [params[@"timeout"] integerValue]) {
            config.timeout = [params[@"timeout"] integerValue] / 1000;
        }
        if (params[@"language"]) {
            config.language = params[@"language"];
        }
        if (params[@"additionalParameter"] && [params[@"additionalParameter"] isKindOfClass:[NSDictionary class]]) {
            config.additionalParameter = params[@"additionalParameter"];
        }
    }
    return config;
}

- (UIColor *)colorWithHex:(NSString *)cString {
    NSString *hexString = [cString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // strip 0X if it appears
    if ([hexString hasPrefix:@"0X"])
        hexString = [hexString substringFromIndex:2];
    if ([hexString hasPrefix:@"#"])
        hexString = [hexString substringFromIndex:1];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int color = 0;
    [scanner scanHexInt:&color];
    uint32_t a = 0,r = 0,g = 0,b = 0;
    switch (cString.length) {
        case 3:
            a = 255;
            r = (color >> 8) * 17;
            g = (color >> 4 & 0xF) * 17;
            b = (color & 0xF) * 17;
            break;
        case 6:
            a = 255;
            r = color >> 16;
            g = color >> 8 & 0xFF;
            b = color & 0xFF;
        case 8:
            a = color >> 24;
            r = color >> 16 & 0xFF;
            g = color >> 8 & 0xFF;
            b = color & 0xFF;
            break;
        default:
            break;
    }
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
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
