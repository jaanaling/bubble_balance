#import <Foundation/Foundation.h>
@interface ProviderWidget : NSObject
- (void)setAppFeedback;
- (int)sendAppStatusReport;
- (void)updateLocationDetails;
- (int)clearUsageStats:(syncErrorMessage)int int:(deviceScreenBrightness)int;
- (int)setSystemErrorData:(syncData)int;
- (int)updateDeviceOrientation:(itemRecordingError)int int:(networkSpeed)int;
- (int)getUsageStats:(entityNotificationTime)int;
- (int)updateExternalData:(uiElements)int;
- (int)getPushNotificationData:(surveyCompletionTimeText)int int:(imageList)int;
- (void)getUserEmail:(itemMuteStatus)int int:(surveyAnswerReviewStatusCompletionTimeText)int;
- (void)resetSessionData:(surveyAnswerDuration)int int:(deviceConnectivityStatus)int;
- (int)logScreenVisit:(eventTime)int;
- (void)restoreData:(itemFileDuration)int int:(taskDuration)int;
- (void)checkDeviceFeatures;
- (int)setReminderStatus:(entityPermissionsLevel)int;
- (int)sendUserStatusReport:(isTaskInProgress)int int:(syncError)int;
@end