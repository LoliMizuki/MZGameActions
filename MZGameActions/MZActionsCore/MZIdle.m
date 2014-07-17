#import "MZIdle.h"
#import "MZGameHeader.h"

@implementation MZIdle

+ (instancetype)newWithDuration:(MZFloat)duration {
    MZIdle *idle = [self new];
    idle.duration = duration;
    return idle;
}

- (bool)isActive {
    return self.passedTime <= self.duration;
}

@end
