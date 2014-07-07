#import <Foundation/Foundation.h>
#import "MZGameDefines.h"

@interface MZActionTime : NSObject

@property (nonatomic, readwrite) MZFloat timeScale;

@property (nonatomic, readonly) MZFloat deltaTime;

- (void)updateWithCurrentTime:(CFTimeInterval)currentTime;

@end
