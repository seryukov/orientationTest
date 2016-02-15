#import "AppDelegate.h"
#import "RootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootVC *rootVC = [[RootVC alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
