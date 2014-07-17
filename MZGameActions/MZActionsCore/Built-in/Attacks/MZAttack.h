#import "MZAction.h"
#import "MZGameDefines.h"

@class MZActor;

@interface MZAttack : MZAction

@property (nonatomic, readwrite, weak) id<MZTransform> attacker;
@property (nonatomic, readwrite) MZFloat colddown;
@property (nonatomic, readwrite) MZFloat bulletVelocity;
@property (nonatomic, readwrite) CGPoint bulletScaleXY;
@property (nonatomic, readwrite) MZFloat bulletScale;
@property (nonatomic, readwrite, strong) MZActor* (^bulletGenFunc)(void);
@property (nonatomic, readwrite) NSUInteger launchCount;

@property (nonatomic, readonly) NSUInteger currentLanchedCount;
@property (nonatomic, readonly) NSUInteger currentBulletLanchedCount;

+ (instancetype)newWithAttacker:(id)attacker;

- (MZActor*)bulletWithAppliedSetting;

@end
