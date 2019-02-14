//
//  UIView+CLEvents.h
//  Tomato
//
//  Created by AUG on 2018/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CLEvents)
/**
 *  添加Tap手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UITapGestureRecognizer *)addGestureTapTarget:(id)target action:(SEL)action;

/**
 *  添加Pan手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UIPanGestureRecognizer *)addGesturePanTarget:(id)target action:(SEL)action;

/**
 *  添加Pinch手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UIPinchGestureRecognizer *)addGesturePinchTarget:(id)target action:(SEL)action;

/**
 *  添加LongPress手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UILongPressGestureRecognizer *)addGestureLongPressTarget:(id)target action:(SEL)action;

/**
 *  添加Swipe手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UISwipeGestureRecognizer *)addGestureSwipeTarget:(id)target action:(SEL)action;

/**
 *  添加Rotation手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UIRotationGestureRecognizer *)addGestureRotationTarget:(id)target action:(SEL)action;

/**
 *  添加ScreenEdgePan手势事件
 *
 *  @param target 事件目标
 *  @param action 事件
 *
 *  @return 返回添加的手势
 */
- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanTarget:(id)target action:(SEL)action;



#pragma mark - Block

/**
 *  添加Tap手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UITapGestureRecognizer *)addGestureTapEventHandle:(void (^)(id sender, UITapGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Pan手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UIPanGestureRecognizer *)addGesturePanEventHandle:(void (^)(id sender, UIPanGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Pinch手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UIPinchGestureRecognizer *)addGesturePinchEventHandle:(void (^)(id sender, UIPinchGestureRecognizer *gestureRecognizer))event;

/**
 *  添加LongPress手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UILongPressGestureRecognizer *)addGestureLongPressEventHandle:(void (^)(id sender, UILongPressGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Swipe手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UISwipeGestureRecognizer *)addGestureSwipeEventHandle:(void (^)(id sender, UISwipeGestureRecognizer *gestureRecognizer))event;

/**
 *  添加Rotation手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UIRotationGestureRecognizer *)addGestureRotationEventHandle:(void (^)(id sender, UIRotationGestureRecognizer *gestureRecognizer))event;

/**
 *  添加ScreenEdgePan手势block事件
 *
 *  @param event block事件
 *
 *  @return 返回添加的手势
 */
- (UIScreenEdgePanGestureRecognizer *)addGestureScreenEdgePanEventHandle:(void (^)(id sender, UIScreenEdgePanGestureRecognizer *gestureRecognizer))event;
@end

NS_ASSUME_NONNULL_END
