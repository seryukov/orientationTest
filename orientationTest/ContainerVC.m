//
//  ContainerVC.m
//  container
//


#import "ContainerVC.h"


@interface TransitionContext: NSObject <UIViewControllerContextTransitioning>
- (instancetype)initWithFromVС:(UIViewController *)fromVС toVС:(UIViewController *)toVС containerView:(UIView *)container;
@property (nonatomic, assign, getter=isAnimated) BOOL animated;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, strong) NSDictionary *viewControllers;
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);

@property (nonatomic, weak) UIView *containerView;
@end

@interface AnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface ContainerVC ()

@property (nonatomic, strong, readwrite) UIViewController *currentVC;
@property (nonatomic, weak) UIView *contentView;

@end


@implementation ContainerVC
@synthesize currentVC = currentVC_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = (CGRect) {CGPointZero, self.view.bounds.size};
}


- (void)showViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void(^)())completion
{
    UIViewController *fromVC = self.currentVC;
    if (fromVC == toVC) {
        return;
    }
    if (!completion) {
        completion = ^{};
    }

    [fromVC willMoveToParentViewController:nil];
    [self addChildViewController:toVC];

    self.currentVC = toVC;
    toVC.view.alpha = 1;

    if (!fromVC) {
        toVC.view.frame = self.contentView.bounds;
        [self.contentView addSubview:toVC.view];
        [toVC didMoveToParentViewController:self];
        return;
    }

    id<UIViewControllerAnimatedTransitioning>animator = nil;
    if ([self.delegate respondsToSelector:@selector (containerViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
        animator = [self.delegate containerViewController:self animationControllerForTransitionFromViewController:fromVC toViewController:toVC];
    }
    toVC.view.userInteractionEnabled = NO;
    animator = animator?:[[AnimatedTransition alloc] init];
    void(^transitionCompletion)(BOOL) = ^(BOOL didComplete){
            [fromVC.view removeFromSuperview];
            [fromVC removeFromParentViewController];
            [toVC didMoveToParentViewController:self];
            toVC.view.userInteractionEnabled = YES;

        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }

        completion();
    };
    if (animated) {
        TransitionContext *transitionContext = [[TransitionContext alloc] initWithFromVС:fromVC toVС:toVC containerView:self.contentView];
        transitionContext.animated = animated;
        transitionContext.interactive = NO;
        transitionContext.completionBlock = transitionCompletion;
        [animator animateTransition:transitionContext];
    }
    else {
        [self.contentView addSubview:toVC.view];
        toVC.view.frame = self.contentView.bounds;
        transitionCompletion(YES);
    }
}

@end

@implementation TransitionContext

- (instancetype)initWithFromVС:(UIViewController *)fromVС toVС:(UIViewController *)toVС containerView:(UIView *)container
{
    NSAssert ([fromVС isViewLoaded] && fromVС.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = container;
        self.viewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromVС,
                                        UITransitionContextToViewControllerKey:toVС,
                                        };
    }
    
    return self;
}



- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

- (nullable __kindof UIViewController *)viewControllerForKey:(NSString *)key
{
    return self.viewControllers[key];
}


- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    return CGRectNull;
}
- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    return CGRectNull;
}

- (BOOL)transitionWasCancelled { return NO; }
- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

@end

@implementation AnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    [[transitionContext containerView] sendSubviewToBack:toVC.view];
    toVC.view.frame = [transitionContext containerView].bounds;
    toVC.view.alpha = 1;
    void(^animations)()= ^{
        fromVC.view.alpha = 0;
    };
    void(^completion)(BOOL)= ^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:animations completion:completion];
}

@end


@implementation UIViewController (Container)

- (ContainerVC *)customContainer
{
    if ([self isKindOfClass:[ContainerVC class]]) {
        return (ContainerVC *)self;
    }
    
    UIViewController *parent = self.parentViewController;
    
    while (! [parent isKindOfClass:[ContainerVC class]] && parent != nil) {
        parent = parent.parentViewController;
    }
    
    return (ContainerVC *)parent;
}

@end
