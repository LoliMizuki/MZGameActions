#import "MZRepeat.h"
#import "MZGameHeader.h"

@implementation MZRepeat {
    MZAction *_action;
    NSUInteger _times;
    NSUInteger _timesCount;
}

+ (instancetype)newWithAction:(MZAction *)action times:(NSUInteger)times {
    MZRepeat *repeat = [self new];
    repeat->_action = action;
    repeat->_times = times;
    return repeat;
}

- (void)start {
    [super start];
    _timesCount = _times;
    [_action start];
}

- (void)update {
    [super update];

    if (!_action.isActive) [_action start];
    [_action update];
    if (!_action.isActive) [_action end];
}

@end
