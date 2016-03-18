#import "PortraitVC.h"
#import "LandscapeVC.h"
#import "ContainerVC.h"


@implementation LandscapeVC


#pragma mark -
#pragma mark - Orintation stuff

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(__bridge id)((void*)UIInterfaceOrientationLandscapeLeft)];
}

#pragma mark -
#pragma mark - Orintation stuff

- (IBAction)didTapButton:(UIButton *)sender
{
    [self.customContainer showViewController:[[PortraitVC alloc] init]
                                    animated:YES
                                  completion:nil];
}

@end
