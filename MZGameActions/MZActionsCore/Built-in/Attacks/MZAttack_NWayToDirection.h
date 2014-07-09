#import "MZAttack.h"
#import "MZGameDefines.h"

@interface MZAttack_NWayToDirection : MZAttack

@property (nonatomic, readwrite) int numberOfWays;
@property (nonatomic, readwrite) MZFloat targetDirection;
@property (nonatomic, readwrite) MZFloat interval;

@end
