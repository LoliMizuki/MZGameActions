#import "SetPlayer.h"
#import "GameSceneActionsHeader.h"
#import "MZGameHeader.h"

@interface SetPlayer (_)
- (void)_setMainBodyToPlayer:(MZActor *)player;
- (void)_setLeftToPlayer:(MZActor *)player;
- (void)_setAttackToPlayer:(MZActor *)player;
@end



@implementation SetPlayer

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    SetPlayer *sp = [self new];
    sp.gameScene = gameScene;
    return sp;
}

- (void)dealloc {
    gameScene = nil;
}

- (void)setPlayer {
    MZActor *player = [gameScene.actorUpdaters.playersUpdater addImmediate:[MZActor new]];

    MZTouchRelativeMove *trm = [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:gameScene]
                                            name:@"touch-relative-move"];
    trm.bound = gameScene.gameBound;

    [player addActionWithClass:[MZNodes class] name:@"nodes"];

    [self _setMainBodyToPlayer:player];
    [self _setLeftToPlayer:player];
    //    [self _setAttackToPlayer:player];


    player.position = mzpAdd([gameScene center], mzp(0, -200));
    player.rotation = 90;
}

@end

@implementation SetPlayer (_)

- (void)_setMainBodyToPlayer:(MZActor *)player {
    MZNodes *nodes = [player actionWithName:@"nodes"];

    SKSpriteNode *sprite =
        (SKSpriteNode *)
        [nodes addNode:[[gameScene spritesLayerWithName:@"player"] spriteWithForeverAnimationName:@"fairy-walk-up"]
                  name:@"body"].node;

    MZSpriteCircleCollider *collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer color:[UIColor redColor]];
}

- (void)_setLeftToPlayer:(MZActor *)player {
    MZNodes *nodes = [player actionWithName:@"nodes"];

    MZNodeInfo *nodeInfo =
        [nodes addNode:[[gameScene spritesLayerWithName:@"player"] spriteWithForeverAnimationName:@"fairy-walk-left"]
                  name:@"left-body"];
    nodeInfo.originPosition = mzp(80, 0);

    SKSpriteNode *sprite = (SKSpriteNode *)nodeInfo.node;

    MZSpriteCircleCollider *collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"left-bidy-collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer color:[UIColor redColor]];

    MZHealth *health = [player addAction:[MZHealth new] name:@"sub-health"];
    health.healthPoint = 10;

    __mz_gen_weak_block(wbNodes, nodes);
    __mz_gen_weak_block(wbHealth, health);
    __mz_gen_weak_block(wbCollider, collider);

    health.healthZeroActoin = ^(MZHealth *h) {
        [wbNodes removeWithName:@"left-body"];
        wbCollider.isActive = false;
        h.isActive = false;
        h.healthZeroActoin = nil;
    };

    collider.collidedAction = ^(id c) {
        wbHealth.healthPoint -= 1;
    };
}

- (void)_setAttackToPlayer:(MZActor *)player {
    MZAttack_NWayToDirection *a = [player addAction:[MZAttack_NWayToDirection newWithAttacker:player] name:@"attack"];
    a.bulletGenFunc = [gameScene.actorCreateFuncs.playerBullet funcWithName:@"pb-1"];
    a.numberOfWays = 3;
    a.interval = 5;
    a.bulletVelocity = 300;
    a.targetDirection = 90;
    a.colddown = 0.25;
    a.bulletScale = 0.5;
}

@end
