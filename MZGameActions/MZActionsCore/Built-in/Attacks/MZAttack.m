#import "MZAttack.h"
#import "MZGameHeader.h"

@implementation MZAttack {
    CGPoint _bulletScaleXY;
}

@synthesize attacker, colddown;
@synthesize bulletGenFunc, bulletVelocity, bulletScaleXY, bulletScale;
@synthesize currentLanchedCount, currentBulletLanchedCount;

+ (instancetype)newWithAttacker:(id)attacker {
    MZAssertIfNilWithMessage(attacker, @"attack is nil");
    MZAttack *a = [self new];
    a.attacker = attacker;

    return a;
}

- (instancetype)init {
    self = [super init];

    colddown = 0.0;

    bulletVelocity = 0.0;
    _bulletScaleXY = MZPOne;

    return self;
}

- (void)dealloc {
    attacker = nil;
    bulletGenFunc = nil;
}

- (void)setBulletScaleXY:(CGPoint)aBulletScaleXY {
    _bulletScaleXY = aBulletScaleXY;
}

- (CGPoint)bulletScaleXY {
    return _bulletScaleXY;
}

- (void)setBulletScale:(MZFloat)aBulletScale {
    _bulletScaleXY = mzp(aBulletScale, aBulletScale);
}

- (MZFloat)bulletScale {
    MZAssert(_bulletScaleXY.x == _bulletScaleXY.y, @"x, y must be equal, but x: %.2f y: %.2f", _bulletScaleXY.x,
             _bulletScaleXY.y);
    return _bulletScaleXY.x;
}

- (MZActor *)bulletWithAppliedSetting {
    if (bulletGenFunc == nil || attacker == nil) return nil;

    MZActor *b = bulletGenFunc();
    b.scaleXY = self.bulletScaleXY;

    MZMoveWithVelocityDirection *move1 = [b addAction:[MZMoveWithVelocityDirection newWithMover:b] name:@"move1"];
    move1.velocity = self.bulletVelocity;

    b.position = attacker.position;

    return b;
}

@end
