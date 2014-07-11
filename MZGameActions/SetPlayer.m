#import "SetPlayer.h"
#import "GameScene.h"
#import "MZGameHeader.h"

@implementation SetPlayer

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    SetPlayer *sp = [self new];
    sp.gameScene = gameScene;

    return sp;
}

- (void)setPlayer {
    MZActor *player = [gameScene.playersUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [player addActionWithClass:[MZNodes class] name:@"nodes"];
    SKSpriteNode *sprite =
        (SKSpriteNode *)
        [nodes addNode:[[gameScene spritesLayerWithName:@"player"] spriteWithForeverAnimationName:@"fairy-walk-up"]
                  name:@"body"].node;

    MZTouchRelativeMove *trm = [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:gameScene]
                                            name:@"touch-relative-move"];
    trm.bound = gameScene.gameBound;

    MZSpriteCircleCollider *collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:gameScene.debugLayer color:[UIColor redColor]];

    player.position = mzpAdd([gameScene center], mzp(0, -200));
    player.rotation = 90;
}

@end
