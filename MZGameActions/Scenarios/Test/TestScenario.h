#import <Foundation/Foundation.h>

@class GameScene;

@interface TestScenario : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithGameScene:(GameScene *)gameScene;
- (void)setScenario;

@end
