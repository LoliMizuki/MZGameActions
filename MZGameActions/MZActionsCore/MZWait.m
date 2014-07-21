#import "MZWait.h"
#import "MZGameHeader.h"

@implementation MZWait

+ (instancetype)newWithDuration:(MZFloat)duration {
    MZWait *idle = [self new];
    idle.duration = duration;
    return idle;
}

- (bool)isActive {
    return self.passedTime <= self.duration;
}

@end
