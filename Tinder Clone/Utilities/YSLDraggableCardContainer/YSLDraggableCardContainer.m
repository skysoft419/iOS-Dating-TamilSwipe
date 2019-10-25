//
//  YSLDraggableCardContainer.m
//  Crew-iOS
//
//  Created by yamaguchi on 2015/10/22.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLDraggableCardContainer.h"

static const CGFloat kPreloadViewCount = 3.0f;
static const CGFloat kSecondCard_Scale = 0.98f;
static const CGFloat kTherdCard_Scale = 0.96f;
static const CGFloat kCard_Margin = 7.0f;
static const CGFloat kDragCompleteCoefficient_width_default = 0.8f;
static const CGFloat kDragCompleteCoefficient_height_default = 0.6f;

typedef NS_ENUM(NSInteger, MoveSlope) {
    MoveSlopeTop = 1,
    MoveSlopeBottom = -1
};

@interface YSLDraggableCardContainer () {
    //new
    BOOL isRight;
    BOOL shouldDelete;
    BOOL isFirstSwipeLeft;
    int draggingViewCount;
}
    
    @property (nonatomic, assign) MoveSlope moveSlope;
    @property (nonatomic, assign) CGRect defaultFrame;
    @property (nonatomic, assign) CGFloat cardCenterX;
    @property (nonatomic, assign) CGFloat cardCenterY;
    @property (nonatomic, assign) NSInteger loadedIndex;
    @property (nonatomic, assign) NSInteger currentIndex;
    @property (nonatomic, strong) NSMutableArray *currentViews;
    @property (nonatomic, assign) BOOL isInitialAnimation;
    
    @property (nonatomic, strong) NSMutableArray *deletedViews;
    @property (nonatomic, strong) UIView *container;
    
    @end

@implementation YSLDraggableCardContainer
    
- (id)init
    {
        self = [super init];
        if (self) {
            [self setUp];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardViewTap:)];
            [self addGestureRecognizer:tapGesture];
            
            draggingViewCount = 0;
            _canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionLeft;
        }
        return self;
        
        
    }
    
- (void)setUp
    {
        
        isRight = NO;
        shouldDelete = YES;
        //it is the most important line for swipe direction
        isFirstSwipeLeft = YES;
        
        
        _moveSlope = MoveSlopeTop;
        _loadedIndex = 0.0f;
        _currentIndex = 0.0f;
        _currentViews = [NSMutableArray array];
    }
    
#pragma mark -- Public
    
-(void)reloadCardContainer
    {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        [_currentViews removeAllObjects];
        [_deletedViews removeAllObjects];
        
        _currentViews = [NSMutableArray array];
        _deletedViews = [NSMutableArray array];
        
        [self setUp];
        [self loadNextView];
        _isInitialAnimation = NO;
        [self viewInitialAnimation];
    }
    
- (void)movePositionWithDirection:(YSLDraggableDirection)direction draggableView:(UIView*)draggableView isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
    {
        [self cardViewDirectionAnimation:direction draggableView:draggableView isAutomatic:isAutomatic undoHandler:undoHandler];
    }
    
- (void)movePositionWithDirection:(YSLDraggableDirection)direction draggableView:(UIView *)draggableView isAutomatic:(BOOL)isAutomatic
    {
        [self cardViewDirectionAnimation:direction draggableView:draggableView isAutomatic:isAutomatic undoHandler:nil];
    }
    
- (UIView *)getCurrentView
    {
        return [_currentViews firstObject];
    }
    
- (UIView *)getPreviousView
    {
        return [_deletedViews lastObject];
    }
    
#pragma mark -- Private
    
- (void)loadNextView
    {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardContainerViewNumberOfViewInIndex:)]) {
            NSInteger index = [self.dataSource cardContainerViewNumberOfViewInIndex:_loadedIndex];
            
            // all cardViews Dragging end
            if (index != 0 && index == _currentIndex) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerViewDidCompleteAll:)]) {
                    [self.delegate cardContainerViewDidCompleteAll:self];
                }
                return;
            }
            
            // load next cardView
            if (_loadedIndex < index) {
                
                NSInteger preloadViewCont = index <= kPreloadViewCount ? index : kPreloadViewCount;
                
                for (NSInteger i = _currentViews.count; i < preloadViewCont; i++) {
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardContainerViewNextViewWithIndex:)]) {
                        UIView *view = [self.dataSource cardContainerViewNextViewWithIndex:_loadedIndex];
                        if (view) {
                            view.tag = _loadedIndex;
                            _defaultFrame = view.frame;
                            _cardCenterX = view.center.x;
                            _cardCenterY = view.center.y;
                            
                            [self addSubview:view];
                            [self sendSubviewToBack:view];
                            [_currentViews addObject:view];
                            
                            if (i == 1 && _currentIndex != 0) {
                                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
                                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
                            }
                            
                            if (i == 2 && _currentIndex != 0) {
                                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
                                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
                            }
                            _loadedIndex++;
                        }
                        
                    }
                }
            }
            
            UIView *view = [self getCurrentView];
            if (view) {
                UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
                [view addGestureRecognizer:gesture];
                
                
                //left swipe
                UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
                swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
                [self addGestureRecognizer:swipeleft];
                
                // SwipeRight
                UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
                swiperight.direction=UISwipeGestureRecognizerDirectionRight;
                [self addGestureRecognizer:swiperight];
            }
            
            if(_currentViews.count<2) return;
            
            UIView *view1 = (UIView*)_currentViews[1];
            if (view1) {
                UIPanGestureRecognizer *gesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
                [view1 addGestureRecognizer:gesture1];
            }
        }
    }

- (void)setDefaultCardView:(UIView*)draggableView{
    UIView *superView = draggableView.superview;
    draggingViewCount--;
    if(draggingViewCount <= 0){
        [_container addSubview:superView];
        superView.frame = CGRectMake((_container.frame.size.width - superView.frame.size.width)/2, 0, superView.frame.size.width, superView.frame.size.height);
        draggingViewCount = 0;
    }
}

- (void)cardViewDirectionAnimation:(YSLDraggableDirection)direction draggableView:(UIView *)draggableView isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
    {
        if (!_isInitialAnimation) { return; }
        //    UIView *view = [self getCurrentView];
        UIView *view = draggableView;
        if (!view) { return; }
        
        __weak YSLDraggableCardContainer *weakself = self;
        if (direction == YSLDraggableDirectionDefault) {
            view.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.8
                                  delay:0.0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 view.frame = _defaultFrame;
                                 
                                 [weakself cardViewDefaultScale:view];
                             } completion:^(BOOL finished) {
                                 [weakself setDefaultCardView:view];
                             }];
            
            return;
        }
        
        if (!undoHandler) {
            [_currentViews removeObject:view];
            _currentIndex++;
            [self loadNextView];
        }
        
        if (direction == YSLDraggableDirectionRight || direction == YSLDraggableDirectionLeft || direction == YSLDraggableDirectionDown) {
            
            [UIView animateWithDuration:0.35
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 if (direction == YSLDraggableDirectionLeft) {
                                     view.center = CGPointMake(-1 * (weakself.frame.size.width), view.center.y);
                                     
                                     if (isAutomatic) {
                                         view.transform = CGAffineTransformMakeRotation(-1 * M_PI_4);
                                     }
                                 }
                                 
                                 if (direction == YSLDraggableDirectionRight) {
                                     view.center = CGPointMake((weakself.frame.size.width * 2), view.center.y);
                                     
                                     if (isAutomatic) {
                                         view.transform = CGAffineTransformMakeRotation(direction * M_PI_4);
                                     }
                                 }
                                 
                                 if (direction == YSLDraggableDirectionDown) {
                                     view.center = CGPointMake(view.center.x, (weakself.frame.size.height * 1.5));
                                 }
                                 
                                 if (!undoHandler) {
                                     [weakself cardViewDefaultScale:view];
                                 }
                             } completion:^(BOOL finished) {
                                 
                                 [weakself setDefaultCardView:view];
                                 
                                 if (!undoHandler) {
                                     [_deletedViews addObject:view];
                                     [view removeFromSuperview];
                                 } else  {
                                     if (undoHandler) {
                                         undoHandler();
                                     }
                                 }
                                 
                             }];
        }
        
        if (direction == YSLDraggableDirectionUp) {
            [UIView animateWithDuration:0.15
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 if (direction == YSLDraggableDirectionUp) {
                                     if (isAutomatic) {
                                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.03,0.97);
                                         view.center = CGPointMake(view.center.x, view.center.y + kCard_Margin);
                                     }
                                 }
                                 
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.35
                                                       delay:0.0
                                                     options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                  animations:^{
                                                      view.center = CGPointMake(view.center.x, -1 * ((weakself.frame.size.height) / 2));
                                                      [weakself cardViewDefaultScale:view];
                                                  } completion:^(BOOL finished) {
                                                      
                                                      [weakself setDefaultCardView:view];
                                                      
                                                      if (!undoHandler) {
                                                          [view removeFromSuperview];
                                                      } else  {
                                                          if (undoHandler) { undoHandler(); }
                                                      }
                                                      
                                                  }];
                             }];
        }
    }
    
    
- (void)undoSwipeCardViewDirectionAnimation {
    shouldDelete = NO;
    
    UIView *view = [self getSecondView];
    [_deletedViews removeObject:view];
    
    if (!view) { return; }
    __weak YSLDraggableCardContainer *weakself = self;
    
    view.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.40
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self addSubview:view];
                         view.frame = _defaultFrame;
                         [weakself cardViewDefaultScale:view];
                         
                     } completion:^(BOOL finished) {
                         
                         [weakself setDefaultCardView:view];
                         
                         _currentIndex--;
                         
                         NSMutableArray *_newArray = [NSMutableArray arrayWithArray:_currentViews];
                         
                         _currentViews = [[NSMutableArray alloc] init];
                         [_currentViews addObject:view];
                         [_currentViews addObjectsFromArray:_newArray];
                         
                     }];
    return;
}
    
    
- (UIView *)getSecondView
    {
        return [_deletedViews lastObject];
    }
    
- (void)cardViewUpDateScale
    {
        UIView *view = [self getCurrentView];
        
        float ratio_w = fabs((view.center.x - _cardCenterX) / _cardCenterX);
        float ratio_h = fabs((view.center.y - _cardCenterY) / _cardCenterY);
        float ratio = ratio_w > ratio_h ? ratio_w : ratio_h;
        
        if (_currentViews.count == 2) {
            if (ratio <= 1) {
                UIView *view = _currentViews[1];
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
            }
        }
        if (_currentViews.count == 3) {
            if (ratio <= 1) {
                {
                    UIView *view = _currentViews[1];
                    view.transform = CGAffineTransformIdentity;
                    view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                    view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
                }
                {
                    UIView *view = _currentViews[2];
                    view.transform = CGAffineTransformIdentity;
                    view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + ((kCard_Margin * 2) - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                    view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)),kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)));
                }
            }
        }
    }
    
- (void)cardViewDefaultScale:(UIView*)draggableView
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainderView:updatePositionWithDraggableView:draggableDirection:widthRatio:heightRatio:)]) {
            
            [self.delegate cardContainderView:self updatePositionWithDraggableView:draggableView
                           draggableDirection:YSLDraggableDirectionDefault
                                   widthRatio:0 heightRatio:0];
        }
        
        for (int i = 0; i < _currentViews.count; i++) {
            UIView *view = _currentViews[i];
            
            if (i == 0 && draggableView.tag == view.tag ) {
                view.transform = CGAffineTransformIdentity;
                view.frame = _defaultFrame;
            }
            if (i == 1 && draggableView.tag == view.tag ) {
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
            }
            if (i == 2) {
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
            }
        }
    }
    
- (void)viewInitialAnimation
    {
        for (UIView *view in _currentViews) {
            view.alpha = 0.0;
        }
        
        UIView *view = [self getCurrentView];
        if (!view) { return; }
        __weak YSLDraggableCardContainer *weakself = self;
        view.alpha = 1.0;
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5f,0.5f);
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.05f,1.05f);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.95f,0.95f);
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.1
                                                                        delay:0.0
                                                                      options:UIViewAnimationOptionCurveEaseOut
                                                                   animations:^{
                                                                       view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f,1.0f);
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       
                                                                       for (UIView *view in _currentViews) {
                                                                           view.alpha = 1.0;
                                                                       }
                                                                       
                                                                       [UIView animateWithDuration:0.25f
                                                                                             delay:0.01f
                                                                                           options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                                                        animations:^{
                                                                                            [weakself cardViewDefaultScale:view];
                                                                                        } completion:^(BOOL finished) {
                                                                                            weakself.isInitialAnimation = YES;

                                                                                        }];
                                                                   }
                                                   ];
                                              }
                              ];
                         }
         ];
    }
    
    
    // Implement Gesture Methods
    
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
    {
        if(!isFirstSwipeLeft){
            [self undoSwipeCardViewDirectionAnimation];
            shouldDelete = YES;
        }
    }
    
-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
    {
        if(isFirstSwipeLeft){
            [self undoSwipeCardViewDirectionAnimation];
            shouldDelete = YES;
        }
    }
    
#pragma mark -- Gesture Selector
    
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
    {
        if (!_isInitialAnimation) { return; }
        
        //    if(_currentIndex == 0){
//        _canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp;
//        isRight = YES;
        
        //    } else {
        //        CGPoint vel = [gesture velocityInView:[self getCurrentView]];
        //        if (vel.x > 0)
        //        {
        //            // user dragged towards the right
        //            if(isFirstSwipeLeft){
        //                _canDraggableDirection = YSLDraggableDirectionLeft;
        //
        //                if(!isRight){
        //                    if(shouldDelete){
        //                        [self undoSwipeCardViewDirectionAnimation];
        //                        gesture.enabled = NO;
        //                        return;
        //                    }
        //                }
        //            } else {
        //                _canDraggableDirection = YSLDraggableDirectionRight;
        //                isRight = YES;
        //                shouldDelete = YES;
        //            }
        //
        //        } else {
        //            // user dragged towards the left
        //            if(isFirstSwipeLeft){
        //                _canDraggableDirection = YSLDraggableDirectionLeft;
        //                isRight = YES;
        //                shouldDelete = YES;
        //
        //            } else {
        //                if(!isRight){
        //                    if(shouldDelete){
        //                        [self undoSwipeCardViewDirectionAnimation];
        //                        gesture.enabled = NO;
        //                        return;
        //                    }
        //                }
        //            }
        //        }
        //    }
        
        UIView *superView = gesture.view.superview;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //added by ping
    
            if(draggingViewCount == 0){
                _container = superView.superview;
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                CGRect frame = [_container convertRect:superView.frame toView:nil];
                superView.frame = frame;
                [window addSubview:superView];
            }
            draggingViewCount++;
            
//            if(!isRight){
//
//            } else {
                CGPoint touchPoint = [gesture locationInView:self];
                if (touchPoint.y <= _cardCenterY) {
                    _moveSlope = MoveSlopeTop;
                } else {
                    _moveSlope = MoveSlopeBottom;
                }
//            }
            
        }
        
        if (gesture.state == UIGestureRecognizerStateChanged) {
            
//            if(!isRight){
//                //return;
//
//            } else {
                CGPoint point = [gesture translationInView:self];
                CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
                
                gesture.view.center = movedPoint;
                
                [gesture.view setTransform:
                 CGAffineTransformMakeRotation((gesture.view.center.x - _cardCenterX) / _cardCenterX * (_moveSlope * (M_PI / 20)))];
                
//                [self cardViewUpDateScale];
            
                if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainderView:updatePositionWithDraggableView:draggableDirection:widthRatio:heightRatio:)]) {
                    if ([self getCurrentView]) {
                        
                        float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
                        float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
                        
                        YSLDraggableDirection direction = YSLDraggableDirectionDefault;
                        
                        if (fabs(ratio_h) > fabs(ratio_w)) {
                            
                            if (ratio_h <= 0) {
                                // up
                                if (_canDraggableDirection & YSLDraggableDirectionUp) {
                                    isFirstSwipeLeft = YES;
                                    direction = YSLDraggableDirectionUp;
                                } else {
                                    direction = ratio_w <= 0 ? YSLDraggableDirectionLeft : YSLDraggableDirectionRight;
                                }
                            } else {
                                // down
                                if (_canDraggableDirection & YSLDraggableDirectionDown) {
                                    direction = YSLDraggableDirectionDown;
                                } else {
                                    direction = ratio_w <= 0 ? YSLDraggableDirectionLeft : YSLDraggableDirectionRight;
                                }
                            }
                            
                        } else {
                            if (ratio_w <= 0) {
                                // left
                                if (_canDraggableDirection & YSLDraggableDirectionLeft) {
                                    isFirstSwipeLeft = YES;
                                    
                                    direction = YSLDraggableDirectionLeft;
                                } else {
                                    direction = ratio_h <= 0 ? YSLDraggableDirectionUp : YSLDraggableDirectionDown;
                                }
                            } else {
                                // right
                                if (_canDraggableDirection & YSLDraggableDirectionRight) {
                                    isFirstSwipeLeft = NO;
                                    
                                    direction = YSLDraggableDirectionRight;
                                } else {
                                    direction = ratio_h <= 0 ? YSLDraggableDirectionUp : YSLDraggableDirectionDown;
                                }
                            }
                            
                        }
                        
                        [self.delegate cardContainderView:self updatePositionWithDraggableView:gesture.view
                                       draggableDirection:direction
                                               widthRatio:fabs(ratio_w) heightRatio:fabsf(ratio_h)];
                    }
                }
                
                [gesture setTranslation:CGPointZero inView:self];
//            }
            
            
        }
        
        if (gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateCancelled) {
            
//            if(!isRight){
//                shouldDelete = YES;
//                gesture.enabled = YES;
//                //return;
//            } else {
                float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
                float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
                
                YSLDraggableDirection direction = YSLDraggableDirectionDefault;
                if (fabs(ratio_h) > fabs(ratio_w)) {
                    if (ratio_h < - kDragCompleteCoefficient_height_default && (_canDraggableDirection & YSLDraggableDirectionUp)) {
                        // up
                        direction = YSLDraggableDirectionUp;
                    }
                    
                    if (ratio_h > kDragCompleteCoefficient_height_default && (_canDraggableDirection & YSLDraggableDirectionDown)) {
                        // down
                        direction = YSLDraggableDirectionDown;
                    }
                    
                } else {
                    
                    if (ratio_w > kDragCompleteCoefficient_width_default && (_canDraggableDirection & YSLDraggableDirectionRight)) {
                        // right
                        direction = YSLDraggableDirectionRight;
                    }
                    
                    if (ratio_w < - kDragCompleteCoefficient_width_default && (_canDraggableDirection & YSLDraggableDirectionLeft)) {
                        // left
                        direction = YSLDraggableDirectionLeft;
                    }
                }
                
                if (direction == YSLDraggableDirectionDefault || gesture.view.tag != [self getCurrentView].tag) {
                    [self cardViewDirectionAnimation:YSLDraggableDirectionDefault draggableView:gesture.view isAutomatic:NO undoHandler:nil];
                } else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerView:didEndDraggingAtIndex:draggableView:draggableDirection:)]) {
                        [self.delegate cardContainerView:self didEndDraggingAtIndex:gesture.view.tag draggableView:gesture.view draggableDirection:direction];
                    }
//                }
            }
//            isRight = NO;
        }
        
    }
    
- (void)cardViewTap:(UITapGestureRecognizer *)gesture
    {
        if (!_currentViews || _currentViews.count == 0) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerView:didSelectAtIndex:draggableView:)]) {
            [self.delegate cardContainerView:self didSelectAtIndex:_currentIndex draggableView:gesture.view];
        }
    }
    
    @end

