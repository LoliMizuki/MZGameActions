#import "EnemyCreateFuncs.h"
#import "GameSceneActionsHeader.h"

@interface EnemyCreateFuncs (_)
- (MZSpritesLayer *)_enemiesLayer;
- (SKSpriteNode *)_enemySpriteWithFrameName:(NSString *)name;
- (SKSpriteNode *)_enemyAnimationSpriteWithName:(NSString *)name;
- (MZBoundTest *)_addCommonBoundTestToActor:(MZActor *)actor;

- (void)_setEnemyFuncs;

- (ActorGenFunc)_theSimple;
- (ActorGenFunc)_theOne;
- (ActorGenFunc)_theCannons;
- (ActorGenFunc)_theRepeater;
- (ActorGenFunc)_theMother;
- (ActorGenFunc)_theStalker;
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

- (ActorGenFunc)funcWithName:(NSString *)name {
    MZAssertIfNilWithMessage(_createFuncsDict[name], @"can not found func with name: %@", name);
    return _createFuncsDict[name];
}

- (MZActor *)newEnemyWithHP:(int)hp bodySprite:(SKSpriteNode *)bodySprite {
    MZActor *enemy = [gameScene.actorUpdaters.enemies addActionLate:[MZActor new]];

    [self _addCommonBoundTestToActor:enemy];

    __mz_weak_block_type(MZNodes *)nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
    [nodes addNode:bodySprite name:@"body"];

    __mz_weak_block_type(MZHealth *)health = [enemy addAction:[MZHealth new] name:@"health"];
    health.healthPoint = hp;

    MZSpriteCircleCollider *collider =
        [enemy addAction:[MZSpriteCircleCollider newWithSprite:bodySprite offset:MZPZero collisionScale:1]
                    name:@"collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer
                                   color:[UIColor colorWithRed:0.000 green:1.000 blue:0.957 alpha:1.000]];

    [enemy addActiveCondition:^{ return (bool)(health.healthPoint > 0); }];

    collider.collidedAction = ^(id c) {
        health.healthPoint -= 1;
    };

    return enemy;
}

@end

@implementation EnemyCreateFuncs (_)

- (MZSpritesLayer *)_enemiesLayer {
    return [gameScene spritesLayerWithName:@"enemies"];
}

- (SKSpriteNode *)_enemySpriteWithFrameName:(NSString *)name {
    return [[self _enemiesLayer] spriteWithTextureName:name];
}

- (SKSpriteNode *)_enemyAnimationSpriteWithName:(NSString *)name {
    return [[self _enemiesLayer] spriteWithForeverAnimationName:name];
}

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
    _createFuncsDict[@"the-cannons"] = [self _theCannons];
    _createFuncsDict[@"the-repeater"] = [self _theRepeater];
    _createFuncsDict[@"the-mother"] = [self _theMother];
    _createFuncsDict[@"the-stalker"] = [self _theStalker];
}

- (ActorGenFunc)_theSimple {
    __mz_gen_weak_block(wbScene, gameScene);
    return ^{
        MZActor *enemy = [self newEnemyWithHP:30 bodySprite:[self _enemyAnimationSpriteWithName:@"Bow"]];

        MZAttack_NWayToDirection *attack =
            [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
        attack.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        attack.colddown = 10000;
        attack.interval = 5;
        attack.numberOfWays = 10;
        attack.targetDirection = 0;
        attack.bulletVelocity = 10;
        attack.bulletScale = 0.25;

        enemy.scale = 0.3;

        return enemy;
    };
}

- (ActorGenFunc)_theOne {
    __mz_gen_weak_block(wbScene, gameScene);

    return ^{
        MZActor *enemy = [self newEnemyWithHP:3 bodySprite:[self _enemyAnimationSpriteWithName:@"Bow"]];

        MZAttack_NWayToDirection *attack =
            [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
        attack.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        attack.colddown = 1.0;
        attack.interval = 5;
        attack.numberOfWays = 5;
        attack.targetDirection = 270;
        attack.bulletVelocity = 300;
        attack.bulletScale = 0.25;

        MZMoveTurnFromTo *move = [enemy addAction:[MZMoveTurnFromTo newWithMover:enemy] name:@"move"];
        move.fromDirection = 180;
        move.toDirection = 270;
        move.turnDegreesPerSecond = 100;
        move.velocity = 100;

        __mz_gen_weak_block(wbMove, move);
        attack.beforeLauchAction = ^(MZAttack_NWayToDirection *_a) {
            _a.targetDirection = wbMove.currentDirection;
        };

        enemy.scale = 0.3;

        return enemy;
    };
}

- (ActorGenFunc)_theCannons {
    __mz_gen_weak_block(wbScene, gameScene);

    return ^{
        MZActor *enemy = [self newEnemyWithHP:40 bodySprite:[self _enemyAnimationSpriteWithName:@"ship"]];
        __mz_gen_weak_block(wbEnemy, enemy);

        __mz_weak_block_type(MZNodes *)nodes = [enemy actionWithName:@"nodes"];

        MZNodeInfo *bodyNodeInfo = [nodes nodeInfoWithName:@"body"];
        bodyNodeInfo.originScale = 0.3;

        __mz_weak_block_type(MZNodeInfo *)cannon1NodeInfo =
            [nodes addNode:[self _enemyAnimationSpriteWithName:@"monster_blue"] name:@"cannon1"];
        cannon1NodeInfo.originScale = 0.5;
        cannon1NodeInfo.originPosition = mzp(50, 50);

        // attack bind to cannon node
        __mz_weak_block_type(MZAttack_NWayToDirection *)attack1 =
            [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:cannon1NodeInfo] name:@"attack1"];
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
        __mz_weak_block_type(MZHealth *)cannon1Health = [enemy addAction:[MZHealth new] name:@"cannon1-health"];
        cannon1Health.healthPoint = 20;

        __mz_weak_block_type(MZSpriteCircleCollider *)cannon1Collider =
            [enemy addAction:[MZSpriteCircleCollider newWithSprite:(SKSpriteNode *)cannon1NodeInfo.node
                                                            offset:MZPZero
                                                    collisionScale:1]
                        name:@"cannon1Collider"];

        [cannon1Collider addDebugDrawNodeWithParent:wbScene.debugLayer color:[SKColor yellowColor]];

        cannon1Health.healthZeroActoin = ^(MZHealth *h) {
            [nodes removeWithName:@"cannon1"];
            [wbEnemy removeAction:attack1];
            [wbEnemy removeAction:h];
            [wbEnemy removeAction:cannon1Collider];

            h.healthZeroActoin = nil;
        };

        cannon1Collider.collidedAction = ^(id c) {
            cannon1Health.healthPoint -= 1;
        };

        MZAttack_NWayToDirection *a0 = [MZAttack_NWayToDirection newWithAttacker:cannon1NodeInfo];
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

        MZWait *wait = [MZWait newWithDuration:3];

        MZAttack_NWayToDirection *a1 = [MZAttack_NWayToDirection newWithAttacker:cannon1NodeInfo];
        a1.bulletGenFunc = [wbScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        a1.numberOfWays = 36;
        a1.bulletVelocity = 200;
        a1.bulletScale = 0.3;
        a1.duration = 3;
        a1.interval = 10;
        a1.colddown = 0.1;
        a1.targetDirection = 90;

        MZActionsSequence *seqAtk = [MZActionsSequence newWithActions:@[ a0, wait, a1 ]];
        [enemy addAction:seqAtk name:@"seq-atk"];

        [enemy refresh];
        enemy.position = wbScene.center;
        enemy.rotation = 270;
        return enemy;
    };
}

- (ActorGenFunc)_theRepeater {
    return ^{
        MZActor *enemy = [self newEnemyWithHP:100 bodySprite:[self _enemyAnimationSpriteWithName:@"monster_red"]];

        // TODO: test, 用 active func 測試發射次數來結束
        MZAttack_NWayToDirection *a1 = [MZAttack_NWayToDirection newWithAttacker:enemy];
        a1.bulletGenFunc = [self.gameScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        a1.bulletScale = 0.4;
        a1.bulletVelocity = 50;
        a1.numberOfWays = 1;
        a1.targetDirection = 270;
        a1.colddown = 9999;
        a1.duration = 0.5;

        MZAttack_NWayToDirection *a2 = [MZAttack_NWayToDirection newWithAttacker:enemy];
        a2.bulletGenFunc = [self.gameScene.actorCreateFuncs.enemyBullet funcWithName:@"the-b"];
        a2.bulletScale = 0.4;
        a2.bulletVelocity = 50;
        a2.colddown = 9999;
        a2.numberOfWays = 3;
        a2.interval = 20;
        a2.targetDirection = 270;
        a2.duration = 1.5;

        MZActionsSequence *seq = [MZActionsSequence
            newWithActions:
                @[ [MZWait newWithDuration:2], a1, [MZWait newWithDuration:0.5], a2, [MZWait newWithDuration:0.5] ]];

        [enemy addAction:[MZActionRepeat newWithForeverAction:seq]];

        enemy.rotation = 270;

        return enemy;
    };
}

- (ActorGenFunc)_theMother {
    return ^{
        MZActor *enemy = [self newEnemyWithHP:300 bodySprite:[self _enemyAnimationSpriteWithName:@"ship"]];
        __mz_gen_weak_block(wbEnemy, enemy);

        MZAction *spawn = [MZAction new];
        spawn.duration = 0.1;
        spawn.startAction = ^(MZAction *ss) {
            MZActor *child = [self funcWithName:@"the-stalker"]();
            child.position = wbEnemy.position;
        };

        MZWait *delay = [MZWait newWithDuration:1];

        MZActionsSequence *spawnSeq = [MZActionsSequence newWithActions:@[ delay, spawn ]];

        [enemy addAction:[MZActionRepeat newWithForeverAction:spawnSeq] name:@"seq"];

        enemy.scale = 0.5;
        enemy.rotation = 270;

        return enemy;
    };
}

- (ActorGenFunc)_theStalker {
    return ^{
        MZActor *enemy = [self newEnemyWithHP:5 bodySprite:[self _enemyAnimationSpriteWithName:@"Bow"]];
        __mz_gen_weak_block(wbEnemy, enemy);

        MZMoveTurnFromTo *move = [enemy addAction:[MZMoveTurnFromTo newWithMover:enemy] name:@"move"];
        move.velocity = 200;
        move.turnDegreesPerSecond = 100;
        move.updateAction = ^(MZMoveTurnFromTo *m) {
            m.fromDirection = [MZMath degreesFromP1:wbEnemy.position toP2:self.gameScene.player.position];
        };

        enemy.scale = .2;

        return enemy;
    };
}

@end
