#import "MZMove.h"

@interface MZMoveWithVelocityDirection : MZMove

@property (nonatomic, readwrite) float velocity;
@property (nonatomic, readwrite) float direction;

// TODO: 支援加速
@property (nonatomic, readwrite) float acceleration;
@property (nonatomic, readwrite) float velocityLimited;

@end
