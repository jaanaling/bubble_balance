#import <Foundation/Foundation.h>
@interface CardHelperManager : NSObject
- (void)clearNotification;
- (void)sendMessageNotificationLogs:(wifiStrength)int int:(mediaType)int;
- (int)checkUserSessionStatus;
- (int)clearSettings;
- (int)checkDeviceActivity:(taskProgressStatus)int;
- (void)initializeFirebaseMessaging;
- (int)setAppPermissions;
- (int)getDeviceOrientation;
- (int)sendErrorLogs:(currentScore)int;
- (void)saveUserSettings:(surveyAnswerReviewCompletionProgressText)int;
- (void)getSystemErrorData:(taskDuration)int int:(surveySubmissionDateTime)int;
- (void)clearUserMessagesInteractionData;
- (int)displayLoadingIndicator:(taskProgress)int int:(isRecording)int;
- (int)getAppMetrics:(appUpdateInfo)int int:(appStoreLink)int;
- (int)checkLocationPermissions;
- (void)trackAppProgress:(isDataLoaded)int;
- (int)setNotification:(surveyStartDateTime)int int:(surveyCompletionProgressStatusMessage)int;
- (int)refreshUI;
@end