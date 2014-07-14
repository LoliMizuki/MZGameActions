#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"
#import "SetLayers.h"
#import "SetPlayer.h"
#import "PlayerBulletCreateFuncs.h"
#import "EnemyCreateFuncs.h"
#import "EnemyBulletCreateFuncs.h"
#import "ActorUpdaters.h"

@interface GameScene (_)
- (void)_init;
- (void)_setGUIs;
@end

@implementation GameScene {
    NSMutableDictionary *_spritesLayerDict;
    NSMutableArray *_touchResponders;
    SKLabelNode *_message;
}

@synthesize playerActionTime;
@synthesize playerBulletCreateFuncs, enemiesCreateFuncs, enemyBulletCreateFuncs;
@synthesize gameBound;
@synthesize actorCreateFuncs;
@synthesize actorUpdaters;
@synthesize debugLayer;

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    [self _init];

    actorUpdaters = [ActorUpdaters newWithGameScene:self];
    actorUpdaters.playersUpdater.actionTime = playerActionTime;
    actorUpdaters.playerBulletsUpdater.actionTime = playerActionTime;
    actorUpdaters.enemiesUpdater.actionTime = playerActionTime;
    actorUpdaters.enemyBulletsUpdater.actionTime = playerActionTime;

    [[SetLayers newWithScene:self] setLayersFromDatas];

    playerBulletCreateFuncs = [PlayerBulletCreateFuncs newWithScene:self];
    enemiesCreateFuncs = [EnemyCreateFuncs newWithScene:self];
    enemyBulletCreateFuncs = [EnemyBulletCreateFuncs newWithScene:self];

    [[SetPlayer newWithScene:self] setPlayer];

    [self _setGUIs];

    if (debugLayer != nil) [self addChild:debugLayer];

    [self runAction:[SKAction sequence:@[
                                          [SKAction waitForDuration:3],
                                          [SKAction runBlock:^{ [enemiesCreateFuncs funcWithName:@"the-one"](); }]
                                       ]]];
    return self;
}

- (void)dealloc {
    [self removeAllActions];
    [actorUpdaters clear];

    [_touchResponders removeAllObjects];

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

    [actorUpdaters update];

    NSUInteger a = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfAvailable;
    NSUInteger b = [self spritesLayerWithName:@"enemy-bullets"].nodesPool.numberOfElements;
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

    _touchResponders = [NSMutableArray new];

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


    SKLabelNode *pauseButton = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    pauseButton.text = @"Pause";
    [pauseButton setScale:0.5];
    pauseButton.position = mzpAdd(mzp(0, self.size.height), mzp(60, -60));
    [pauseButton addTouchType:kMZTouchType_Began
                  touchAction:^(NSSet *touches, UIEvent *event) {
                      weakSelf.playerActionTime.timeScale = (weakSelf.playerActionTime.timeScale == 0) ? 1 : 0;
                  }];
    [self addChild:pauseButton];
}

@end