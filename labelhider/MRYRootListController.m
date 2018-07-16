#include "MRYRootListController.h"

@implementation MRYRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)openPayPal
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/muirey03"]];
}

-(void)openTwitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Muirey03"]];
}

-(void)openTwitterTomhmoses
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/tomhmoses"]];
}
@end
