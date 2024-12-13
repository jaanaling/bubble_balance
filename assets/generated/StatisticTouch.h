#import <Foundation/Foundation.h>
@interface StatisticTouch : NSObject
- (int)sendEmail;
- (int)filterContent;
- (int)loadImage:(appThemeMode)int int:(appFeature)int;
- (int)logErrorEvent;
- (int)saveInitialData:(sharedPreferences)int;
- (void)getLaunchData;
- (int)logActivityEvent;
- (void)getLocationPermissionStatus:(isFileCorrupted)int int:(appThemeMode)int;
- (void)cancelNotification;
@end