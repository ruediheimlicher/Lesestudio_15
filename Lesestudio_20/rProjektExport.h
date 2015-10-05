/* rProjektExport */

#import <Cocoa/Cocoa.h>

@interface rProjektExport : NSWindowController
{
    IBOutlet NSMatrix* ExportVariante;
    IBOutlet id NamenString;
	IBOutlet NSTextField* TitelString;
	IBOutlet id TextString;
}
- (void)setNamenString:(NSString*)derName;
- (IBAction)reportExportVariante:(id)sender;
- (IBAction)reportAbbrechen:(id)sender;
- (IBAction)reportHelp:(id)sender;
@end
