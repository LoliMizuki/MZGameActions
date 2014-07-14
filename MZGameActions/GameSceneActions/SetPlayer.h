#import <Foundation/Foundation.h>

@class GameScene;

@interface SetPlayer : NSObject
@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene;
- (void)setPlayer;
@end
