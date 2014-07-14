#import "PlayerBulletCreateFuncs.h"
#import "MZGameHeader.h"
#import "GameScene.h"

@interface PlayerBulletCreateFuncs (_)
- (void)_setCreateFuncs;
@end



@implementation PlayerBulletCreateFuncs {
    NSMutableDictionary *_createFuncsDict;
}

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    PlayerBulletCreateFuncs *pbcf = [self new];
    pbcf.gameScene = gameScene;
    [pbcf _setCreateFuncs];
    return pbcf;
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

@implementation PlayerBulletCreateFuncs (_)

- (void)_setCreateFuncs {
    __mz_gen_weak_block(wbGameScene, gameScene);

    _createFuncsDict[@"pb-1"] = ^{
        MZActor *b = [wbGameScene.playerBulletsUpdater addImmediate:[MZActor new]];

        MZNodes *nodes = [b addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[wbGameScene spritesLayerWithName:@"player-bullets"] spriteWithTextureName:@"10-fireball.png"]
                  name:@"body"];

        SKSpriteNode *bodySprite = (SKSpriteNode *)[nodes nodeWithName:@"body"];

        MZSpriteCircleCollider *collider =
            [b addAction:[MZSpriteCircleCollider newWithSprite:bodySprite offset:MZPZero collisionScale:1.0]
                     name:@"collider"];

        __mz_gen_weak_block(weakB, b);
        collider.collidedAction = ^(MZSpriteCircleCollider *c) {
            [weakB setActive:false];
        };
        [collider addDebugDrawNodeWithParent:wbGameScene.debugLayer color:[UIColor brownColor]];

        MZBoundTest *boundTest =
            [b addAction:[MZBoundTest newWithTester:b bound:wbGameScene.gameBound] name:@"boundTest"];
        __mz_gen_weak_block(wbSprite, bodySprite);
        boundTest.testerSizeFunc = ^{ return (wbSprite != nil) ? wbSprite.size : CGSizeZero; };
        boundTest.outOfBoundAction = ^(id bt) {
            [weakB setActive:false];
        };

        return b;
    };
}

@end
