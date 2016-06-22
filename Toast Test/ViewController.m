//
//  ViewController.m
//  Toast Test
//
//  Created by Richard Stockdale on 10/05/2016.
//  Copyright © 2016 Richard Stockdale. All rights reserved.
//

#import "ViewController.h"
#import "UIView+PSPAppleToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)topTapped:(id)sender {
    [self.view makeToastWithTitle:@"Not Saved!" message:@"Lorem ipsum dolor " position:PSPToastPresentationLocationTop];
}

- (IBAction)middleTapped:(id)sender {
    [self.view makeToastWithTitle:@"Not Saved!" message:@"Lorem ipsum dolor sit amet, ea enim aperiri pertinax qui, error vidisse ne sit. Ex eum regione reformidans, et feugiat consulatu ius, ius simul deleniti delicata cu. Enim posse deterruisset ne mei, eum ad mucius oblique tractatos. Aperiri menandri te eos, ut platonem disputando vix, qui et quot scripserit. Has possit imperdiet elaboraret no, ne aliquam mnesarchum vel, per appetere persecuti instructior ex. Et veri fugit corpora sed.  Has porro nusquam vivendo eu, iusto audiam ea has. No vel " position:PSPToastPresentationLocationCentre];
}

- (IBAction)bottomTapped:(id)sender {
    [self.view makeToastWithTitle:@"Not Saved!" message:@"Lorem ipsum dolor sit amet, ea enim aperiri pertinax qui, error vidisse ne sit. Ex eum regione reformidans, et feugiat" position:PSPToastPresentationLocationBottom];
}

@end
