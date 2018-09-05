//
//  ProgrammaticAppDelegate.m
//  Atlas
//
//  Created by Kevin Coleman on 2/14/15.
//
//

#import "ProgrammaticAppDelegate.h"
#import "ATLSampleConversationListViewController.h"
#import "LayerKitMock.h"
#import <Atlas/Atlas.h>
#import <LayerKit/LayerKit.h> 

static BOOL ATLIsRunningTests()
{
    return (NSClassFromString(@"XCTestCase") || [[[NSProcessInfo processInfo] environment] valueForKey:@"XCInjectBundle"]);
}

@interface ProgrammaticAppDelegate ()

@end

@implementation ProgrammaticAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    ATLUserMock *mockUser = [ATLUserMock userWithMockUserName:ATLMockUserNameBlake];
    LYRClientMock *layerClient = [LYRClientMock layerClientMockWithAuthenticatedUserID:mockUser.userID];
    
    UIViewController *controller;
    if (ATLIsRunningTests()) {
        controller = [UIViewController new];
    } else {
        // NB: only hydrate a conversation with a random user when it's not test related, to avoid odd collisions
        [[LYRMockContentStore sharedStore] hydrateConversationsForAuthenticatedUserID:layerClient.authenticatedUserID count:1];

        ATLConversationListViewController *conversationController = [ATLSampleConversationListViewController conversationListViewControllerWithLayerClient:(LYRClient *)layerClient];
        conversationController.title = @"Conversation";
        conversationController.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];

        UITabBarController *tabController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
        tabController.viewControllers = [[NSArray alloc] initWithObjects:conversationController, nil];
        controller = tabController;
        controller.view.backgroundColor = [UIColor whiteColor];
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
