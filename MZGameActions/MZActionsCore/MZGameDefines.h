#import <Foundation/Foundation.h>

#define MZFloat double

@class MZActionTime;



#pragma mark - Touch Type

typedef NS_ENUM(NSInteger, MZTouchType) { kMZTouchType_Began, kMZTouchType_Moved, kMZTouchType_Ended };



#pragma mark - MZBehaviour

@protocol MZBehaviour <NSObject>

@property (nonatomic, readwrite) MZFloat duration;
@property (nonatomic, readwrite) MZFloat timeScale;
@property (nonatomic, readwrite, strong) MZActionTime *actionTime;

@property (nonatomic, readonly) bool isActive;
@property (nonatomic, readonly) MZFloat deltaTime;
@property (nonatomic, readonly) MZFloat passedTime;

- (void)start;
- (void)update;
- (void)end;

@end



#pragma mark - MZTransform

@protocol MZTransform <NSObject>

@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) CGPoint scaleXY;
@property (nonatomic, readwrite) MZFloat scale;
@property (nonatomic, readwrite) MZFloat rotation;

@end



#pragma mark - TouchNotifier & Touc hResponder

@protocol MZTouchResponder;

@protocol MZTouchNotifier <NSObject>

- (void)addTouchResponder:(id<MZTouchResponder>)touchResponder;
- (void)removeTouchResponder:(id<MZTouchResponder>)touchResponder;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (CGPoint)positionWithTouch:(UITouch *)touch;

@end

@protocol MZTouchResponder

@property (nonatomic, readwrite, weak) id<MZTouchNotifier> touchNotifier;

- (void)touchesBegan:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;

- (void)removeFromNotifier;

@end
