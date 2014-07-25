#import <Foundation/Foundation.h>

@class GameScene;

@interface TimeBaseLevelTestScenario : NSObject

@property (nonatomic, readwrite, weak) GameScene* gameScene;

+ (instancetype)newWithScene:(GameScene*)gameScene;
- (void)set;

@end
