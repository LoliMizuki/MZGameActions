#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"

@interface GameScene (_)
- (void)_setPlayerLayer;
- (void)_setEnemiesLayer;

- (void)_setPlayer;

- (void)_setGUIs;

- (void)__test_random_put_sprites;
- (void)__test_change_player_actionTime;
@end



@implementation GameScene {
    MZActionTime *_playerActionTime;

    MZSpritesLayer *_playersLayer;
    MZSpritesLayer *_enemiesLayer;

    MZActionsGroup *_playersUpdater;

    NSMutableArray *_touchResponders;
}

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    _touchResponders = [NSMutableArray new];
    _playersUpdater = [MZActionsGroup new];

    [self _setPlayerLayer];
    [self _setEnemiesLayer];
    [self _setPlayer];

    [self _setGUIs];

    //    [self __test_random_put_sprites];
    [self __test_change_player_actionTime];

    return self;
}

- (void)dealloc {
    [_playersUpdater clear];
    [_touchResponders removeAllObjects];

    [_playersLayer removeFromParent];
    [_enemiesLayer removeFromParent];

    MZLog(@"game scene");
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

    [_playersUpdater removeInactives];
}

@end

@implementation GameScene (_)

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

- (void)_setPlayer {
    _playerActionTime = [MZActionTime new];
    _playerActionTime.name = @"player";

    _playersUpdater.actionTime = _playerActionTime;
    MZActor *player = [_playersUpdater addImmediate:[MZActor new]];

    MZNodes *nodes = [player addActionWithClass:[MZNodes class] name:@"nodes"];
    [nodes addNode:[_playersLayer spriteWithForeverAnimationName:@"fairy-walk-up"] name:@"body"];
    [player addAction:[MZTouchRelativeMove newWithMover:player touchNotifier:self] name:@"touch-relative-move"];
    player.position = mzpAdd([self center], mzp(0, -200));
    player.rotation = 90;

    // move test
    MZMoveTurnToDirection *mtd = [player addAction:[MZMoveTurnToDirection newWithMover:player] name:@"move"];
    mtd.velocity = 100;
    //    m.acceleration = 100;
    mtd.direction = 45;
    mtd.turnToDirection = 135;
    mtd.turnDegreesPerSecond = 40;

    //    MZMoveWithVelocityDirection *mm = [player addAction:[MZMoveWithVelocityDirection newWithMover:player]
    // name:@"move"];
    //    mm.velocity = 100;
    //    mm.direction = 90;
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

- (void)__test_change_player_actionTime {
    [self
        runAction:
            [SKAction
                sequence:@[
                            [SKAction waitForDuration:1],
                            [SKAction runBlock:^{
                                MZLog(@"switch to at 2");
                                _playersUpdater.actionTime.timeScale = 0;
                                //                                      MZLog(@"_playersUpdater.name = %@",
                                // _playersUpdater.actionTime.name);
                                //                                      MZActor *p = _playersUpdater.updatingAciotns[0];
                                //                                      MZLog(@"player.name = %@", p.actionTime.name);
                                //                                      MZAction *move = [p actionWithName:@"move"];
                                //                                      MZLog(@"move.name = %@", move.actionTime.name);
                                //                                              _playerActionTime.timeScale = 10;
                            }]
                         ]]];
}

@end