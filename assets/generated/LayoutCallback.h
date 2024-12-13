#import <Foundation/Foundation.h>
@interface LayoutCallback : NSObject
- (int)requestPermission:(isWiFiConnected)int int:(systemUiMode)int;
- (int)grantPermission:(surveyErrorMessageDetails)int int:(appDataPrivacy)int;
- (int)sendActivityData;
- (int)sendNotification;
- (void)checkForUpdates;
- (int)updateAppEventData:(isAppForegroundRunning)int;
- (int)sendAnalytics:(isEntityLocationEnabled)int int:(itemRecordingFilePath)int;
- (int)clearPushNotification:(downloadProgress)int int:(surveyStartDateTime)int;
@end