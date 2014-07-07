#import "MZActionTime.h"

@implementation MZActionTime {
    MZFloat _deltaTime;
    CFTimeInterval _preTime;
}

@synthesize timeScale, deltaTime;

- (instancetype)init {
    self = [super init];

    _preTime = -1;
    timeScale = 1.0;
    _deltaTime = 1 / 30.0;

    return self;
}

- (void)dealloc {
}

- (MZFloat)deltaTime {
    return _deltaTime * self.timeScale;
}

- (void)updateWithCurrentTime:(CFTimeInterval)currentTime {
    if (_preTime < 0) {
        _preTime = currentTime;
        _deltaTime = 0.0;
    } else {
        _deltaTime = currentTime - _preTime;
        _preTime = currentTime;
    }
}

@end
