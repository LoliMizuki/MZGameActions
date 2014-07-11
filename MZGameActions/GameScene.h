#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@class MZSpritesLayer;

@interface GameScene : SKScene <MZTouchNotifier>
@property (nonatomic, readonly) CGPoint center;

- (void)addSpritesLayer:(MZSpritesLayer *)layer name:(NSString *)name;
- (MZSpritesLayer *)spritesLayerWithName:(NSString *)name;
@end
