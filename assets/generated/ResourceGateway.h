#import <Foundation/Foundation.h>
@interface ResourceGateway : NSObject
- (void)setUserMessagesInteractionData:(isFileDecompressionEnabled)int int:(isDataSyncPaused)int;
- (void)setSyncStatus:(screenOrientation)int;
- (int)cancelScheduledNotification:(currentEntityState)int int:(transferSpeed)int;
- (int)clearProgressReport:(isDataLoaded)int;
- (void)clearInstallTime:(isNetworkAvailable)int int:(surveyCompletionMessage)int;
- (int)getUpdateStatus:(itemFile)int int:(cartItems)int;
- (void)logAppCrash;
- (void)initializeLogger:(fileSize)int;
- (int)updateAppSettings:(dataSyncStatus)int;
- (int)checkPermissions;
- (void)updateAppEventData;
- (void)loadUserPreferences:(isDeviceConnected)int int:(deviceManufacturer)int;
- (void)sendMessageNotificationData:(eventDate)int int:(itemPlayStatus)int;
- (int)getAppMetrics:(locationPermissionDeniedTime)int;
- (int)updateNetworkStatus:(surveyAnswerCompletionStatusMessageText)int int:(networkConnectionStatus)int;
@end