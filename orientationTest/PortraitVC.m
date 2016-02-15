#import "PortraitVC.h"
#import "LandscapeVC.h"
#import "ContainerVC.h"

@implementation PortraitVC


#pragma mark -
#pragma mark - Orintation stuff

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark -
#pragma mark - Actions

- (IBAction)didTapButton:(UIButton *)sender
{
    [self.customContainer showViewController:[[LandscapeVC alloc] init]
                                    animated:YES
                                  completion:nil];
}

@end
