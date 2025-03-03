//
//  UIViewController+Ext.h
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)
+ (NSString *)winRicoGetUserDefaultKey;

+ (void)winRicoSetUserDefaultKey:(NSString *)key;

- (void)winRicoSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)winRicoAppsFlyerDevKey;

- (NSString *)winRicoMainHostUrl;

- (BOOL)winRicoNeedShowAdsView;

- (void)winRicoShowAdView:(NSString *)adsUrl;

- (void)winRicoendEventsWithParams:(NSString *)params;

- (NSDictionary *)winRicoJsonToDicWithJsonString:(NSString *)jsonString;

- (void)winRicoSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)winRicoSendEventWithName:(NSString *)name value:(NSString *)valueStr;

- (NSDictionary *)mergeDictionaries:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

- (NSDictionary *)sortedDictionaryByKey:(NSDictionary *)dict;

- (NSDictionary *)filterDictionary:(NSDictionary *)dict withBlock:(BOOL (^)(id key, id value))block;
@end

NS_ASSUME_NONNULL_END
