#import "MZActionsGroup.h"
#import "MZGameHeader.h"

@interface MZActionsGroup (_)
- (void)_addUpdatingActionsFromBuffer;
- (void)_updateActions;
@end

@implementation MZActionsGroup {
    MZActionTime *_actionTime;
    NSMutableArray *_newActionsBuffer;
    NSMutableArray *_updatingAciotns;
}

- (instancetype)init {
    self = [super init];

    _newActionsBuffer = [NSMutableArray new];
    _updatingAciotns = [NSMutableArray new];

    return self;
}

- (void)dealloc {
    [self clear];
    _newActionsBuffer = nil;
    _updatingAciotns = nil;
}

- (void)setActionTime:(MZActionTime *)anActionTime {
    _actionTime = anActionTime;

    [MZMapReduces mapWithArray:_newActionsBuffer
                        action:^(MZAction *a) { a.actionTime = _actionTime; }];

    [MZMapReduces mapWithArray:_updatingAciotns
                        action:^(MZAction *a) { a.actionTime = _actionTime; }];
}

- (MZActionTime *)actionTime {
    return _actionTime;
}

- (NSMutableArray *)updatingAciotns {
    return _updatingAciotns;
}

- (id)addImmediate:(MZAction *)newAction {
    MZAssertIfNilWithMessage(self.actionTime, @"must set actionTime first");

    [_updatingAciotns addObject:newAction];
    newAction.actionTime = self.actionTime;
    [newAction start];
    return newAction;
}

- (void)update {
    [super update];

    [self _addUpdatingActionsFromBuffer];
    [self _updateActions];
}

- (void)removeInactives {
    for (int i = 0; i < _updatingAciotns.count; i++) {
        MZAction *a = _updatingAciotns[i];
        if (a.isActive) continue;

        [a end];
        [_updatingAciotns removeObjectAtIndex:i];
        i--;
    }
}

- (void)clear {
    [_newActionsBuffer removeAllObjects];
    [_updatingAciotns removeAllObjects];
}

@end

@implementation MZActionsGroup (_)

- (void)_addUpdatingActionsFromBuffer {
    MZAssertIfNilWithMessage(self.actionTime, @"must set actionTime first");

    if (_newActionsBuffer.count == 0) return;

    for (MZAction *a in _newActionsBuffer) {
        [_updatingAciotns addObject:a];
        [a start];
    }

    [_newActionsBuffer removeAllObjects];
}

- (void)_updateActions {
    for (MZAction *a in _updatingAciotns) {
        [a update];
    }
}

@end
