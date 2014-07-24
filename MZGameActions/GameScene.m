#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"
#import "SetLayers.h"
#import "SetPlayer.h"
#import "PlayerBulletCreateFuncs.h"
#import "EnemyCreateFuncs.h"
#import "EnemyBulletCreateFuncs.h"
#import "ActorUpdaters.h"
#import "ActorCreateFuncs.h"
#import "GUILayer.h"

#import "TestScenario.h"

@interface GameScene (_)
- (void)_init;
@end

@implementation GameScene {
    NSMutableDictionary *_spritesLayerDict;
    NSMutableArray *_touchResponders;
}

@synthesize playerActionTime;
@synthesize gameBound;
@synthesize actorCreateFuncs;
@synthesize actorUpdaters;
@synthesize player;
@synthesize eventsExecutor;
@synthesize guiLayer, debugLayer;

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    [self _init];

    actorUpdaters = [ActorUpdaters newWithGameScene:self];
    actorUpdaters.players.actionTime = playerActionTime;
    actorUpdaters.playerBullets.actionTime = playerActionTime;
    actorUpdaters.enemies.actionTime = playerActionTime;
    actorUpdaters.enemyBullets.actionTime = playerActionTime;

    [[SetLayers newWithScene:self] setLayersFromDatas];
    actorCreateFuncs = [ActorCreateFuncs newWithScene:self];

    [[SetPlayer newWithScene:self] setPlayer];

    guiLayer = [GUILayer newWithScene:self];

    [[TestScenario newWithGameScene:self] setScenario];

    if (debugLayer != nil) [self addChild:debugLayer];

    return self;
}

- (void)dealloc {
    MZLog(@"YES ... ");

    [self removeAllActions];

    [guiLayer removeFromParent];

    [actorUpdaters removeAllActors];

    [_touchResponders removeAllObjects];

    for (SKNode *l in _spritesLayerDict.allValues) [l removeFromParent];
    [_spritesLayerDict removeAllObjects];
}

- (CGPoint)center {
    return mzpFromSizeAndFactor(self.size, 0.5);
}

- (MZActor *)player {
    return actorUpdaters.players.updatingAciotns[0];
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

    [eventsExecutor update];
    [actorUpdaters update];

    [eventsExecutor removeInactiveActions];
    [actorUpdaters removeInactiveActors];

    [guiLayer update];
}

@end

@implementation GameScene (_)

- (void)_init {
    _spritesLayerDict = [NSMutableDictionary new];

#if LAYER_DEBUG
    debugLayer = [SKNode node];
#endif

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

    eventsExecutor = [MZActionsGroup new];
    eventsExecutor.actionTime = playerActionTime;

    _touchResponders = [NSMutableArray new];
}

@end