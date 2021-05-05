//
//  OBJCViewController.m
//  VerifieFramework
//
//  Created by Misha Torosyan on 9/18/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

#import "OBJCViewController.h"
#import "Example-Swift.h"
@import Verifie;

@interface OBJCViewController () <VerifieDelegate>

@property (nonatomic, strong) Verifie *verifie;

@end

@implementation OBJCViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    VerifieTextConfigs *verifieTextConfigs = [VerifieTextConfigs default];
    VerifieColorConfigs *colorConfigs = [[VerifieColorConfigs alloc] initWithDocCropperFrameColor:UIColor.redColor];
    CustomDocScannerViewController *documentScannerViewController = (CustomDocScannerViewController *)[self viewControllerWithClass:[CustomDocScannerViewController class] inStoryboard:@"Main"];
    CustomHumanDetectorViewController *humanDetectorViewController = (CustomHumanDetectorViewController *)[self viewControllerWithClass:[CustomHumanDetectorViewController class] inStoryboard:@"Main"];
    VerifieViewControllersConfigs *verifieViewControllersConfigs = [[VerifieViewControllersConfigs alloc] initWithDocumentScannerViewController:documentScannerViewController
                                                                                                                    humanDetectorViewController:humanDetectorViewController
                                                                                                                  recommendationsViewController: nil
                                                                                                                  docInstructionsViewController: nil
                                                                                                                    secondDocInfoViewController: nil];
    VerifieDocumentScannerConfigs *verifieDocumentScannerConfigs = [[VerifieDocumentScannerConfigs alloc] initWithScannerOrientation:ScannerOrientationLandscape
                                                                                                                        documentType:VerifieDocumentTypeUnknown];
    
    VerifieConfigs *extractedExpr = [[VerifieConfigs alloc] initWithLicenseKey:@"5d3f2e38-fe7c-43c6-b532-db9b57e674f8"
                                                                      personId:@"12"
                                                                  languageCode:@"ENG"
                                                                 livenessCheck:NO
                                                                   textConfigs:verifieTextConfigs
                                                                  colorConfigs:colorConfigs
                                                        viewControllersConfigs:verifieViewControllersConfigs
                                                        documentScannerConfigs:verifieDocumentScannerConfigs];
    VerifieConfigs *verifieConfigs = extractedExpr;

    self.verifie = [[Verifie alloc] initWithConfigs:verifieConfigs delegate:self];

    [self.verifie start];
}


#pragma mark - VerifieDelegate
- (void)verifie:(Verifie *)sender didFailWith:(NSError *)error {

    NSLog(@"%li: %@", (long)error.code, error.verifieUserInfo);
}

- (UIViewController * _Nonnull)viewControllerToPresent:(Verifie * _Nonnull)sender {

    return self;
}

- (void)verifie:(Verifie * _Nonnull)sender didCalculate:(VerifieScore * _Nonnull)score {
    
    NSLog(@"Score: %@", score);
}


- (void)verifie:(Verifie * _Nonnull)sender didReceive:(VerifieDocument * _Nonnull)document {
    
    NSLog(@"Document: %@", document);
}


- (UIViewController *)viewControllerWithClass:(Class)controllerClass inStoryboard:(NSString *)storyboardName {
    
    UIStoryboard *selectedStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *viewController = [selectedStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(controllerClass.self)];
    
    if (![viewController isKindOfClass:controllerClass]) {
        viewController =  nil;
    }
    
    return viewController;
}

@end
