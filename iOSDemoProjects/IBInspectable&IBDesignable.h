//
//  IBInspectable&IBDesignable.h
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//




/**Resorces**
 *https://developer.apple.com/library/ios/recipes/xcode_help-IB_objects_media/Chapters/CreatingaLiveViewofaCustomObject.html
 *http://nshipster.com/ibinspectable-ibdesignable/
 */

/**
 
 When you add the IB_DESIGNABLE attribute to the class declaration, class extension, or category for a custom view, Interface Builder renders your custom view on the canvas. When you make changes to your code, Interface Builder rebuilds your custom view and rerenders your custom view.
 
 By using the IBInspectable attribute to declare variables as inspectable properties, you allow Interface Builder to quickly rerender your custom view as you change the values of these properties in the Attributes inspector. You can attach the IBInspectable attribute to any property in a class declaration, class extension, or category for any type that’s supported by the Interface Builder defined runtime attributes: boolean, integer or floating point number, string, localized string, rectangle, point, size, color, range, and nil.
 
 If you need to create code for a custom view that runs only in Interface Builder, call that code from the method prepareForInterfaceBuilder. For example, while designing an app that uses the iPhone camera, you might want to draw an image that represents what the camera might capture. Although it’s compiled for runtime, code called from prepareForInterfaceBuilder never gets called except by Interface Builder at design time.
 
 
 */

#import <UIKit/UIKit.h>

@interface IBInspectable_IBDesignable : UIViewController

@end
