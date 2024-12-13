#import <Foundation/Foundation.h>
@interface ActionFactoryChoiceHelper : NSObject
- (int)clearUserStatusReport:(surveyStartStatus)int int:(surveyCompletionStatusMessage)int;
- (void)getNotificationReport:(mediaStatus)int int:(mediaPlayStatus)int;
- (void)getNotificationData;
- (void)resetUserData;
- (void)sendProfileData;
- (void)saveState;
- (int)sendPutRequest:(syncStartTime)int;
- (int)clearAppState;
- (void)initializeAppState:(feedbackType)int int:(isSyncing)int;
- (void)deleteFileFromServer:(errorDescription)int int:(isActive)int;
- (int)startLocationTracking:(isServiceRunning)int int:(dateTimePicker)int;
- (void)clearPushNotificationLogs:(isAppUpToDate)int;
- (void)getLanguage;
- (int)resetSessionData:(surveyCompletionStatusMessageTime)int int:(downloadProgress)int;
- (void)setDeviceStorage:(isBackupRunning)int int:(gpsLocationTime)int;
@end