#import "MZAction.h"
#import "MZGameHeader.h"

@interface MZAction (_)
- (void)_updatePassedTime;
@end

@implementation MZAction {
    MZFloat _passedTime;
}

@synthesize name, isActive, actionTime;

- (instancetype)init {
    self = [super init];

    self.actionTime = [MZActionTime new];

    return self;
}

- (void)dealloc {
    self.actionTime = nil;
}

- (bool)isActive {
    return (_isActiveFunc != nil) ? _isActiveFunc() : true;
}

- (void)setTimeScale:(double)aTimeScale {
    self.actionTime.timeScale = aTimeScale;
}

- (MZFloat)timeScale {
    return (self.actionTime != nil) ? self.actionTime.timeScale : 0.0;
}

- (MZFloat)deltaTime {
    return (self.actionTime != nil) ? self.actionTime.deltaTime : 0.0;
}

- (MZFloat)passedTime {
    return _passedTime;
}

- (void)start {
    _passedTime = -1.0;
    mz_block_exec(self.startAction, self);
}

- (void)update {
    [self _updatePassedTime];
    mz_block_exec(self.updateAction, self);
}

- (void)end {
    mz_block_exec(self.endAction, self);
}

@end

@implementation MZAction (_)

- (void)_updatePassedTime {
    _passedTime = (_passedTime >= 0.0) ? _passedTime + self.deltaTime : 0.0;
}

@end
