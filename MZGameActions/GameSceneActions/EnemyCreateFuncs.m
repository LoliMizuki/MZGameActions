#import "EnemyCreateFuncs.h"
#import "GameSceneActionsHeader.h"

@interface EnemyCreateFuncs (_)
- (MZBoundTest *)_addCommonBoundTestToActor:(MZActor *)actor;
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
    MZAssertIfNilWithMessage(_createFuncsDict[name], @"can not found func with name: %@", name);
    return _createFuncsDict[name];
}

@end

@implementation EnemyCreateFuncs (_)

- (MZBoundTest *)_addCommonBoundTestToActor:(MZActor *)actor {
    __mz_gen_weak_block(wbScene, gameScene);
    __mz_weak_block_type(MZActor *)wbActor = actor;
    MZBoundTest *bt = [actor addAction:[MZBoundTest newWithTester:actor bound:wbScene.gameBound] name:@"bound"];
    bt.outOfBoundAction = ^(id b) {
        wbActor.isActive = false;
    };

    return bt;
}

- (void)_setEnemyFuncs {
    __mz_gen_weak_block(wbScene, gameScene);
    __mz_gen_weak_block(wbSelf, self);

    _createFuncsDict[@"the-one"] = ^{
        __mz_weak_block MZActor *enemy = [wbScene.actorUpdaters.enemiesUpdater addLate:[MZActor new]];

        [wbSelf _addCommonBoundTestToActor:enemy];

        __mz_weak_block MZHealth *health = [enemy addAction:[MZHealth new] name:@"health"];
        health.healthPoint = 100;

        MZNodes *nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:@"Bow"] name:@"body"];

        MZAttack_NWayToDirection *attack =
            [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
        attack.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        attack.colddown = 1.0;
        attack.interval = 5;
        attack.numberOfWays = 5;
        attack.targetDirection = 270;
        attack.bulletVelocity = 300;
        attack.bulletScale = 0.25;

        MZSpriteCircleCollider *collider =
            [enemy addAction:[MZSpriteCircleCollider newWithSprite:(SKSpriteNode *)[nodes nodeWithName:@"body"]
                                                            offset:MZPZero
                                                    collisionScale:1]
                        name:@"collider"];
        [collider addDebugDrawNodeWithParent:wbScene.debugLayer
                                       color:[UIColor colorWithRed:0.000 green:1.000 blue:0.957 alpha:1.000]];
        collider.collidedAction = ^(id c) {
            health.healthPoint -= 1;
            if (health.healthPoint <= 0) {
                enemy.isActive = false;
            }
        };

        MZMoveTurnToDirection *move = [enemy addAction:[MZMoveTurnToDirection newWithMover:enemy] name:@"move"];
        move.direction = 180;
        move.turnDegreesPerSecond = 50;
        move.turnToDirection = 270;
        move.velocity = 100;

        __mz_gen_weak_block(wbMove, move);
        attack.beforeLauchAction = ^(MZAttack_NWayToDirection *_a) {
            _a.targetDirection = wbMove.direction;
        };

        enemy.scale = 0.3;
        //        enemy.rotation = 270;

        return enemy;
    };
}

@end
