#import "MZMoveTurnFromTo.h"
#import "MZGameHeader.h"

@interface MZMoveTurnFromTo (_)
- (void)_updateBefore;
@end



@implementation MZMoveTurnFromTo {
    MZMoveWithVelocityDirection *_moveWithVelocityDirection;
}

@synthesize fromDirection, toDirection, turnDegreesPerSecond, permissibleDegreesRange, velocity, acceleration,
    velocityLimited;

- (instancetype)init {
    self = [super init];

    _moveWithVelocityDirection = [MZMoveWithVelocityDirection new];
    self.permissibleDegreesRange = 3;

    return self;
}

- (void)dealloc {
}

- (void)setActionTime:(MZActionTime *)anActionTime {
    _moveWithVelocityDirection.actionTime = anActionTime;
}

- (MZActionTime *)actionTime {
    return _moveWithVelocityDirection.actionTime;
}

- (void)setMover:(id<MZTransform>)aMover {
    _moveWithVelocityDirection.mover = aMover;
}

- (id<MZTransform>)mover {
    return _moveWithVelocityDirection.mover;
}

- (void)setVelocity:(MZFloat)aVelocity {
    _moveWithVelocityDirection.velocity = aVelocity;
}

- (MZFloat)velocity {
    return _moveWithVelocityDirection.velocity;
}

- (void)setFromDirection:(MZFloat)aDirection {
    _moveWithVelocityDirection.direction = aDirection;
}

- (MZFloat)fromDirection {
    return _moveWithVelocityDirection.direction;
}

- (MZFloat)currentDirection {
    return _moveWithVelocityDirection.currentDirection;
}

- (void)setAcceleration:(MZFloat)anAcceleration {
    _moveWithVelocityDirection.acceleration = anAcceleration;
}

- (MZFloat)acceleration {
    return _moveWithVelocityDirection.acceleration;
}

- (void)setVelocityLimited:(MZFloat)aVelocityLimited {
    _moveWithVelocityDirection.velocityLimited = aVelocityLimited;
}

- (MZFloat)velocityLimited {
    return _moveWithVelocityDirection.velocityLimited;
}

#pragma mark - methods

+ (MZFloat)degreesOutOfBoundFixWithDegree:(MZFloat)degrees
                           limitedDegrees:(MZFloat)limitedDegrees
                             increaseSign:(int)increaseSign {
    if (increaseSign > 0) {
        MZFloat modifyLimitedDeg = (degrees > limitedDegrees) ? limitedDegrees + 360 : limitedDegrees;
        if (degrees > modifyLimitedDeg) {
            return limitedDegrees;
        }
    } else if (increaseSign < 0) {
        MZFloat modifyLimitedDeg = (degrees < limitedDegrees) ? limitedDegrees - 360 : limitedDegrees;
        if (degrees < modifyLimitedDeg) {
            return limitedDegrees;
        }
    }

    return degrees;
}

- (void)start {
    [super start];
    [_moveWithVelocityDirection start];
}

- (void)update {
    [super update];
    [self _updateBefore];
    [_moveWithVelocityDirection update];
}

@end

@implementation MZMoveTurnFromTo (_)

- (void)_updateBefore {
    MZAssert(self.turnDegreesPerSecond >= 0, @"turnDegreesPerSecond must more than zero, but is %0.2f",
             self.turnDegreesPerSecond);

    MZFloat currDeg = [MZMath formatDegrees:self.currentDirection];
    MZFloat toDeg = [MZMath formatDegrees:self.toDirection];

    if (fabsf(currDeg - toDeg) <= self.permissibleDegreesRange) {
        _moveWithVelocityDirection.direction = [MZMath formatDegrees:toDeg];

        // TODO: face to dir test ... dn't forget remove me
        id<MZTransform> asTransform = (id<MZTransform>)self.mover;
        [asTransform setRotation:toDeg];

        return;
    }

    MZFloat shortestDistance = [MZMath shortestDistanceFromDegrees:currDeg toDegrees:toDeg];

    int increaseSign = (shortestDistance >= 0) ? 1 : -1;
    MZFloat deltaDeg = increaseSign * (self.turnDegreesPerSecond * self.deltaTime);
    MZFloat nextDeg = [MZMath formatDegrees:currDeg + deltaDeg];

    nextDeg = [MZMoveTurnFromTo degreesOutOfBoundFixWithDegree:nextDeg limitedDegrees:toDeg increaseSign:increaseSign];

    _moveWithVelocityDirection.direction = [MZMath formatDegrees:nextDeg];

    // TODO: face to dir test ... dn't forget remove me
    id<MZTransform> asTransform = (id<MZTransform>)self.mover;
    asTransform.rotation = self.currentDirection;
}


@end