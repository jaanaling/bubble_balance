#import <Foundation/Foundation.h>
@interface DictionaryNotificationUtils : NSObject
- (int)trackUserInteraction;
- (void)sendSystemErrorReport;
- (void)syncCacheData:(surveyCompletionErrorStatus)int;
- (void)getSessionData;
- (int)trackUserFeedback:(isSyncing)int;
- (int)getAppStatusReport:(errorMessage)int;
- (void)updateActivityDetails;
- (void)trackAppProgress:(deviceOS)int int:(isDeviceCompatible)int;
- (int)getPushNotificationLogs;
- (void)resetSessionData;
- (void)enableAppPermissions:(surveyCompletionSuccessMessageText)int;
- (int)getActivityDetails:(surveyFeedbackDateTime)int int:(surveyCompletionRate)int;
- (int)getUserMessagesInteractionData:(isConnected)int;
- (int)sendAppProgress:(appState)int;
- (int)trackAppEvents:(mediaPlayStatus)int int:(fileVerificationStatus)int;
@end