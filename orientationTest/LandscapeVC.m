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


#pragma mark -
#pragma mark - Orintation stuff

- (IBAction)didTapButton:(UIButton *)sender
{
    [self.customContainer showViewController:[[PortraitVC alloc] init]
                                    animated:YES
                                  completion:nil];
}

@end
