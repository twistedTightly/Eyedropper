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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self startImagePickerFromViewController:self WithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Instantiates and configures the image picker if the device has an available camera
- (BOOL) startImagePickerFromViewController: (UIViewController *) controller WithDelegate:
        (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate
{
    /* First check if the device has a camera that is available 
        No longer relevant!
     */
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
//        || delegate == nil)
//    {
//        //return NO;
//    }
    
    /* Instantiate and set up the image picker */
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // Configures the picker for either image capture OR media browsing (can I have both??)
    // Indicates what media the user will be able to access via the image picker (still images, movies, or both)
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] != nil)
    {
        // The image will be selected from the camera
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // The picker will only use still images
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    } else if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] != nil) {
        // The image will be selected from the exisiting photos in the library
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // The picker will only use still images
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    } else {
        // No media types available
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES]; // iOS 5 and lower
    //[picker release]; // pre-ARC - so is this handled now?
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    // Will indicate if it is a movie or a still image by its UTI (kUTTypeImage or kUTTypeMovie)
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
