#pragma mark Preferences
//icon settings
#define iconHiddenOnHomescreen PreferencesBool(@"iconHiddenOnHomescreen", YES)
#define iconHiddenInFolders PreferencesBool(@"iconHiddenInFolders", NO)
#define hiddenInSpotlight PreferencesBool(@"hiddenInSpotlight", NO)

//folder settings
#define folderHiddenOnHomescreen PreferencesBool(@"folderHiddenOnHomescreen", YES)
#define folderHiddenInFolders PreferencesBool(@"folderHiddenInFolders", NO)

//preferences
#define SETTINGS_PLIST_PATH @"/var/mobile/Library/Preferences/com.muirey03.labelhiderprefs.plist"

static NSDictionary *preferences;

static BOOL PreferencesBool(NSString* key, BOOL fallback)
{
    return [preferences objectForKey:key] ? [[preferences objectForKey:key] boolValue] : fallback;
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [preferences release];
    CFStringRef appID = CFSTR("com.muirey03.labelhiderprefs");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (!keyList) {
        NSLog(@"There's been an error getting the key list!");
        return;
    }
    preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (!preferences) {
        NSLog(@"There's been an error getting the preferences dictionary!");
    }
    CFRelease(keyList);
}

%ctor
{
    preferences = [[NSDictionary alloc] initWithContentsOfFile:SETTINGS_PLIST_PATH];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChangedCallback, CFSTR("com.muirey03.labelhiderprefs-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

#pragma mark Interfaces

@interface UIView (LabelHider)
-(id)_viewControllerForAncestor;
@end

@interface SBIconLegibilityLabelView : UIView
@end

@interface SearchUIIconView : UIView
-(id)label;
@end

@interface SBFolderTitleTextField : UIView
@end

#pragma mark Tweak

%hook SBIconLegibilityLabelView
-(void)didMoveToWindow
{
    %orig;
    //make sure our settings are checked every time the labels are shown:
    self.hidden = NO;
}

-(void)setHidden:(BOOL)arg1
{
    BOOL isFolder = [[self superview] isMemberOfClass:objc_getClass("SBFolderIconView")];
    if (!isFolder)
    {
        //label is not for a folder
        if (iconHiddenOnHomescreen)
        {
            if ([[self _viewControllerForAncestor] isMemberOfClass:objc_getClass("SBRootFolderController")] || [self _viewControllerForAncestor] == nil)
            {
                //icon is on homescreen
                arg1 = YES;
            }
        }
        if (iconHiddenInFolders)
        {
            if (![[self _viewControllerForAncestor] isMemberOfClass:objc_getClass("SBRootFolderController")] && [self _viewControllerForAncestor] != nil)
            {
                //icon is on homescreen
                arg1 = YES;
            }
        }
    }
    else
    {
        //label is for a folder
        if (folderHiddenOnHomescreen)
        {
            if ([[self _viewControllerForAncestor] isMemberOfClass:objc_getClass("SBRootFolderController")] || [self _viewControllerForAncestor] == nil)
            {
                //folder is on homescreen
                arg1 = YES;
            }
        }
    }

    %orig;
}
%end

%hook SearchUIIconView
-(void)didMoveToWindow
{
    %orig;
    //hide labels in spotlight
    ((UILabel*)[self label]).hidden = hiddenInSpotlight;
}
%end

%hook SBFolderTitleTextField
-(void)didMoveToWindow
{
    %orig;
    self.hidden = folderHiddenInFolders;
}
%end
