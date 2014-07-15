#import "MZAction.h"

@class SKNode;



#pragma mark - MZNodeInfo

@interface MZNodeInfo : NSObject <MZTransform>
@property (nonatomic, readwrite, weak) SKNode *node;
@property (nonatomic, readwrite) CGPoint originPosition;
@property (nonatomic, readwrite) CGPoint originScaleXY;
@property (nonatomic, readwrite) float originRotation;
@end



#pragma mark - MZNodes

@interface MZNodes : MZAction <MZTransform>
- (MZNodeInfo *)addNode:(SKNode *)node name:(NSString *)name;
- (MZNodeInfo *)nodeInfoWithName:(NSString *)name;
- (SKNode *)nodeWithName:(NSString *)name;
- (void)removeWithName:(NSString *)name;
@end
