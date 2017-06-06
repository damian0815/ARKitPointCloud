//
//  ViewController.m
//  AR_Test
//
//  Created by Damian Stewart on 06/06/2017.
//  Copyright © 2017 ds. All rights reserved.
//

#import "ViewController.h"
#import "PlaneNode.h"
#import "PointCloud.h"

@interface ViewController () <ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (strong, atomic, readwrite) PointCloud* pointCloud;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
    
    // Create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    
    // Set the scene to the view
    self.sceneView.scene = scene;
	[self.sceneView.session setDelegate:self];
	
	self.pointCloud = [[PointCloud alloc] initWithPointMaterial:[self materialWithName:@"pointCloudSphereMaterial"]];
	[scene.rootNode addChildNode:self.pointCloud];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
	configuration.planeDetection = ARPlaneDetectionHorizontal;
    
    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate


// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
	if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
		return nil;
	}
	
	ARPlaneAnchor* plane = (ARPlaneAnchor*)anchor;
	SCNMaterial* mat = [self materialWithName:@"anchorPlaneMaterial"];
	PlaneNode* node = [[PlaneNode alloc] initWithMaterial:mat];
	[node updateShapeNodeWithAnchor:plane];
	
    return node;
}

- (SCNMaterial*)materialWithName:(NSString*)name
{
	SCNNode* shipNode = [self findNodeNamed:@"_materials" startingFrom:self.sceneView.scene.rootNode];
	SCNGeometry* ship = shipNode.geometry;
	for (SCNMaterial* mat in ship.materials) {
		if ([mat.name isEqualToString:name]) {
			return mat;
		}
	}
	return nil;
}

- (SCNNode*)findNodeNamed:(NSString*)name startingFrom:(SCNNode*)node
{
	if ([node.name isEqualToString:name]) {
		return node;
	}
	
	for (SCNNode* child in node.childNodes) {
		SCNNode* result = [self findNodeNamed:name startingFrom:child];
		if (result != nil) {
			return result;
		}
	}
	
	return nil;
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
	if ([node isKindOfClass:[PlaneNode class]] && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
		[(PlaneNode*)node updateShapeNodeWithAnchor:(ARPlaneAnchor*)anchor];
	}
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
	[self.pointCloud updateWithPointCloud:frame.rawFeaturePoints];
}


- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

@end
