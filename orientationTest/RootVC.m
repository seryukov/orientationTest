#import "RootVC.h"
#import "PortraitVC.h"


@implementation RootVC


#pragma mark -
#pragma mark - Orintation stuff

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.customContainer.currentVC supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.customContainer.currentVC shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.customContainer.currentVC preferredInterfaceOrientationForPresentation];
}


#pragma mark -
#pragma mark - View's lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showViewController:[[PortraitVC alloc] init] animated:NO completion:nil];
}

@end
