#import "TimeBaseLevelTestScenario.h"
#import "GameSceneActionsHeader.h"

@interface TimeBaseLevelTestScenario (_)
- (void)_addSmallStalkerAtTime:(MZFloat)time position:(CGPoint)position;
@end



@implementation TimeBaseLevelTestScenario

@synthesize gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene {
    TimeBaseLevelTestScenario *scenario = [self new];
    scenario.gameScene = gameScene;
    return scenario;
}

- (void)set {
    CGRect bound = gameScene.gameBound;
    float minX = CGRectGetMinX(bound);
    float maxX = CGRectGetMaxX(bound);
    float minY = CGRectGetMinY(bound);
    float maxY = CGRectGetMaxY(bound);

    CGPoint spawnPositions[] = {{minX, maxY},
                                {maxX, maxY},
                                {minX / 2 + maxX / 2, maxY},
                                {minX, minY + (maxY - minY) / 4 * 3},
                                {maxX, minY + (maxY - minY) / 4 * 3}};

    for (int i = 0; i < 5; i++) {
        [self _addSmallStalkerAtTime:3 * i position:spawnPositions[i]];
    }

    for (int i = 0; i < 3; i++) {
        [self _addSmallStalkerAtTime:15 position:spawnPositions[i]];
    }

    for (int i = 0; i < 5; i++) {
        [self _addSmallStalkerAtTime:18 position:spawnPositions[i]];
    }
}

@end

@implementation TimeBaseLevelTestScenario (_)

- (void)_addSmallStalkerAtTime:(MZFloat)time position:(CGPoint)position {
    MZFormation *formation = [MZFormation new];
    formation.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-stalker"];
    [formation addSpawnPositions:@[ NSValueFromCGPoint(position) ]];

    formation.maxSpawnCount = 5;
    formation.interval = 0.25;

    [gameScene.eventsExecutor
        addActionLate:[MZActionsSequence newWithActions:@[ [MZWait newWithDuration:time], formation ]]];
}

@end
