#import "MZActor.h"
#import "MZGameHeader.h"

@interface MZActor (_)
- (void)_updatePosition;
- (void)_updateScale;
- (void)_updateRotation;
@end

@implementation MZActor {
    MZActionsGroup *_group;

    CGPoint _position;
    CGPoint _scaleXY;
    MZFloat _rotation;
}

@synthesize position, scaleXY, scale, rotation;

- (instancetype)init {
    self = [super init];

    _group = [MZActionsGroup new];
    _position = MZPZero;
    _scaleXY = MZPOne;
    _rotation = 0;

    return self;
}

- (void)dealloc {
    [_group clear];
    _group = nil;
}

- (void)setActionTime:(MZActionTime *)anActionTime {
    _group.actionTime = anActionTime;
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

- (MZActionTime *)actionTime {
    return _group.actionTime;
}

- (id)addAction:(MZAction *)action name:(NSString *)name {
    action.name = name;
    [_group addImmediate:action];

    return action;
}

- (id)addActionWithClass:(Class)actionClass name:(NSString *)name {
    MZAction *action = [actionClass new];
    [self addAction:action name:name];

    return action;
}

- (void)update {
    [super update];
    [_group update];
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
