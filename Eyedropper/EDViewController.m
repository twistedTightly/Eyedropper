//
//  EDViewController.m
//  Eyedropper
//
//  Created by Maribeth Rauh on 11/1/13.
//  Copyright (c) 2013 mrauh. All rights reserved.
//

#import "EDViewController.h"
#import "MobileCoreServices/UTCoreTypes.h"

@interface EDViewController ()

@end

@implementation EDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set modal presentation style for image picker presentation
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startImagePickerFromViewController:self WithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) startImagePickerFromViewController: (UIViewController *) controller WithDelegate:
        (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate
{
    // First check if the device has a camera that is available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        || delegate == nil)
    {
        NSLog(@"No image picker for you");
        return NO;
    }
    
    /* Instantiate and set up the image picker */
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // Configures the picker for either image capture OR media browsing (can I have both??)
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //UIImagePickerControllerSourceTypePhotoLibrary;
    // Indicates what media the user will be able to access via the image picker (still images, movies, or both)
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] != nil)
    {
        // The picker will only use still images
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    } else {
        // No media types were available
        return NO;
    }
    // Allows the user to crop and edit in pre-defined ways (unless custom UI used)
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = delegate;
    
    [controller presentViewController:imagePickerController animated:YES completion:nil];
    return YES;
}


#pragma mark UIImagePickerControllerDelegate Methods

// For responding to the user tapping Cancel
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES]; // iOS 5 and lower
    //[picker release]; // pre-ARC - so is this handled now?
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    // Will indicate if it is a movie and a still image by its UTI (kUTTypeImage or kUTTypeMovie)
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage;
    
    // Handle a still image capture by checking the media type
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        // Not dealing with edited images yet
//        editedImage = (UIImage *) [info objectForKey:
//                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
//        if (editedImage) {
//            imageToSave = editedImage;
//        } else {
//            imageToSave = originalImage;
//        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
    }
    
//    // Handle a movie capture
//    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
//        == kCFCompareEqualTo) {
//        
//        NSString *moviePath = [[info objectForKey:
//                                UIImagePickerControllerMediaURL] path];
//        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
//            UISaveVideoAtPathToSavedPhotosAlbum (
//                                                 moviePath, nil, nil, nil);
//        }
//    }
//    
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
