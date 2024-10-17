//
//  GTCaptcha4Proxy.h
//  GTCaptcha4
//
//  Created by noctis on 2024/10/14.
//  Copyright © 2024 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTCaptcha4Proxy : NSObject<NSCoding>
@property (copy, nonatomic) NSString *host;
@property (strong, nonatomic) NSNumber *port;

- (instancetype)initWithHost:(NSString *)host port:(NSNumber *)port;
@end

NS_ASSUME_NONNULL_END
