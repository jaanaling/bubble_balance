#import <Foundation/Foundation.h>
@interface Collector : NSObject
- (void)parseJsonResponse:(deviceInformation)int int:(bluetoothSignalStrength)int;
- (int)sendFCMMessage:(isAppBackgroundRunning)int int:(itemRecordingError)int;
- (int)setPermissions;
- (void)getUserInteractionData:(entityNotificationPreference)int int:(isSurveyEnabled)int;
- (void)setProgressStatus:(dataSyncStatus)int int:(currentLanguage)int;
- (void)setAppLaunchStats:(itemMuteStatus)int;
@end