#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"
#import "SetLayers.h"
#import "SetPlayer.h"
#import "EnemyCreateFuncs.h"
#import "EnemyBulletCreateFuncs.h"

@interface GameScene (_)
- (void)_init;

- (void)_setGUIs;

- (MZActor * (^)(void))__test_enemy_bullet_func;
@end

@implementation GameScene {
    NSMutableDictionary *_spritesLayerDict;
    NSMutableArray *_touchResponders;

    SKLabelNode *_message;
}

@synthesize playerActionTime;
@synthesize enemiesCreateFuncs, enemyBulletCreateFuncs;
@synthesize gameBound;
@synthesize playersUpdater, enemiesUpdater, enemyBulletsUpdater;
@synthesize debugLayer;

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    [self _init];

    [[SetLayers newWithScene:self] setLayersFromDatas];
    [[SetPlayer newWithScene:self] setPlayer];

    enemiesCreateFuncs = [EnemyCreateFuncs newWithScene:self];
    enemyBulletCreateFuncs = [EnemyBulletCreateFuncs newWithScene:self];

    [self _setGUIs];

    [self addChild:debugLayer];

    [self runAction:[SKAction sequence:@[
                                          [SKAction waitForDuration:3],
                                          [SKAction runBlock:^{ [enemiesCreateFuncs funcWithName:@"the-one"](); }]
                                       ]]];

    return self;
}

- (void)dealloc {
    [_touchResponders removeAllObjects];

    [playersUpdater clear];
    [enemiesUpdater clear];
    [enemyBulletsUpdater clear];

    for (SKNode *l in _spritesLayerDict.allValues) [l removeFromParent];
    [_spritesLayerDict removeAllObjects];
}

- (CGPoint)center {
    return mzpFromSizeAndFactor(self.size, 0.5);
}

- (void)addTouchResponder:(id<MZTouchResponder>)touchResponder {
    [_touchResponders addObject:touchResponder];
}

- (void)addSpritesLayer:(MZSpritesLayer *)layer name:(NSString *)name {
    _spritesLayerDict[name] = layer;
    [self addChild:layer];
}

- (MZSpritesLayer *)spritesLayerWithName:(NSString *)name {
    return _spritesLayerDict[name];
}

- (void)removeTouchResponder:(id<MZTouchResponder>)touchResponder {
    [_touchResponders removeObject:touchResponder];
}

- (CGPoint)positionWithTouch:(UITouch *)touch {
    return [touch locationInNode:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (id<MZTouchResponder> t in _touchResponders) {
        [t touchesBegan:touches];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (id<MZTouchResponder> t in _touchResponders) {
        [t touchesMoved:touches];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (id<MZTouchResponder> t in _touchResponders) {
        [t touchesEnded:touches];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    [playerActionTime updateWithCurrentTime:currentTime];

    [playersUpdater update];
    [enemiesUpdater update];
    [enemyBulletsUpdater update];

    // collision test
    for (MZActor *player in playersUpdater.updatingAciotns) {
        MZSpriteCircleCollider *playerCollider = [player actionWithName:@"collider"];
        for (MZActor *eb in enemyBulletsUpdater.updatingAciotns) {
            MZSpriteCircleCollider *ebCollider = [eb actionWithName:@"collider"];
            //
            [playerCollider collidesAnother:ebCollider];
        }
    }

    [playersUpdater removeInactives];
    [enemiesUpdater removeInactives];
    [enemyBulletsUpdater removeInactives];

    NSUInteger a = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfAvailable;
    NSUInteger b = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfElements;
    //
    _message.text = [NSString stringWithFormat:@"%lu/%lu", a, b];
}

@end

@implementation GameScene (_)

- (void)_init {
    _spritesLayerDict = [NSMutableDictionary new];
    debugLayer = [SKNode node];

    CGPoint inner = mzp(50, 50);
    gameBound = CGRectMake(inner.x, inner.y, self.size.width - 2 * inner.x, self.size.height - 2 * inner.y);

    // add bound lines
    CGMutablePathRef path = CGPathCreateMutable();
    CGSize halfSize = gameBound.size;
    halfSize = CGSizeMake(halfSize.width / 2, halfSize.height / 2);
    CGPathAddRect(path, nil, gameBound);
    SKShapeNode *gameZone = [SKShapeNode node];
    [gameZone setStrokeColor:[SKColor purpleColor]];
    gameZone.path = path;
    CGPathRelease(path);
    [self addChild:gameZone];

    playerActionTime = [MZActionTime new];
    playerActionTime.name = @"player";

    playersUpdater.actionTime = playerActionTime;

    _touchResponders = [NSMutableArray new];

    playersUpdater = [MZActionsGroup new];
    playersUpdater.actionTime = playerActionTime;

    enemiesUpdater = [MZActionsGroup new];
    enemiesUpdater.actionTime = playerActionTime;

    enemyBulletsUpdater = [MZActionsGroup new];
    enemyBulletsUpdater.actionTime = playerActionTime;

    _message = [SKLabelNode labelNodeWithFontNamed:@"Arail"];
    _message.position = mzp(self.size.width / 2, 20);
    [self addChild:_message];
}

- (void)_setGUIs {
    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"ElWoQnH"];
    backButton.position = mzpAdd(mzp(self.size.width, self.size.height), mzp(-40, -60));
    [backButton setScale:0.1];
    [self addChild:backButton];

    __mz_gen_weak_block(weakSelf, self);
    [backButton addTouchType:kMZTouchType_Began
                 touchAction:^(NSSet *touches, UIEvent *event) {
                     SKView *view = weakSelf.view;
                     [view presentScene:[AnotherScene sceneWithSize:weakSelf.size]
                             transition:[SKTransition crossFadeWithDuration:.5]];
                 }];
}

- (MZActor * (^)(void))__test_enemy_bullet_func {
    __mz_gen_weak_block(ebu, enemyBulletsUpdater);
    __mz_gen_weak_block(dl, debugLayer);

    return ^{
        MZActor *b = [ebu addImmediate:[MZActor new]];

        MZNodes *nodes = [b addAction:[MZNodes new] name:@"nodes"];
        [nodes addNode:[[self spritesLayerWithName:@"enemy-bullets"] spriteWithTextureName:@"fireball.png"]
                  name:@"body"];

        SKSpriteNode *bodySprite = (SKSpriteNode *)[nodes nodeWithName:@"body"];

        MZSpriteCircleCollider *collider =
            [b addAction:[MZSpriteCircleCollider newWithSprite:bodySprite offset:MZPZero collisionScale:0.5]
                     name:@"collider"];

        __mz_gen_weak_block(weakB, b);
        collider.collidedAction = ^(MZSpriteCircleCollider *c) {
            [weakB setActive:false];
        };
        [collider addDebugDrawNodeWithParent:dl color:[UIColor greenColor]];

        MZBoundTest *boundTest = [b addAction:[MZBoundTest newWithTester:b bound:gameBound] name:@"boundTest"];
        __mz_gen_weak_block(wbSprite, bodySprite);
        boundTest.testerSizeFunc = ^{ return (wbSprite != nil) ? wbSprite.size : CGSizeZero; };
        boundTest.outOfBoundAction = ^(id bt) {
            [weakB setActive:false];
        };

        return b;
    };
}

@end