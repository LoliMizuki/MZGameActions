#import "MZActor.h"
#import "MZGameHeader.h"

@interface MZActor (_)
- (void)_updatePosition;
- (void)_updateScale;
- (void)_updateRotation;
@end

@implementation MZActor {
    NSMutableArray *_activeConditions;

    MZActionsGroup *_group;
    NSMutableArray *_willBeRemovedActions;

    CGPoint _position;
    CGPoint _scaleXY;
    MZFloat _rotation;

    NSUInteger _anonymousNameCount;
}

@synthesize position, scaleXY, scale, rotation;

- (instancetype)init {
    self = [super init];

    _activeConditions = [NSMutableArray new];

    _group = [MZActionsGroup new];
    _willBeRemovedActions = [NSMutableArray new];
    _position = MZPZero;
    _scaleXY = MZPOne;
    _rotation = 0;
    _anonymousNameCount = 0;

    return self;
}

- (void)dealloc {
    [_activeConditions removeAllObjects];

    [_willBeRemovedActions removeAllObjects];

    [_group removeAllActions];
    _group = nil;
}

- (bool)isActive {
    for (bool (^cond)(void)in _activeConditions) {
        if (!cond()) return false;
    }

    return true;
}

- (void)setIsActiveFunc:(bool (^)(void))isActiveFunc {
    MZAssertFalse(@"use addActiveCondition: to do this");
}

- (bool (^)(void))isActiveFunc {
    MZAssertFalse(@"use addActiveCondition: to do this");
    return nil;
}

- (void)addActiveCondition:(bool (^)(void))activeCondition {
    [_activeConditions addObject:activeCondition];
}

- (void)setActionTime:(MZActionTime *)anActionTime {
    _group.actionTime = anActionTime;
}

- (MZActionTime *)actionTime {
    return _group.actionTime;
}

- (void)setPosition:(CGPoint)p {
    _position = p;
    [self _updatePosition];
}

- (CGPoint)position {
    return _position;
}

- (void)setScaleXY:(CGPoint)s {
    _scaleXY = s;
    [self _updateScale];
}

- (CGPoint)scaleXY {
    return _scaleXY;
}

- (void)setScale:(MZFloat)s {
    self.scaleXY = mzp(s, s);
}

- (MZFloat)scale {
    MZAssert(self.scaleXY.x == self.scaleXY.y, @"x(%0.2f), y(%0.2f) is not equal", self.scaleXY.x, self.scaleXY.y);
    return self.scaleXY.x;
}

- (void)setRotation:(MZFloat)r {
    _rotation = r;
    [self _updateRotation];
    [self _updatePosition];
}

- (MZFloat)rotation {
    return _rotation;
}

- (NSArray *)actions {
    return _group.updatingAciotns;
}

- (id)addAction:(MZAction *)action name:(NSString *)name {
    MZAssertIfNilWithMessage(self.actionTime, @"must set actionTime first");

    action.name = name;
    [_group addAction:action];

    return action;
}

- (id)addActionWithClass:(Class)actionClass name:(NSString *)name {
    MZAction *action = [actionClass new];
    [self addAction:action name:name];

    return action;
}

- (id)addAction:(MZAction *)action {
    NSString *anonymousName = [NSString stringWithFormat:@"%lu", (unsigned long)_anonymousNameCount];
    [self addAction:action name:anonymousName];
    _anonymousNameCount++;

    return action;
}

- (id)actionWithName:(NSString *)name {
    for (MZAction *a in _group.updatingAciotns) {
        if (![a.name isEqualToString:name]) continue;
        return a;
    }

    return nil;
}

- (NSArray *)actionsWithClass:(Class)actionClass {
    NSMutableArray *actions = [NSMutableArray new];
    for (MZAction *a in _group.updatingAciotns) {
        if ([a class] == actionClass) [actions addObject:a];
    }

    return actions;
}

- (id)removeAction:(MZAction *)action {
    [_willBeRemovedActions addObject:action];
    return action;
}

- (id)removeActionWithName:(NSString *)name {
    MZAction *a = [self actionWithName:name];
    [self removeAction:a];
    return a;
}

- (NSArray *)removeAllActionsWithClass:(Class)actionClass {
    NSArray *actions = [self actionsWithClass:actionClass];
    for (MZAction *a in actions) {
        [self removeAction:a];
    }

    return actions;
}

- (void)refresh {
    [self _updatePosition];
    [self _updateScale];
    [self _updateRotation];
}

- (void)update {
    [super update];
    [_group update];
}

- (void)removeInactiveActions {
    [_group removeInactiveActions];

    if (_willBeRemovedActions.count > 0) {
        for (MZAction *rm in _willBeRemovedActions) {
            [_group removeAction:rm];
        }
    }

    [_willBeRemovedActions removeAllObjects];
}

- (void)removeAllActions {
    [_group removeAllActions];
}

@end

@implementation MZActor (_)

- (void)_updatePosition {
    for (MZAction *child in _group.updatingAciotns) {
        if (![child conformsToProtocol:@protocol(MZTransform)]) {
            continue;
        }

        id<MZTransform> asTrans = (id<MZTransform>)child;
        asTrans.position = mzp(_position.x, _position.y);
    }
}

- (void)_updateScale {
    for (MZAction *child in _group.updatingAciotns) {
        if (![child conformsToProtocol:@protocol(MZTransform)]) {
            continue;
        }

        id<MZTransform> asTrans = (id<MZTransform>)child;
        asTrans.scaleXY = _scaleXY;
    }
}

- (void)_updateRotation {
    for (MZAction *child in _group.updatingAciotns) {
        if (![child conformsToProtocol:@protocol(MZTransform)]) {
            continue;
        }

        id<MZTransform> asTrans = (id<MZTransform>)child;
        asTrans.rotation = _rotation;
    }
}

@end
