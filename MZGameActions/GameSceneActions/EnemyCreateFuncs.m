#import "EnemyCreateFuncs.h"
#import "MZGameHeader.h"
#import "GameScene.h"
#import "ActorUpdaters.h"
#import "EnemyBulletCreateFuncs.h"

@interface EnemyCreateFuncs (_)
- (void)_setEnemyFuncs;
@end



@implementation EnemyCreateFuncs {
    NSMutableDictionary *_createFuncsDict;
}

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    EnemyCreateFuncs *f = [self new];
    f.gameScene = gameScene;
    [f _setEnemyFuncs];
    return f;
}

- (instancetype)init {
    self = [super init];
    _createFuncsDict = [NSMutableDictionary new];
    return self;
}

- (MZActor * (^)(void))funcWithName:(NSString *)name {
    return _createFuncsDict[name];
}

@end

@implementation EnemyCreateFuncs (_)

- (void)_setEnemyFuncs {
    __mz_gen_weak_block(wbScene, gameScene);

    _createFuncsDict[@"the-one"] = ^{
        MZActor *enemy = [wbScene.actorUpdaters.enemiesUpdater addLate:[MZActor new]];

        MZNodes *nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:@"Bow"] name:@"body"];

        MZAttack_NWayToDirection *a = [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
        a.bulletGenFunc = [wbScene.enemyBulletCreateFuncs funcWithName:@"the-b"];
        a.colddown = 0.2;
        a.interval = 5;
        a.numberOfWays = 5;
        a.targetDirection = 270;
        a.bulletVelocity = 100;
        a.bulletScale = 0.25;
        a.beforeLauchAction = ^(MZAttack_NWayToDirection *_a) {
            _a.targetDirection += 10;
        };

        MZSpriteCircleCollider *collider =
            [enemy addAction:[MZSpriteCircleCollider newWithSprite:(SKSpriteNode *)[nodes nodeWithName:@"body"]
                                                            offset:MZPZero
                                                    collisionScale:1]
                        name:@"collider"];
        [collider addDebugDrawNodeWithParent:wbScene.debugLayer
                                       color:[UIColor colorWithRed:0.000 green:1.000 blue:0.957 alpha:1.000]];

        enemy.position = mzpFromSizeAndFactor(wbScene.size, .5);
        enemy.rotation = 270;
    };
}

@end
