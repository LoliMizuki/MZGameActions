#import "GUILayer.h"
#import "GameScene.h"
#import "MZGameHeader.h"
#import "AnotherScene.h"

@interface GUILayer (_)
- (void)_setGUIComponents;
@end



@implementation GUILayer {
    SKLabelNode *_message;
}

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    GUILayer *l = [GUILayer new];
    l.gameScene = gameScene;
    [l _setGUIComponents];
    [gameScene addChild:l];

    return l;
}

- (void)dealloc {
    if ([self hasActions]) [self removeAllActions];
    //    [self removeAllChildren];
    gameScene = nil;
}

- (void)update {
    NSUInteger a = [gameScene spritesLayerWithName:@"player-bullets"].nodesPool.numberOfAvailable;
    NSUInteger b = [gameScene spritesLayerWithName:@"player-bullets"].nodesPool.numberOfElements;
    _message.text = [NSString
        stringWithFormat:@"%lu/%lu\nformation: %lu", b - a, b, gameScene.eventsExecutor.updatingAciotns.count];
}

@end

@implementation GUILayer (_)

- (void)_setGUIComponents {
    MZAssertIfNilWithMessage(gameScene, @"give me gameScene first");

    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"yuyurect"];
    backButton.position = mzpAdd(mzp(gameScene.size.width, gameScene.size.height), mzp(-40, -60));
    [backButton setScale:0.5];
    [self addChild:backButton];

    __mz_gen_weak_block(wbScene, gameScene);
    [backButton addTouchType:kMZTouchType_Began
                 touchAction:^(NSSet *touches, UIEvent *event) {
                     SKView *view = wbScene.view;
                     [view presentScene:[AnotherScene sceneWithSize:wbScene.size]
                             transition:[SKTransition crossFadeWithDuration:.5]];
                 }];


    SKLabelNode *pauseButton = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    pauseButton.text = @"Pause";
    [pauseButton setScale:0.5];
    pauseButton.position = mzpAdd(mzp(0, wbScene.size.height), mzp(60, -60));
    [pauseButton addTouchType:kMZTouchType_Began
                  touchAction:^(NSSet *touches, UIEvent *event) {
                      wbScene.playerActionTime.timeScale = (wbScene.playerActionTime.timeScale == 0) ? 1 : 0;
                  }];
    [self addChild:pauseButton];

    _message = [SKLabelNode labelNodeWithFontNamed:@"Arail"];
    _message.position = mzp(gameScene.size.width / 2, 20);
    [self addChild:_message];
}
@end
