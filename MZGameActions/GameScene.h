#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@interface GameScene : SKScene <MZTouchNotifier>
@property (nonatomic, readonly) CGPoint center;
@end
