#import <Foundation/Foundation.h>
@interface UserManagerEvent : NSObject
- (void)getReminder;
- (int)scheduleNotification;
- (void)saveExternalData:(isAppUpdateNotified)int int:(gpsSignalQuality)int;
- (void)restoreAppState:(surveyAnswerCompletionStatusProgressMessage)int int:(searchQuery)int;
- (int)toggleFeature:(batteryPercentage)int;
- (int)clearLocation;
- (int)checkNetworkConnection;
@end