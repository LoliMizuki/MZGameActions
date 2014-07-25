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
    MZActor *player = [gameScene.actorUpdaters.players addAction:[MZActor new]];

    MZTouchRelativeMove *trm = [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:gameScene]
                                            name:@"touch-relative-move"];
    trm.bound = gameScene.gameBound;

    [player addActionWithClass:[MZNodes class] name:@"nodes"];

    [self _setMainBodyToPlayer:player];
    [self _setLeftToPlayer:player];
    [self _setAttackToPlayer:player];

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
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:.25]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer color:[UIColor redColor]];
}

- (void)_setLeftToPlayer:(MZActor *)player {
    __mz_gen_weak_block(wbPlayer, player);

    __mz_weak_block_type(MZNodes *)nodes = [player actionWithName:@"nodes"];

    __mz_weak_block_type(MZNodeInfo *)nodeInfo =
        [nodes addNode:[[gameScene spritesLayerWithName:@"player"] spriteWithForeverAnimationName:@"fairy-walk-left"]
                  name:@"left-body"];
    nodeInfo.originPosition = mzp(80, 0);

    SKSpriteNode *sprite = (SKSpriteNode *)nodeInfo.node;

    __mz_weak_block_type(MZSpriteCircleCollider *)collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"left-body-collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer color:[UIColor redColor]];

    __mz_weak_block_type(MZHealth *)health = [player addAction:[MZHealth new] name:@"sub-health"];
    health.healthPoint = 10;

    health.healthZeroActoin = ^(MZHealth *h) {
        [nodes removeWithNodeInfo:nodeInfo];
        [wbPlayer removeAction:collider];
        [wbPlayer removeAction:health];
        h.healthZeroActoin = nil;
    };

    collider.collidedAction = ^(id c) {
        health.healthPoint -= 1;
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
