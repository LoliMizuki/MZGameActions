#import "MZAttack_NWayToDirection.h"
#import "MZGameHeader.h"

@interface MZAttack_NWayToDirection (_)
- (bool)_checkColddown;
- (void)_launchs;
@end



@implementation MZAttack_NWayToDirection {
    MZFloat _colddownCount;
}

@synthesize numberOfWays, targetDirection, interval;
@synthesize beforeLauchAction;

- (instancetype)init {
    self = [super init];
    _colddownCount = 0.0;
    return self;
}

- (void)update {
    [super update];

    if (![self _checkColddown]) return;
    [self _launchs];
}

@end

@implementation MZAttack_NWayToDirection (_)

- (bool)_checkColddown {
    _colddownCount -= self.deltaTime;
    if (_colddownCount > 0) return false;

    _colddownCount += self.colddown;
    return true;
}

- (void)_launchs {
    if (self.bulletGenFunc == nil) return;

    if (beforeLauchAction != nil) beforeLauchAction(self);

    for (int i = 0; i < numberOfWays; i++) {
        float offsetDegrees = (i + 1) / 2 * interval * ((i % 2 == 0) ? 1 : -1);

        MZActor *bullet = [self bulletWithAppliedSetting];
        if (bullet == nil) continue;

        MZMoveWithVelocityDirection *move = [bullet actionWithName:@"move1"];
        move.direction = targetDirection + offsetDegrees;

        bullet.rotation = move.direction;

        //        if (attack.bulletOnLanuchedAction != nil) {
        //            attack.bulletOnLanuchedAction(attack, bullet);
        //        }
    }
}

@end
