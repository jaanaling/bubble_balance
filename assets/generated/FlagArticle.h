#import <Foundation/Foundation.h>
@interface FlagArticle : NSObject
- (void)sendUpdateRequest:(isRecordingEnabled)int;
- (int)clearAppEventData;
- (void)updateActivity;
- (void)clearAppActivityData;
- (void)setButtonPressData;
@end