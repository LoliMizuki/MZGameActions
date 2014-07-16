#import <SpriteKit/SpriteKit.h>

@class GameScene;

@interface GUILayer : SKNode

@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene;

- (void)update;

@end
