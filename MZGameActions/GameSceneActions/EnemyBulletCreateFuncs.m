#import "EnemyBulletCreateFuncs.h"
#import "MZGameHeader.h"
#import "GameScene.h"
#import "ActorUpdaters.h"

@interface EnemyBulletCreateFuncs (_)
- (void)_setCreateFuncs;

- (SKSpriteNode *)_bulletSpriteWithName:(NSString *)name;
- (MZActor *)_newBulletWithSprite:(SKSpriteNode *)sprite;

- (MZActor * (^)(void))_the_b;
- (MZActor * (^)(void))_fireball;
- (MZActor * (^)(void))_rect;
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
    _createFuncsDict[@"the-b"] = [self _the_b];
    _createFuncsDict[@"fireball"] = [self _fireball];
    _createFuncsDict[@"rect"] = [self _rect];
}

- (SKSpriteNode *)_bulletSpriteWithName:(NSString *)name {
    return [[self.gameScene spritesLayerWithName:@"enemy-bullets"] spriteWithTextureName:name];
}

- (MZActor *)_newBulletWithSprite:(SKSpriteNode *)sprite {
    MZActor *bullet = [self.gameScene.actorUpdaters.enemyBullets addAction:[MZActor new]];

    MZNodes *nodes = [bullet addAction:[MZNodes new] name:@"nodes"];
    [nodes addNodeInfoWithNode:sprite name:@"body"];

    MZSpriteCircleCollider *collider =
        [bullet addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:0.5]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:self.gameScene.debugLayer color:[UIColor greenColor]];
    __mz_gen_weak_block(wbBullet, bullet);
    collider.collidedAction = ^(MZSpriteCircleCollider *c) {
        [wbBullet addActiveCondition:^{ return (bool)false; }];
    };

    MZBoundTest *boundTest =
        [bullet addAction:[MZBoundTest newWithTester:bullet bound:self.gameScene.gameBound] name:@"boundTest"];
    __mz_gen_weak_block(wbSprite, sprite);
    boundTest.testerSizeFunc = ^{ return (wbSprite != nil) ? wbSprite.size : CGSizeZero; };
    boundTest.outOfBoundAction = ^(id bt) {
        [wbBullet addActiveCondition:^{ return (bool)false; }];
    };

    return bullet;
}

- (MZActor * (^)(void))_the_b {
    return ^{ return [self _newBulletWithSprite:[self _bulletSpriteWithName:@"fireball"]]; };
}

- (MZActor * (^)(void))_fireball {
    return ^{ return [self _newBulletWithSprite:[self _bulletSpriteWithName:@"10-fireball"]]; };
}

- (MZActor * (^)(void))_rect {
    return ^{ return [self _newBulletWithSprite:[self _bulletSpriteWithName:@"rect"]]; };
}

@end
