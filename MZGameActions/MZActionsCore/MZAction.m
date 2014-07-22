#import "MZAction.h"
#import "MZGameHeader.h"

@interface MZAction (_)
- (void)_updatePassedTime;
@end

@implementation MZAction {
    MZFloat _passedTime;
    MZFloat _duration;
}

@synthesize name;
@synthesize isActive, isActiveFunc, duration, actionTime, deallocAction;

- (instancetype)init {
    self = [super init];

    _duration = -1;
    actionTime = [MZActionTime new];

    return self;
}

- (void)dealloc {
    if (self.deallocAction != nil) {
        self.deallocAction(self);
    }

    self.actionTime = nil;
}

- (bool)isActive {
    return (isActiveFunc != nil) ? isActiveFunc() : true;
}

- (void)setTimeScale:(MZFloat)aTimeScale {
    self.actionTime.timeScale = aTimeScale;
}

- (MZFloat)duration {
    return _duration;
}

- (void)setDuration:(MZFloat)aDuration {
    _duration = aDuration;

    if (_duration > 0) {
        __mz_gen_weak_block(weakSelf, self);
        isActiveFunc = ^{ return (bool)(weakSelf.passedTime < weakSelf.duration); };
    } else {
        isActiveFunc = nil;
    }
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
