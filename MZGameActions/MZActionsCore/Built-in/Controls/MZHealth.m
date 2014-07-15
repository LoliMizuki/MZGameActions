#import "MZHealth.h"
#import "MZGameHeader.h"

@implementation MZHealth {
    int _healthPoint;
}

@synthesize healthPoint;
@synthesize healthZeroActoin;

- (void)setHealthPoint:(int)aHealthPoint {
    _healthPoint = aHealthPoint;
    if (healthZeroActoin != nil && _healthPoint <= 0) healthZeroActoin(self);
}

- (int)healthPoint {
    return _healthPoint;
}

@end
