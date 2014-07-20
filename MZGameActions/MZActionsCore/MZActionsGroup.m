#import "MZActionsGroup.h"
#import "MZGameHeader.h"

@interface MZActionsGroup (_)
- (void)_moveActionsFromBufferToUpdating;
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
    [self removeAllActions];
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

- (NSArray *)updatingAciotns {
    return _updatingAciotns;
}

- (id)addAction:(MZAction *)newAction {
    MZAssertIfNilWithMessage(self.actionTime, @"must set actionTime first");

    [_updatingAciotns addObject:newAction];
    newAction.actionTime = self.actionTime;
    [newAction start];
    return newAction;
}

- (id)addActionLate:(MZAction *)newAction {
    MZAssertIfNilWithMessage(self.actionTime, @"must set actionTime first");

    [_newActionsBuffer addObject:newAction];
    newAction.actionTime = self.actionTime;

    return newAction;
}

- (id)removeAction:(MZAction *)action {
    if ([_newActionsBuffer containsObject:action]) [_newActionsBuffer removeObject:action];
    if ([_updatingAciotns containsObject:action]) [_updatingAciotns removeObject:action];

    return action;
}

- (void)update {
    [super update];

    [self _moveActionsFromBufferToUpdating];
    [self _updateActions];
}

- (void)removeInactiveActions {
    for (int i = 0; i < _updatingAciotns.count; i++) {
        MZAction *a = _updatingAciotns[i];
        if (a.isActive) continue;

        [a end];
        [_updatingAciotns removeObjectAtIndex:i];
        i--;
    }
}

- (void)removeAllActions {
    [_newActionsBuffer removeAllObjects];
    [_updatingAciotns removeAllObjects];
}

@end

@implementation MZActionsGroup (_)

- (void)_moveActionsFromBufferToUpdating {
    if (_newActionsBuffer.count == 0) return;

    for (MZAction *a in _newActionsBuffer) {
        [_updatingAciotns addObject:a];
        [a start];
    }

    [_newActionsBuffer removeAllObjects];
}

- (void)_updateActions {
    for (MZAction *a in _updatingAciotns) {
        if (a.isActive) [a update];
    }
}

@end
