#import "GetuiPlugin.h"
#import <GTSDK/GeTuiSdk.h>
#import <PushKit/PushKit.h>
#import <UserNotifications/UserNotifications.h>

@interface GetuiPlugin()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@end
@implementation GetuiPlugin 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"getui"
                                     binaryMessenger:[registrar messenger]];
    GetuiPlugin* instance = [[GetuiPlugin alloc] init];
    instance.channel = channel;
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = call.method;
    if ([method isEqualToString:@"register"]) {
        NSArray* arguments = (NSArray *)call.arguments;
        [GeTuiSdk startSdkWithAppId:arguments[0] appKey:arguments[1] appSecret:arguments[2] delegate:self];
        [self registerRemoteNotification];
        result(@"");
    } else if ([method isEqualToString:@"clientID"]) {
        result(GeTuiSdk.clientId);
    } else if ([method isEqualToString:@"setBadge"]) {
        NSInteger value = (NSInteger)call.arguments;
        [self setBadge:value];
    } else if ([method isEqualToString:@"setTags"]) {
        [self setTags:(NSArray *)call.arguments];
    } else if ([method isEqualToString:@"bindAlias"]){
        [GeTuiSdk bindAlias:call.arguments[0] andSequenceNum:call.arguments[1]];
    } else if ([method isEqualToString:@"unBindAlias"]){
        [GeTuiSdk unbindAlias:call.arguments[0] andSequenceNum:call.arguments[1] andIsSelf:call.arguments[2]];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)setBadge:(NSInteger)value{
    [GeTuiSdk setBadge:value];
    UIApplication.sharedApplication.applicationIconBadgeNumber = value;
}
- (void)setTags:(NSArray *)value{
    [GeTuiSdk setTags:value];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSdk ]：个推SDK已注册，返回clientId
    NSLog(@">>[GTSdk RegisterClient]:%@", clientId);
    if ([clientId isEqualToString:@""]) {
        return;
    }
    
    [_channel invokeMethod:@"onReceiveClientId" arguments:clientId];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    NSLog(@"\n>>>[DeviceToken(NSData)]: %@\n\n", deviceToken);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_channel invokeMethod:@"onRegisterDeviceToken" arguments:token];
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSDictionary *received = @{
                               @"appId": appId,
                               @"taskId": taskId,
                               @"messageId": msgId,
                               @"offLine": [NSNumber numberWithBool:offLine] ,
                               @"payload": payloadMsg
                               };
    
    [_channel invokeMethod:@"onReceiveMessageData" arguments:received];
    NSLog(@"%@",payloadMsg);
}
@end
