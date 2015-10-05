#import "rProjektExport.h"

@implementation rProjektExport
- (id) init
{
	self=[super initWithWindowNibName:@"RPProjektExport"];
	return self;
}

- (void)awakeFromNib
{
	NSColor * TitelFarbe=[NSColor blueColor];
	NSFont* TitelFont;
	TitelFont=[NSFont fontWithName:@"Helvetica" size: 24];
	[TitelString setFont:TitelFont];
	[TitelString setTextColor:TitelFarbe];
	NSFont* TextFont;
	TextFont=[NSFont fontWithName:@"Helvetica" size: 14];
	[TextString setFont:TextFont];
	[ExportVariante setFont:TextFont];
	
}

- (void)setNamenString:(NSString*)derName
{
	[NamenString setStringValue:derName];
   
}
- (IBAction)reportExportVariante:(id)sender
{
	[NSApp stopModalWithCode:1];
	long var=[[ExportVariante selectedCell]tag];
   int anzahl = 2;
	NSNumber* VariantenNummer=[NSNumber numberWithLong:var];
	NSMutableDictionary* VariantenDic=[NSMutableDictionary dictionaryWithObject:VariantenNummer forKey:@"exportvariante"];
   [VariantenDic setObject:[NSNumber numberWithInt:anzahl] forKey:@"exportanzahl"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"ProjektExportOption" object:self userInfo:VariantenDic];
   
}
- (IBAction)reportHelp:(id)sender
{
   NSLog(@"reportHelp");
   NSAlert *NamenWarnung = [[NSAlert alloc] init];
   [NamenWarnung addButtonWithTitle:@"OK"];
   //[RecorderWarnung addButtonWithTitle:@"Cancel"];
   [NamenWarnung setMessageText:@"Projekt exportieren"];
   [NamenWarnung setInformativeText:@"Das Projekt wird in einen Ordner mit dem Projektnamen exportiert. Die Aufnahmem werden in einen Ordner pro Lesernamen abgelegt."];
   [NamenWarnung setAlertStyle:NSInformationalAlertStyle];
   [NamenWarnung runModal];
   return;

}


- (IBAction)reportAbbrechen:(id)sender
{
	   [NSApp stopModalWithCode:0];
}
@end
