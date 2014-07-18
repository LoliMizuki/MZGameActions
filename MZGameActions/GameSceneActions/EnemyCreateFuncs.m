#import "EnemyCreateFuncs.h"
#import "GameSceneActionsHeader.h"

@interface EnemyCreateFuncs (_)
- (MZBoundTest *)_addCommonBoundTestToActor:(MZActor *)actor;
- (void)_setEnemyFuncs;

- (MZActor * (^)(void))_theSimple;
- (MZActor * (^)(void))_theOne;
- (MZActor * (^)(void))_cannons;
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
        [wbActor addActiveCondition:^{ return (bool)false; }];
    };

    return bt;
}

- (void)_setEnemyFuncs {
    _createFuncsDict[@"the-simple"] = [self _theSimple];
    _createFuncsDict[@"the-one"] = [self _theOne];
    _createFuncsDict[@"cannons"] = [self _cannons];
}

- (MZActor * (^)(void))_theSimple {
    __mz_gen_weak_block(wbScene, gameScene);
    __mz_gen_weak_block(wbSelf, self);
    return ^{
        __mz_weak_block MZActor *enemy = [wbScene.actorUpdaters.enemies addActionLate:[MZActor new]];

        [wbSelf _addCommonBoundTestToActor:enemy];

        __mz_weak_block MZHealth *health = [enemy addAction:[MZHealth new] name:@"health"];
        health.healthPoint = 100;

        MZNodes *nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:@"Bow"] name:@"body"];

        MZAttack_NWayToDirection *attack =
            [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
        attack.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        attack.colddown = 10000;
        attack.interval = 5;
        attack.numberOfWays = 1;
        attack.targetDirection = 0;
        attack.bulletVelocity = 10;
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
                [enemy addActiveCondition:^{ return (bool)false; }];
            }
        };

        //        MZMoveTurnToDirection *move = [enemy addAction:[MZMoveTurnToDirection newWithMover:enemy]
        // name:@"move"];
        //        move.direction = 180;
        //        move.turnDegreesPerSecond = 50;
        //        move.turnToDirection = 270;
        //        move.velocity = 100;

        //        __mz_gen_weak_block(wbMove, move);
        //        attack.beforeLauchAction = ^(MZAttack_NWayToDirection *_a) {
        //            _a.targetDirection = wbMove.direction;
        //        };

        enemy.scale = 0.3;

        return enemy;
    };
}

- (MZActor * (^)(void))_theOne {
    __mz_gen_weak_block(wbScene, gameScene);
    __mz_gen_weak_block(wbSelf, self);

    return ^{
        __mz_weak_block MZActor *enemy = [wbScene.actorUpdaters.enemies addActionLate:[MZActor new]];

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
                [enemy addActiveCondition:^{ return (bool)false; }];
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

- (MZActor * (^)(void))_cannons {
    __mz_gen_weak_block(wbScene, gameScene);
    __mz_gen_weak_block(wbSelf, self);

    return ^{
        __mz_weak_block_type(MZActor *)e = [wbScene.actorUpdaters.enemies addActionLate:[MZActor new]];

        [wbSelf _addCommonBoundTestToActor:e];

        __mz_weak_block_type(MZHealth *)health = [e addAction:[MZHealth new] name:@"health"];
        health.healthPoint = 4000;

        __mz_weak_block_type(MZNodes *)nodes = [e addAction:[MZNodes new] name:@"nodes"];

        __mz_weak_block_type(MZNodeInfo *)bodyNodeInfo =
            [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:@"ship"]
                      name:@"body"];
        bodyNodeInfo.originScale = 0.3;

        __mz_weak_block_type(MZNodeInfo *)cannon1NodeIndo =
            [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithAnimationName:@"monster_blue"]
                      name:@"cannon1"];
        cannon1NodeIndo.originScale = 0.5;
        cannon1NodeIndo.originPosition = mzp(50, 50);

        __mz_weak_block_type(MZNodeInfo *)cannon2NodeInfo =
            [nodes addNode:[[wbScene spritesLayerWithName:@"enemies"] spriteWithAnimationName:@"monster_red"]
                      name:@"cannon2"];
        cannon2NodeInfo.originScale = 0.5;
        cannon2NodeInfo.originPosition = mzp(50, -50);

        // attack bind to cannon node
        __mz_weak_block_type(MZAttack_NWayToDirection *)attack1 =
            [e addAction:[MZAttack_NWayToDirection newWithAttacker:cannon1NodeIndo] name:@"attack1"];
        attack1.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        attack1.bulletScale = 0.4;
        attack1.bulletVelocity = 100;
        attack1.numberOfWays = 3;
        attack1.interval = 10;
        attack1.targetDirection = 270;
        attack1.colddown = 0.5;
        attack1.updateAction = ^(MZAttack_NWayToDirection *a) {
            a.targetDirection = [MZMath degreesFromP1:a.attacker.position toP2:wbScene.player.position];
        };

        // set cannon1 hp, collider
        __mz_weak_block_type(MZHealth *)cannon1Health = [e addAction:[MZHealth new] name:@"cannon1-health"];
        cannon1Health.healthPoint = 20;

        __mz_weak_block_type(MZSpriteCircleCollider *)cannon1Collider =
            [e addAction:[MZSpriteCircleCollider newWithSprite:(SKSpriteNode *)cannon1NodeIndo.node
                                                        offset:MZPZero
                                                collisionScale:1]
                     name:@"cannon1Collider"];
        MZLogRetainCount(@"aaa", cannon1Collider);

        [cannon1Collider addDebugDrawNodeWithParent:wbScene.debugLayer color:[SKColor yellowColor]];


        cannon1Health.healthZeroActoin = ^(MZHealth *h) {
            [nodes removeWithName:@"cannon1"];
            [e removeAction:attack1];
            [e removeAction:h];
            [e removeAction:cannon1Collider];

            h.healthZeroActoin = nil;
        };

        cannon1Collider.collidedAction = ^(id c) {
            cannon1Health.healthPoint -= 1;
        };

        MZAttack_NWayToDirection *a0 = [MZAttack_NWayToDirection newWithAttacker:cannon2NodeInfo];
        a0.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        a0.numberOfWays = 5;
        a0.bulletVelocity = 200;
        a0.bulletScale = 0.3;
        a0.duration = 0.5;
        a0.interval = 10;
        a0.colddown = 0.1;
        a0.targetDirection = 270;
        // test acc
        a0.updateAction = ^(MZAttack_NWayToDirection *_a) {
            _a.bulletVelocity = 100 + (_a.launchCount - 1) * 50;
        };

        MZIdle *idle = [MZIdle newWithDuration:3];

        MZAttack_NWayToDirection *a1 = [MZAttack_NWayToDirection newWithAttacker:cannon2NodeInfo];
        a1.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        a1.numberOfWays = 36;
        a1.bulletVelocity = 200;
        a1.bulletScale = 0.3;
        a1.duration = 3;
        a1.interval = 10;
        a1.colddown = 0.1;
        a1.targetDirection = 90;

        //__mz_weak_block_type(MZActionsSequence *)seqAtk = [e addAction:[] name:@"seq-atk"]
        MZActionsSequence *seqAtk = [MZActionsSequence newWithActions:@[ a0, idle, a1 ]];
        [e addAction:seqAtk name:@"seq-atk"];

        [e refresh];
        e.position = wbScene.center;
        e.rotation = 270;
        return e;
    };
}

@end
