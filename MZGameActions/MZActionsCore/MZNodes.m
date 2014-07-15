#import <SpriteKit/SpriteKit.h>
#import "MZNodes.h"
#import "MZGameHeader.h"

#pragma mark - MZNodeInfo

@implementation MZNodeInfo

@synthesize node;

- (instancetype)init {
    self = [super init];

    self.originPosition = MZPZero;
    self.originScaleXY = MZPOne;
    self.originRotation = 0;

    return self;
}

- (void)dealloc {
    [node returnPool];
    node = nil;
}

- (void)setPosition:(CGPoint)position {
    MZAssertFalse(@"do't set me, use position");
}

- (CGPoint)position {
    return self.node.position;
}

- (void)setScaleXY:(CGPoint)scaleXY {
    MZAssertFalse(@"do't set me, use originScale");
}

- (CGPoint)scaleXY {
    return mzp(self.node.xScale, self.node.yScale);
}

- (void)setScale:(MZFloat)scale {
    MZAssertFalse(@"do't set me");
}

- (MZFloat)scale {
    return self.node.xScale;
}

- (void)setRotation:(MZFloat)rotation {
    MZAssertFalse(@"do't set me, use rotationDegrees");
}

- (MZFloat)rotation {
    return [MZMath degreesFromRadians:self.node.zRotation];
}

@end



#pragma mark - MZNodes

@interface MZNodes (_)
- (void)_updatePosition;
- (void)_updateScale;
- (void)_updateRotation;
@end

@implementation MZNodes {
    NSMutableDictionary *_nodeInfosDict;

    CGPoint _position;
    CGPoint _scaleXY;
    MZFloat _rotation;
}

- (instancetype)init {
    self = [super init];
    _nodeInfosDict = [NSMutableDictionary new];

    _position = MZPZero;
    _scaleXY = MZPOne;
    _rotation = 0;

    return self;
}

- (void)dealloc {
    [_nodeInfosDict removeAllObjects];
    _nodeInfosDict = nil;
}

- (void)setPosition:(CGPoint)p {
    _position = p;
    [self _updatePosition];
}

- (CGPoint)position {
    return _position;
}

- (void)setScaleXY:(CGPoint)s {
    _scaleXY = s;
    [self _updateScale];
}

- (CGPoint)scaleXY {
    return _scaleXY;
}

- (void)setScale:(MZFloat)s {
    self.scaleXY = mzp(s, s);
}

- (MZFloat)scale {
    MZAssert(self.scaleXY.x == self.scaleXY.y, @"x(%0.2f), y(%0.2f) is not equal", self.scaleXY.x, self.scaleXY.y);
    return self.scaleXY.x;
}

- (void)setRotation:(MZFloat)r {
    _rotation = r;
    [self _updateRotation];
    [self _updatePosition];
}

- (MZFloat)rotation {
    return _rotation;
}

- (MZNodeInfo *)addNode:(SKNode *)node name:(NSString *)name {
    MZNodeInfo *nodeInfo = [MZNodeInfo new];
    nodeInfo.node = node;

    _nodeInfosDict[name] = nodeInfo;

    return nodeInfo;
}

- (MZNodeInfo *)nodeInfoWithName:(NSString *)name {
    return _nodeInfosDict[name];
}

- (SKNode *)nodeWithName:(NSString *)name {
    MZNodeInfo *nodeIfo = [self nodeInfoWithName:name];
    return (nodeIfo != nil) ? nodeIfo.node : nil;
}

- (void)removeWithName:(NSString *)name {
    MZAssert(_nodeInfosDict[name] != nil, @"not contain this action (%@)", name);
    [_nodeInfosDict removeObjectForKey:name];
}

@end

@implementation MZNodes (_)

- (void)_updatePosition {
    [MZMapReduces mapWithArray:_nodeInfosDict.allValues
                        action:^(MZNodeInfo *nodeInfo) {
                            CGPoint offset =
                                mzp(nodeInfo.originPosition.x * _scaleXY.x, nodeInfo.originPosition.y * _scaleXY.y);
                            float resultRot = nodeInfo.node.zRotation;
                            CGPoint resultOffset = [MZMath vectorFromVector:offset mapToRadians:resultRot];

                            CGPoint resultGamePos = mzpAdd(_position, resultOffset);

                            nodeInfo.node.position = resultGamePos;
                        }];
}

- (void)_updateScale {
    [MZMapReduces mapWithArray:_nodeInfosDict.allValues
                        action:^(MZNodeInfo *nodeInfo) {
                            nodeInfo.node.xScale = nodeInfo.originScaleXY.x * _scaleXY.x;
                            nodeInfo.node.yScale = nodeInfo.originScaleXY.y * _scaleXY.y;
                        }];
}

- (void)_updateRotation {
    [MZMapReduces mapWithArray:_nodeInfosDict.allValues
                        action:^(MZNodeInfo *nodeInfo) {
                            MZFloat rot = [MZMath radiansFromDegrees:nodeInfo.originRotation + _rotation];
                            nodeInfo.node.zRotation = rot;
                        }];
}

@end
