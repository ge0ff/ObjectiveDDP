#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "MeteorClient.h"
#import "ObjectiveDDP.h"
#import <ObjectiveDDP/MeteorClient.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.meteorClient = [[MeteorClient alloc] init];
    [self.meteorClient addSubscription:@"things"];
    [self.meteorClient addSubscription:@"lists"];
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController"
                                                                                 bundle:nil];
    loginController.meteor = self.meteorClient;
    ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"wss://ddptester.meteor.com/websocket"
                                                       delegate:self.meteorClient];
    // local testing
    //ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"ws://localhost:3000/websocket"
    //                                                   delegate:self.meteorClient];

    self.meteorClient.ddp = ddp;
    self.meteorClient.authDelegate = loginController;
    [self.meteorClient.ddp connectWebSocket];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.meteorClient.ddp connectWebSocket];
}

@end
