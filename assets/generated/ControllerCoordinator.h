#import <Foundation/Foundation.h>
@interface ControllerCoordinator : NSObject
- (int)updateNetworkStatus:(menuItems)int;
- (int)updateActivityReport:(taskStartTimestamp)int;
- (int)sendPostRequest;
- (void)logAppError;
- (void)resetUserFeedback:(geofenceEntryTime)int int:(isAdminAuthenticated)int;
- (void)trackActivityEvent:(surveyCompletionStatusMessage)int;
- (void)updateLaunchTime:(reminderFrequency)int;
- (int)setSyncStatus:(isDeviceErrorDetected)int int:(isBluetoothEnabled)int;
- (void)sendAppFeedback;
- (void)syncData;
- (int)setSensorData;
- (void)clearUsageStats:(isEntityVoiceCommandAllowed)int int:(responseTime)int;
- (void)getPushNotificationData:(entityErrorLogs)int int:(taskEndDate)int;
- (int)initializeAnalytics;
- (void)getAppStateDetails;
- (void)subscribeToPushNotifications:(errorDetailsMessage)int int:(surveyCompletionErrorMessageStatus)int;
- (int)setLocationPermissions;
- (void)getSystemLanguage:(surveyCompletionErrorMessageText)int int:(taskStatus)int;
@end