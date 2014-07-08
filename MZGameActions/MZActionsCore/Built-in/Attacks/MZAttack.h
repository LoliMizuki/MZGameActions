#import "MZAction.h"
#import "MZGameDefines.h"

@class MZActor;

@interface MZAttack : MZAction

@property (nonatomic, readwrite, weak) id<MZTransform> attacker;
@property (nonatomic, readwrite) MZFloat colddown;
@property (nonatomic, readwrite) MZFloat bulletVelocity;
@property (nonatomic, readwrite, weak) MZActor* (^bulletGenFunc)(void);

@property (nonatomic, readonly) NSUInteger currentLanchedCount;
@property (nonatomic, readonly) NSUInteger currentBulletLanchedCount;



@end
