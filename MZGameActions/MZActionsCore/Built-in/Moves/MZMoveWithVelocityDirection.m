#import "MZMoveWithVelocityDirection.h"
#import "MZGameHeader.h"

@implementation MZMoveWithVelocityDirection

@synthesize velocity, direction, acceleration, velocityLimited;

- (instancetype)init {
    self = [super init];

    velocity = 0;
    direction = 0;
    velocityLimited = NAN;

    return self;
}

- (void)update {
    [super update];

    float currVelocity = velocity + acceleration * self.passedTime;

    if (!isnan(self.velocityLimited) && self.velocityLimited != 0) {
        if (self.acceleration > 0) currVelocity = MIN(currVelocity, self.velocityLimited);
        if (self.acceleration < 0) currVelocity = MAX(currVelocity, self.velocityLimited);
    }

    float deltaMovement = currVelocity * self.deltaTime;
    CGPoint uv = [MZMath unitVectorFromDegrees:direction];

    CGPoint deltaMovementXY = mzpMul(uv, deltaMovement);
    [self.mover setPosition:mzpAdd([self.mover position], deltaMovementXY)];
}

@end
