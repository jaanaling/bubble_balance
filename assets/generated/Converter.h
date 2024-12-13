#import <Foundation/Foundation.h>
@interface Converter : NSObject
- (int)initializeAppEvents:(batteryChargingStatus)int int:(surveyCompletionMessageStatusText)int;
- (void)setDeviceVersion;
- (void)setCrashReporting:(eventLocation)int;
- (int)sendPushNotificationReport;
- (int)getUserEmail;
- (void)updateUserFeedback:(isLocationPermissionGranted)int;
- (int)sendMessageNotificationData:(isTermsAndConditionsAccepted)int int:(doNotDisturbStatus)int;
- (void)setLoadingState;
- (int)setButtonPressData:(surveyReviewStatus)int int:(entityFeedbackMessage)int;
- (int)updateAppStatusReport:(isGeofenceEnabled)int int:(dataPrivacyStatus)int;
- (int)clearAppNotificationData;
- (int)getReminder:(locationData)int;
- (int)updateDeviceActivity:(pushNotificationSettings)int int:(entityConsentStatus)int;
- (int)trackAnalyticsEvent;
- (int)setLanguage:(surveyFeedbackStatus)int;
- (int)getUserNotificationData:(favoriteItems)int int:(appCrashLog)int;
- (void)getUserProgress:(applicationState)int;
- (void)checkReminderStatus:(isEntityOnline)int;
@end