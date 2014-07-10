#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"

@interface GameScene (_)
- (void)_init;

- (void)_setPlayerLayer;
- (void)_setEnemiesLayer;
- (void)_setEnemyBulletsLayer;

- (void)_setPlayer;
- (void)_setEnemies;

- (void)_setGUIs;

- (MZActor * (^)(void))__test_enemy_bullet_func;
- (void)__test_random_put_sprites;
@end



@implementation GameScene {
    MZActionTime *_playerActionTime;

    MZSpritesLayer *_playersLayer;
    MZSpritesLayer *_enemiesLayer;
    MZSpritesLayer *_enemyBulletsLayer;

    MZActionsGroup *_playersUpdater;
    MZActionsGroup *_enemiesUpdater;
    MZActionsGroup *_enemyBulletsUpdater;

    NSMutableArray *_touchResponders;

    SKNode *_debugLayer;
    SKLabelNode *_message;
}

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    [self _init];

    [self _setPlayerLayer];
    [self _setEnemiesLayer];
    [self _setEnemyBulletsLayer];

    [self _setPlayer];
    [self _setEnemies];

    [self _setGUIs];

    [self addChild:_debugLayer];


    [self runAction:[SKAction sequence:@[
                                          [SKAction waitForDuration:5],
                                          [SKAction runBlock:^{ _playerActionTime.timeScale = 0; }]
                                       ]]];

    return self;
}

- (void)dealloc {
    [_playersUpdater clear];
    [_touchResponders removeAllObjects];

    [_playersLayer removeFromParent];
    [_enemiesLayer removeFromParent];
}

- (CGPoint)center {
    return mzpFromSizeAndFactor(self.size, 0.5);
}

- (void)addTouchResponder:(id<MZTouchResponder>)touchResponder {
    [_touchResponders addObject:touchResponder];
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

            [playerCollider collidesAnother:ebCollider];
        }
    }

    [_playersUpdater update];
    [_enemiesUpdater removeInactives];
    [_enemyBulletsUpdater removeInactives];

    NSUInteger a = _enemyBulletsLayer.nodesPool.numberOfAvailable;
    NSUInteger b = _enemyBulletsLayer.nodesPool.numberOfElements;

    _message.text = [NSString stringWithFormat:@"%lu/%lu", a, b];
}

@end

@implementation GameScene (_)

- (void)_init {
    _debugLayer = [SKNode node];

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

- (void)_setPlayerLayer {
    _playersLayer = [MZSpritesLayer newWithAtlasName:@"player.atlas" nodesNumber:10];
    [_playersLayer
        addAnimationWithTextureNames:@[ @"fairy-walk-down-001", @"fairy-walk-down-002", @"fairy-walk-down-003" ]
                                name:@"fairy-walk-down"
                         oneLoopTime:0.5];

    [_playersLayer
        addAnimationWithTextureNames:@[ @"fairy-walk-left-001", @"fairy-walk-left-002", @"fairy-walk-left-003" ]
                                name:@"fairy-walk-left"
                         oneLoopTime:0.5];

    [_playersLayer
        addAnimationWithTextureNames:@[ @"fairy-walk-right-001", @"fairy-walk-right-002", @"fairy-walk-right-003" ]
                                name:@"fairy-walk-right"
                         oneLoopTime:0.5];

    [_playersLayer addAnimationWithTextureNames:@[ @"fairy-walk-up-001", @"fairy-walk-up-002", @"fairy-walk-up-003" ]
                                           name:@"fairy-walk-up"
                                    oneLoopTime:0.5];

    [self addChild:_playersLayer];
}

- (void)_setEnemiesLayer {
    _enemiesLayer = [MZSpritesLayer newWithAtlasName:@"enemies.atlas" nodesNumber:100];
    [_enemiesLayer addAnimationWithTextureNames:@[
                                                   @"Bow_normal0001",
                                                   @"Bow_normal0002",
                                                   @"Bow_normal0003",
                                                   @"Bow_normal0004",
                                                   @"Bow_normal0005",
                                                   @"Bow_normal0006",
                                                   @"Bow_normal0007",
                                                   @"Bow_normal0008",
                                                   @"Bow_normal0009",
                                                   @"Bow_normal0010",
                                                   @"Bow_normal0011",
                                                   @"Bow_normal0012"
                                                ]
                                           name:@"Bow"
                                    oneLoopTime:0.1];

    [_enemiesLayer addAnimationWithTextureNames:
                       @[ @"monster_blue_0001", @"monster_blue_0002", @"monster_blue_0003", @"monster_blue_0004" ]
                                           name:@"monster_blue"
                                    oneLoopTime:0.1];

    [_enemiesLayer addAnimationWithTextureNames:
                       @[ @"monster_green_0001", @"monster_green_0002", @"monster_green_0003", @"monster_green_0004" ]
                                           name:@"monster_green"
                                    oneLoopTime:0.1];

    [_enemiesLayer addAnimationWithTextureNames:
                       @[ @"monster_red_0001", @"monster_red_0002", @"monster_red_0003", @"monster_red_0004" ]
                                           name:@"monster_red"
                                    oneLoopTime:0.1];

    [_enemiesLayer addAnimationWithTextureNames:@[
                                                   @"ship_0001",
                                                   @"ship_0002",
                                                   @"ship_0003",
                                                   @"ship_0004",
                                                   @"ship_0005",
                                                   @"ship_0006",
                                                   @"ship_0007",
                                                   @"ship_0008",
                                                   @"ship_0009",
                                                   @"ship_0010"
                                                ]
                                           name:@"ship"
                                    oneLoopTime:0.1];

    [self addChild:_enemiesLayer];
}

- (void)_setEnemyBulletsLayer {
    _enemyBulletsLayer = [MZSpritesLayer newWithAtlasName:@"enemy_bullets" nodesNumber:500];
    [self addChild:_enemyBulletsLayer];
}

- (void)_setPlayer {
    _playersUpdater.actionTime = _playerActionTime;
    MZActor *player = [_playersUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [player addActionWithClass:[MZNodes class] name:@"nodes"];
    SKSpriteNode *sprite =
        (SKSpriteNode *)
        [nodes addNode:[_playersLayer spriteWithForeverAnimationName:@"fairy-walk-up"] name:@"body"].node;
    [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:self] name:@"touch-relative-move"];
    player.position = mzpAdd([self center], mzp(0, -200));
    player.rotation = 90;

    MZSpriteCircleCollider *collider =
        [player addAction:[MZSpriteCircleCollider newWithSprite:sprite offset:MZPZero collisionScale:1.0]
                     name:@"collider"];
    [collider addDebugDrawNodeWithParent:_debugLayer color:[UIColor redColor]];
}

- (void)_setEnemies {
    MZActor *enemy = [_enemiesUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [enemy addAction:[MZNodes new] name:@"nodes"];
    [nodes addNode:[_enemiesLayer spriteWithForeverAnimationName:@"Bow"] name:@"body"];

    MZAttack_NWayToDirection *a = [enemy addAction:[MZAttack_NWayToDirection newWithAttacker:enemy] name:@"attack"];
    a.bulletGenFunc = [self __test_enemy_bullet_func];
    a.colddown = 0.2;
    a.interval = 5;
    a.numberOfWays = 5;
    a.targetDirection = 270;
    a.bulletVelocity = 100;
    a.bulletScale = 0.5;
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
        [nodes addNode:[_enemyBulletsLayer spriteWithTextureName:@"fireball.png"] name:@"body"];

        SKSpriteNode *bodySprite = (SKSpriteNode *)[nodes nodeWithName:@"body"];

        MZSpriteCircleCollider *collider =
            [b addAction:[MZSpriteCircleCollider newWithSprite:bodySprite offset:MZPZero collisionScale:0.5]
                     name:@"collider"];

        __mz_gen_weak_block(weak, b);
        collider.collidedAction = ^(MZSpriteCircleCollider *c) {
            [weak setActive:false];
        };

        [collider addDebugDrawNodeWithParent:dl color:[UIColor greenColor]];

        return b;
    };
}

- (void)__test_random_put_sprites {
    CGPoint (^randPos)() = ^{
        return mzp([MZMath randomIntInRangeMin:0 max:self.size.width],
                   [MZMath randomIntInRangeMin:0 max:self.size.height]);
    };

    void (^randPut)() = ^{
        NSString *n = [MZCollections randomPickInArray:_enemiesLayer.animationNames];
        SKSpriteNode *s = [_enemiesLayer spriteWithForeverAnimationName:n];
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