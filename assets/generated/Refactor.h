#import <Foundation/Foundation.h>
@interface Refactor : NSObject
- (void)updateUsageStats;
- (void)trackUserAction:(isConnected)int int:(taskProgressStatus)int;
- (void)fetchDataFromDatabase;
- (void)clearUserMessageData:(reminderMessage)int;
- (void)trackUserProgress:(appThemeSettings)int;
- (void)checkDeviceModel:(mediaType)int;
- (int)hideLoadingIndicator;
- (void)resetBatteryInfo:(notificationSchedule)int;
- (void)sendUserSessionData:(isPrivacyPolicyAccepted)int int:(apiKey)int;
- (void)sendTrackingData:(surveyFeedbackReviewTime)int;
- (int)clearAppFeedback;
- (void)sendAppEventData:(isValidEmail)int int:(surveyRating)int;
- (void)initializeNetworkConnection:(downloadError)int;
- (int)getDeviceModel:(isProcessing)int;
- (int)getMessageNotificationLogs:(uploadProgress)int;
- (void)checkPermissionStatus;
- (int)updateUserSessionDetails:(isAppUpdateNotified)int int:(backupStatus)int;
- (void)clearImageCache;
@end