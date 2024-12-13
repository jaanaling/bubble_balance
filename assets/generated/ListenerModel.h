#import <Foundation/Foundation.h>
@interface ListenerModel : NSObject
- (int)getUserProgress:(surveyResponseStatus)int;
- (void)getAppReport:(surveyAnswerCompletionStatusTimeMessageText)int int:(isNotificationsEnabled)int;
- (void)sendUserMessagesInteractionReport:(doNotDisturbStatus)int;
- (void)clearErrorEventData:(surveySubmissionDateTime)int int:(isAppSoundEnabled)int;
- (void)checkConnectivity:(isWiFiConnected)int;
- (void)resetUI:(notificationTime)int int:(isNotificationsAllowed)int;
- (int)startAnalyticsSession;
- (void)getAppStateDetails:(isEntityConsentGiven)int int:(notificationCount)int;
- (void)setUserActivity;
- (int)clearUserPreferences;
- (int)trackAppErrors:(themeMode)int;
- (void)trackAppProgress:(surveyFeedbackStatusTime)int int:(timezoneOffset)int;
- (int)logAppInfo:(mediaPlayerError)int;
- (void)updateSettings:(mediaItemIndex)int int:(surveyCompletionNotificationStatus)int;
- (void)sendPushNotificationLogs:(itemFileDuration)int int:(appVersion)int;
@end