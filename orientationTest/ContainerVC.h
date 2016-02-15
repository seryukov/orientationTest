#import <UIKit/UIKit.h>

@protocol ContainerVCDelegate;

@interface ContainerVC : UIViewController

@property (nonatomic, strong, readonly) UIViewController *currentVC;

@property (nonatomic, weak) id<ContainerVCDelegate>delegate;

- (void)showViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void(^)())completion;

@end


@protocol ContainerVCDelegate <NSObject>
@optional

- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerVC *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;
@end

@interface UIViewController (Container)

- (ContainerVC *)customContainer;

@end