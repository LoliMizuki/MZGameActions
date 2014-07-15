#import "EnemyBulletCreateFuncs.h"
#import "MZGameHeader.h"
#import "GameScene.h"
#import "ActorUpdaters.h"

@interface EnemyBulletCreateFuncs (_)
- (void)_setCreateFuncs;
@end



@implementation EnemyBulletCreateFuncs {
    NSMutableDictionary *_createFuncsDict;
}

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    EnemyBulletCreateFuncs *f = [self new];
    f.gameScene = gameScene;
    [f _setCreateFuncs];
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

@implementation EnemyBulletCreateFuncs (_)

- (void)_setCreateFuncs {
    __mz_gen_weak_block(wbScene, gameScene);

    _createFuncsDict[@"the-b"] = ^{
        MZActor *b = [wbScene.actorUpdaters.enemyBulletsUpdater addImmediate:[MZActor new]];

        MZNodes *nodes = [b addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[wbScene spritesLayerWithName:@"enemy-bullets"] spriteWithTextureName:@"fireball.png"]
                  name:@"body"];

        SKSpriteNode *bodySprite = (SKSpriteNode *)[nodes nodeWithName:@"body"];

        MZSpriteCircleCollider *collider =
            [b addAction:[MZSpriteCircleCollider newWithSprite:bodySprite offset:MZPZero collisionScale:0.5]
                     name:@"collider"];

        __mz_gen_weak_block(weakB, b);
        //        collider.collidedAction = ^(MZSpriteCircleCollider *c) {
        //            [weakB setActive:false];
        //        };
        [collider addDebugDrawNodeWithParent:wbScene.debugLayer color:[UIColor greenColor]];

        MZBoundTest *boundTest = [b addAction:[MZBoundTest newWithTester:b bound:wbScene.gameBound] name:@"boundTest"];
        __mz_gen_weak_block(wbSprite, bodySprite);
        boundTest.testerSizeFunc = ^{ return (wbSprite != nil) ? wbSprite.size : CGSizeZero; };
        boundTest.outOfBoundAction = ^(id bt) {
            [weakB setActive:false];
        };

        return b;
    };
}

@end
