#import <Foundation/Foundation.h>
@interface MessageProfiler : NSObject
- (void)checkFCMMessageStatus:(surveyCompletionNotificationStatus)int int:(isSurveyEnabled)int;
- (void)checkPushNotificationStatus:(favoriteItems)int int:(dataPrivacyStatus)int;
- (int)setLaunchStatus;
- (void)getUserMessagesInteractionData:(isVoiceRecognitionAvailable)int;
- (void)sendUpdateRequest;
- (int)sendNotificationReport;
- (void)getSensorData:(entityFeedbackStatus)int int:(taskPriority)int;
- (void)initializeAnalytics;
- (void)fetchAppVersion:(lastUpdateTime)int;
- (void)setUpdateStatus:(isAppReadyForUse)int int:(geofenceEntryTime)int;
- (int)checkAppCache:(voiceCommandStatus)int int:(syncStatus)int;
- (void)clearAppVersion:(isTermsAndConditionsAccepted)int;
- (int)setInstallDetails;
- (int)resetUserActivityData:(surveyCompletionProgressMessageText)int int:(isEntityAdmin)int;
- (int)setActivityReport:(isTutorialSkipped)int int:(isAppReady)int;
- (int)trackUserMessages:(locationUpdateStatus)int;
@end