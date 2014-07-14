#import "ActorCreateFuncs.h"
#import "PlayerBulletCreateFuncs.h"
#import "EnemyCreateFuncs.h"
#import "EnemyBulletCreateFuncs.h"
#import "MZGameHeader.h"

@interface ActorCreateFuncs (_)
- (void)_initWithGameScene;
@end



@implementation ActorCreateFuncs

@synthesize gameScene;
@synthesize playerBullet, enemy, enemyBullet;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    ActorCreateFuncs *acf = [self new];
    acf.gameScene = gameScene;
    [acf _initWithGameScene];
    return acf;
}

- (void)dealloc {
    gameScene = nil;
}

@end

@implementation ActorCreateFuncs (_)

- (void)_initWithGameScene {
    MZAssertIfNilWithMessage(gameScene, @"game scene is nil");

    playerBullet = [PlayerBulletCreateFuncs newWithScene:gameScene];
    enemy = [EnemyCreateFuncs newWithScene:gameScene];
    enemyBullet = [EnemyBulletCreateFuncs newWithScene:gameScene];
}

@end
