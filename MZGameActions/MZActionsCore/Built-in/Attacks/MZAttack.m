#import "MZAttack.h"
#import "MZGameHeader.h"

@implementation MZAttack

@synthesize attacker, colddown, bulletVelocity, currentLanchedCount, currentBulletLanchedCount;

+ (instancetype)newWithAttacker:(id)attacker {
    MZAssertIfNilWithMessage(attacker, @"attack is nil");
    MZAttack *a = [self new];
    a.attacker = attacker;

    return a;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    attacker = nil;
}

@end
