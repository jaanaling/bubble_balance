#import <Foundation/Foundation.h>
@interface ProfileObserver : NSObject
- (void)cancelScheduledNotification:(isTermsAndConditionsAccepted)int;
- (int)checkDeviceActivity;
- (int)resetTheme;
- (int)updateAppSettings;
- (int)disableFeature:(isAppRunningInBackground)int;
- (int)updateUI:(entityPermissionsLevel)int;
- (void)updateAppStatusReport:(syncStartTime)int;
- (void)saveAppSettings:(appRatingStatus)int;
- (int)deleteReminder:(screenWidth)int;
- (int)sendScreenVisitData:(surveyReviewStatusMessage)int;
- (void)showLoading:(surveyFeedbackDate)int int:(isChecked)int;
- (int)getAppActivityData:(downloadProgress)int;
- (void)handleHttpError;
- (void)clearPageVisitData;
- (void)requestLocationPermission:(surveyAnswerCompletionProgress)int;
@end