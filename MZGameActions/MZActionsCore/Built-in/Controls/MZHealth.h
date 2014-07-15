#import "MZAction.h"

@interface MZHealth : MZAction

@property (nonatomic, readwrite) int healthPoint;
@property (nonatomic, readwrite, strong) void (^healthZeroActoin)(MZHealth *health);

@end
