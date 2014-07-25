#import "MZFormation.h"
#import "MZGameHeader.h"

@interface MZFormation (_)
- (void)_updateSpawn;
- (void)_spawnAll;
- (void)_spawnOne;
- (void)_createActor;
@end



@implementation MZFormation {
    NSMutableArray *_spawnPositions;
    MZFloat _spawnTimeCount;
}

@synthesize newActorFunc, maxSpawnCount, interval, setActionToActorWhenSpawn;
@synthesize delay;
@synthesize currentSpawnCount;

- (instancetype)init {
    self = [super init];

    maxSpawnCount = 0;
    delay = 0.0;
    interval = 0.0;
    _spawnTimeCount = 0.0;
    _spawnPositions = [NSMutableArray new];

    return self;
}

- (void)dealloc {
    [_spawnPositions removeAllObjects];
    setActionToActorWhenSpawn = nil;
}

- (bool)isActive {
    return currentSpawnCount < maxSpawnCount;
}

- (void)addSpawnPositions:(NSArray *)spawnPositions {
    [_spawnPositions addObjectsFromArray:spawnPositions];
}

- (void)setActionToActorWhenSpawn:(MZActor *)actor {
}

- (void)start {
    [super start];
}

- (void)update {
    [super update];
    [self _updateSpawn];
}

@end

@implementation MZFormation (_)

- (void)_updateSpawn {
    if (interval <= 0) {
        [self _spawnAll];
    } else {
        [self _spawnOne];
    }
}

- (void)_spawnAll {
    for (int i = 0; i < maxSpawnCount; i++) {
        [self _createActor];
    }
}

- (void)_spawnOne {
    _spawnTimeCount -= self.deltaTime;
    if (_spawnTimeCount > 0) return;

    _spawnTimeCount += interval;
    [self _createActor];
}

- (void)_createActor {
    MZAssertIfNilWithMessage(newActorFunc, @"createFunc is nil");
    MZAssert(_spawnPositions.count > 0, @"spawnPositions is not set");

    CGPoint spawnPos = [_spawnPositions[currentSpawnCount % _spawnPositions.count] CGPointValue];

    MZActor *a = newActorFunc();
    a.position = spawnPos;

    if (setActionToActorWhenSpawn != nil) {
        setActionToActorWhenSpawn(self, a);
    } else {
        [self setActionToActorWhenSpawn:a];
    }

    currentSpawnCount++;
}

@end
