#import "MZMoveTurnToDirection.h"
#import "MZGameHeader.h"

@interface MZMoveTurnToDirection (_)
- (void)_updateBefore;
@end



@implementation MZMoveTurnToDirection {
    MZMoveWithVelocityDirection *_moveWithVelocityDirection;
}

@synthesize turnToDirection, turnDegreesPerSecond, permissibleDegreesRange, velocity, direction, acceleration,
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

- (void)setDirection:(MZFloat)aDirection {
    _moveWithVelocityDirection.direction = aDirection;
}

- (MZFloat)direction {
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

@implementation MZMoveTurnToDirection (_)

- (void)_updateBefore {
    MZAssert(self.turnDegreesPerSecond >= 0, @"turnDegreesPerSecond must more than zero, but is %0.2f",
             self.turnDegreesPerSecond);

    MZFloat currDeg = [MZMath formatDegrees:self.currentDirection];
    MZFloat turnDeg = [MZMath formatDegrees:self.turnToDirection];

    if (fabsf(currDeg - turnDeg) <= self.permissibleDegreesRange) {
        _moveWithVelocityDirection.direction = [MZMath formatDegrees:turnDeg];

        // TODO: face to dir test ... dn't forget remove me
        id<MZTransform> asTransform = (id<MZTransform>)self.mover;
        [asTransform setRotation:turnDeg];

        return;
    }

    MZFloat shortestDistance = [MZMath shortestDistanceFromDegrees:currDeg toDegrees:turnDeg];

    int increaseSign = (shortestDistance >= 0) ? 1 : -1;
    MZFloat deltaDeg = increaseSign * (self.turnDegreesPerSecond * self.deltaTime);
    MZFloat nextDeg = [MZMath formatDegrees:currDeg + deltaDeg];

    nextDeg =
        [MZMoveTurnToDirection degreesOutOfBoundFixWithDegree:nextDeg limitedDegrees:turnDeg increaseSign:increaseSign];

    _moveWithVelocityDirection.direction = [MZMath formatDegrees:nextDeg];

    // TODO: face to dir test ... dn't forget remove me
    id<MZTransform> asTransform = (id<MZTransform>)self.mover;
    asTransform.rotation = self.currentDirection;
}


@end