#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"
#import "SetLayers.h"

@interface GameScene (_)
- (void)_init;

- (void)_setPlayer;
- (void)_setEnemies;

- (void)_setGUIs;

- (MZActor * (^)(void))__test_enemy_bullet_func;
- (void)__test_random_put_sprites;
@end



@implementation GameScene {
    MZActionTime *_playerActionTime;
    NSMutableDictionary *_spritesLayerDict;

    MZActionsGroup *_playersUpdater;
    MZActionsGroup *_enemiesUpdater;
    MZActionsGroup *_enemyBulletsUpdater;

    NSMutableArray *_touchResponders;

    SKNode *_debugLayer;
    SKLabelNode *_message;

    CGRect _gameBound;
}

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    [self _init];

    [[SetLayers newWithScene:self] setLayersFromDatas];

    [self _setPlayer];
    [self _setEnemies];

    [self _setGUIs];

    [self addChild:_debugLayer];

    return self;
}

- (void)dealloc {
    [_touchResponders removeAllObjects];

    [_playersUpdater clear];
    [_enemiesUpdater clear];
    [_enemyBulletsUpdater clear];

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
    [_playerActionTime updateWithCurrentTime:currentTime];

    [_playersUpdater update];
    [_enemiesUpdater update];
    [_enemyBulletsUpdater update];

    // collision test
    for (MZActor *player in _playersUpdater.updatingAciotns) {
        MZSpriteCircleCollider *playerCollider = [player actionWithName:@"collider"];
        for (MZActor *eb in _enemyBulletsUpdater.updatingAciotns) {
            MZSpriteCircleCollider *ebCollider = [eb actionWithName:@"collider"];
            //
            [playerCollider collidesAnother:ebCollider];
        }
    }

    [_playersUpdater removeInactives];
    [_enemiesUpdater removeInactives];
    [_enemyBulletsUpdater removeInactives];

    NSUInteger a = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfAvailable;
    NSUInteger b = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfElements;
    //
    _message.text = [NSString stringWithFormat:@"%lu/%lu", a, b];
}

@end

@implementation GameScene (_)

- (void)_init {
    _spritesLayerDict = [NSMutableDictionary new];
    _debugLayer = [SKNode node];

    CGPoint inner = mzp(50, 50);
    _gameBound = CGRectMake(inner.x, inner.y, self.size.width - 2 * inner.x, self.size.height - 2 * inner.y);

    // add bound lines
    CGMutablePathRef path = CGPathCreateMutable();
    CGSize halfSize = _gameBound.size;
    halfSize = CGSizeMake(halfSize.width / 2, halfSize.height / 2);
    CGPathAddRect(path, nil, _gameBound);
    SKShapeNode *gameZone = [SKShapeNode node];
    [gameZone setStrokeColor:[SKColor purpleColor]];
    gameZone.path = path;
    CGPathRelease(path);
    [self addChild:gameZone];

    _playerActionTime = [MZActionTime new];
    _playerActionTime.name = @"player";

    _touchResponders = [NSMutableArray new];

    _playersUpdater = [MZActionsGroup new];
    _playersUpdater.actionTime = _playerActionTime;

    _enemiesUpdater = [MZActionsGroup new];
    _enemiesUpdater.actionTime = _playerActionTime;

    _enemyBulletsUpdater = [MZActionsGroup new];
    _enemyBulletsUpdater.actionTime = _playerActionTime;

    _message = [SKLabelNode labelNodeWithFontNamed:@"Arail"];
    _message.position = mzp(self.size.width / 2, 20);
    [self addChild:_message];
}

- (void)_setPlayer {
    _playersUpdater.actionTime = _playerActionTime;
    MZActor *player = [_playersUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [player addActionWithClass:[MZNodes class] name:@"nodes"];
    SKSpriteNode *sprite =
        (SKSpriteNode *)
        [nodes addNode:[[self spritesLayerWithName:@"player"] spriteWithForeverAnimationName:@"fairy-walk-up"]
                  name:@"body"].node;

    MZTouchRelativeMove *trm =
        [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:self] name:@"touch-relative-move"];
    trm.bound = _gameBound;

    MZSpriteCircleCollider *collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:_debugLayer color:[UIColor redColor]];

    player.position = mzpAdd([self center], mzp(0, -200));
    player.rotation = 90;
}

- (void)_setEnemies {
    MZActor *enemy = [_enemiesUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
    [nodes addNode:[[self spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:@"Bow"] name:@"body"];

    MZAttack_NWayToDirection *a = [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
    a.bulletGenFunc = [self __test_enemy_bullet_func];
    a.colddown = 0.2;
    a.interval = 5;
    a.numberOfWays = 5;
    a.targetDirection = 270;
    a.bulletVelocity = 100;
    a.bulletScale = 0.25;
    a.beforeLauchAction = ^(MZAttack_NWayToDirection *_a) {
        _a.targetDirection += 10;
    };

    enemy.position = mzpFromSizeAndFactor(self.size, .5);
    enemy.rotation = 270;
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
    __mz_gen_weak_block(ebu, _enemyBulletsUpdater);
    __mz_gen_weak_block(dl, _debugLayer);

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

        MZBoundTest *boundTest = [b addAction:[MZBoundTest newWithTester:b bound:_gameBound] name:@"boundTest"];
        __mz_gen_weak_block(wbSprite, bodySprite);
        boundTest.testerSizeFunc = ^{ return (wbSprite != nil) ? wbSprite.size : CGSizeZero; };
        boundTest.outOfBoundAction = ^(id bt) {
            [weakB setActive:false];
        };

        return b;
    };
}

- (void)__test_random_put_sprites {
    CGPoint (^randPos)() = ^{
        return mzp([MZMath randomIntInRangeMin:0 max:self.size.width],
                   [MZMath randomIntInRangeMin:0 max:self.size.height]);
    };

    void (^randPut)() = ^{
        NSString *n = [MZCollections randomPickInArray:[self spritesLayerWithName:@"enemies"].animationNames];
        SKSpriteNode *s = [[self spritesLayerWithName:@"enemies"] spriteWithForeverAnimationName:n];
        s.position = randPos();
    };

    [self runAction:[SKAction sequence:@[
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut],
                                          [SKAction waitForDuration:2],
                                          [SKAction runBlock:randPut]
                                       ]]];
}

@end