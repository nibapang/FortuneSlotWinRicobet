//
//  UIViewController+Ext.m
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

#import "UIViewController+Ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString *KdynastyDefaultkey __attribute__((section("__DATA, winRico"))) = @"";

NSDictionary *KdynastyJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, winRico")));
NSDictionary *KdynastyJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KdynastyJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, winRico")));
id KdynastyJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KdynastyJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KdynastyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, winRico")));
void KdynastyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.winRicoGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KdynastySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, winRico")));
void KdynastySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.winRicoGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KdynastyAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, winRico")));
NSString *KdynastyAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KdynastyConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, winRico")));
NSString* KdynastyConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}
@implementation UIViewController (Ext)



+ (NSString *)winRicoGetUserDefaultKey
{
    return KdynastyDefaultkey;
}

+ (void)winRicoSetUserDefaultKey:(NSString *)key
{
    KdynastyDefaultkey = key;
}

+ (NSString *)winRicoAppsFlyerDevKey
{
    return KdynastyAppsFlyerDevKey(@"winRicozt99WFGrJwb3RdzuknjXSKwinRico");
}

- (NSString *)winRicoMainHostUrl
{
    return @"ngji.top";
}

- (BOOL)winRicoNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isB = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"M%@", self.preBx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return (isB||isM) && !isIpd;
}

- (NSString *)preFx
{
    return @"B";
}

- (NSString *)preBx
{
    return @"X";
}

- (void)winRicoShowAdView:(NSString *)adsUrl
{
    KdynastyShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)winRicoJsonToDicWithJsonString:(NSString *)jsonString {
    return KdynastyJsonToDicLogic(jsonString);
}

- (void)winRicoSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KdynastySendEventLogic(self, event, value);
}

- (void)winRicoendEventsWithParams:(NSString *)params
{
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.winRicoGetUserDefaultKey];
    NSDictionary *paramsDic = [self winRicoJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        
        double pp = 0;
        NSString *cur = nil;
        NSDictionary *fDic = nil;
        
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
                
                if ([key isEqualToString:adsDatas[16]]) {
                    pp = value.doubleValue;
                } else if ([key isEqualToString:adsDatas[17]]) {
                    cur = value;
                    fDic = @{
                        FBSDKAppEventParameterNameCurrency:cur
                    };
                }
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
        
        if (pp > 0) {
            [FBSDKAppEvents.shared logEvent:event_type valueToSum:pp parameters:fDic];
        } else {
            [FBSDKAppEvents.shared logEvent:event_type parameters:eventValuesDic];
        }
    }
}

- (void)winRicoSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self winRicoJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.winRicoGetUserDefaultKey];
    if ([KdynastyConvertToLowercase(name) isEqualToString:KdynastyConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency: adsDatas[30]
            };
            [FBSDKAppEvents.shared logEvent:name valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
        
        [FBSDKAppEvents.shared logEvent:name parameters:paramsDic];
    }
}

- (void)winRicoSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self winRicoJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.winRicoGetUserDefaultKey];
    if ([KdynastyConvertToLowercase(name) isEqualToString:KdynastyConvertToLowercase(adsDatas[24])] || [KdynastyConvertToLowercase(name) isEqualToString:KdynastyConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency:cur
            };
            [FBSDKAppEvents.shared logEvent:name valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
        
        [FBSDKAppEvents.shared logEvent:name parameters:paramsDic];
    }
}


- (NSDictionary *)mergeDictionaries:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {
    NSMutableDictionary *mergedDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [mergedDict addEntriesFromDictionary:dict2];
    return [mergedDict copy];
}


- (NSDictionary *)sortedDictionaryByKey:(NSDictionary *)dict {
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableDictionary *sortedDict = [NSMutableDictionary dictionary];
    for (id key in sortedKeys) {
        sortedDict[key] = dict[key];
    }
    return [sortedDict copy];
}


- (NSDictionary *)filterDictionary:(NSDictionary *)dict withBlock:(BOOL (^)(id key, id value))block {
    NSMutableDictionary *filteredDict = [NSMutableDictionary dictionary];
    for (id key in dict) {
        if (block(key, dict[key])) {
            filteredDict[key] = dict[key];
        }
    }
    return [filteredDict copy];
}
@end
