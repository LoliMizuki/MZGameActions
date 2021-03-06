//
//  ViewController.m
//  MZGameActions
//
//  Created by Inaba Mizuki on 2014/6/30.
//  Copyright (c) 2014年 Inaba Mizuki. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"
#import "AnotherScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    skView.frameInterval = 2;

    // Create and configure the scene.
    SKScene *scene = [AnotherScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
