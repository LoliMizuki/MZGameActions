#import "MZActionRepeat.h"
#import "MZGameHeader.h"

@implementation MZActionRepeat {
    MZAction *_action;
    NSUInteger _times;
    NSUInteger _timesCount;
    bool _isForever;
}

+ (instancetype)newWithAction:(MZAction *)action times:(NSUInteger)times {
    MZActionRepeat *repeat = [self new];
    repeat->_action = action;
    repeat->_times = times;
    repeat->_isForever = false;
    return repeat;
}

+ (instancetype)newWithForeverAction:(MZAction *)action {
    MZActionRepeat *repeat = [self new];
    repeat->_action = action;
    repeat->_isForever = true;
    return repeat;
}

- (bool)isActive {
    return (_isForever) ? true : _timesCount > 0;
}

- (void)start {
    [super start];
    _timesCount = _times;
    [_action start];
}

- (void)update {
    [super update];

    if (!_action.isActive && _timesCount > 0) {
        _timesCount--;
        if (_isForever) _timesCount = 999;
        if (_timesCount > 0) [_action start];
    }

    if (_timesCount == 0) return;

    [_action update];

    if (!_action.isActive) [_action end];
}

@end
