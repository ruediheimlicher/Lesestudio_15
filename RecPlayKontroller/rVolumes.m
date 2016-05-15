#import "rVolumes.h"

@implementation rVolumes
- (id) init
{
   //if ((self = [super init]))
   self = [super initWithWindowNibName:@"RPVolumes"];
	  {
        UserArray=[[NSMutableArray alloc] initWithCapacity: 0];
        NetworkArray=[[NSMutableArray alloc] initWithCapacity: 0];
     }
   
   LeseboxPfad=[NSString string];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(VolumepfadAktion:)
              name:@"Volumespfad"
            object:nil];
   
   return self;
}


- (void) awakeFromNib
{
	//DLog(@"rVolumes: awakeFromNib");
   [self.window setAnimationBehavior:NSWindowAnimationBehaviorNone];
	//[VolumesPopUp addItemWithTitle:@"Hallo"];
	UserDic=[[NSMutableDictionary alloc] initWithCapacity:0];
	neuerHostName=[[NSMutableString alloc] initWithCapacity:0];
	//NamenCell=[[NSTextFieldCell alloc]init];
	//[NamenCell setBackgroundColor:[NSColor redColor]];
	//[NamenCell setSelectable:NO];
	//[NamenCell setDrawsBackground:YES];
	//[[UserTable tableColumnWithIdentifier:@"namen"]setDataCell:NamenCell];
	[UserTable setDataSource:self];
	[UserTable setDelegate: self];
	
	SEL DoppelSelektor;
	DoppelSelektor=@selector(VolumeOK:);
	
//	[UserTable setDoubleAction:DoppelSelektor];
//	[UserTable reloadData];
	
	[NetworkTable setDataSource:self];
	[NetworkTable setDelegate: self];

	NSFont* RecPlayfont;
	RecPlayfont=[NSFont fontWithName:@"Helvetica" size: 36];
	NSColor * RecPlayFarbe=[NSColor cyanColor];
	[LesestudioString setFont: RecPlayfont];
	[LesestudioString setTextColor: RecPlayFarbe];

	[StartString setFont: RecPlayfont];
	[StartString setTextColor: RecPlayFarbe];
	NSFont* Titelfont;
	Titelfont=[NSFont fontWithName:@"Helvetica" size: 18];
	NSColor * TitelFarbe=[NSColor grayColor];
	
	[TitelString setFont: Titelfont];
	[TitelString setTextColor: TitelFarbe];
	NSFont* ComputerimNetzfont;
	ComputerimNetzfont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSColor * ComputerimNetzFarbe=[NSColor blueColor];
	[ComputerimNetzString setFont:ComputerimNetzfont];
	//[ComputerimNetzString setTextColor:ComputerimNetzFarbe];
	[OderString setFont:ComputerimNetzfont];
	//[OderString setTextColor:ComputerimNetzFarbe];
	NSFont* Homefont;
	Homefont=[NSFont fontWithName:@"Helvetica" size: 14];
	//[HomeKnopf setFont:Homefont];
//	NSImage* RecPlayImage = [NSImage imageNamed: @"MicroIcon"];
//	[RecPlayIcon setImage:RecPlayImage];
//	[NetzwerkDrawer setMinContentSize:NSMakeSize(100, 100)];
    //[NetzwerkDrawer setMaxContentSize:NSMakeSize(400, 400)];
   
   NSRect frame = [AuswahlenKnopf frame];
   //DLog(@"h: %2.2f",frame.size.height);
   frame.size.height = 48.0;
//   [AuswahlenKnopf  setFrame: frame];

   [SuchenKnopf setKeyEquivalent:@"\r"];
   
	[AbbrechenKnopf setToolTip:@"Programm beenden."];
	[AuswahlenKnopf setToolTip:@"Den angeklickten Benutzer auswählen."];
	[NetzwerkKnopf setToolTip:@"Öffnet ein Dialogfeld, um die Verbindung zu einen Benutzer im Netzwerk einzurichten."];
	[UserTable setToolTip:@"Liste der angemeldeten Benutzer."];
//	//DLog(@"rVolumes: awakeFromNib end");
//   [PfadwahlFeld setStringValue:@"abcdef"];
   
   [LeseboxOK setState:NSOnState];

}

- (int) anzVolumes
{
	return (int)[UserArray count];
}

- (void) setHomeStatus:(BOOL) derStatus
{
//	[HomeKnopf setEnabled:derStatus];
}
- (void) setLeseboxPfad:(NSString*)leseboxpfad
{
   [SuchenKnopf setKeyEquivalent:@""];
   [AuswahlenKnopf setKeyEquivalent:@"\r"];
   if (leseboxpfad)
   {
   [PfadFeld setStringValue:leseboxpfad];
      if ([leseboxpfad length]<5)
      {
         [AuswahlenKnopf setEnabled:NO];
      }
      else{
         [AuswahlenKnopf setEnabled:YES];
      }
   }
   [[self window]makeFirstResponder:self];
}

- (void) setLeseboxOK:(BOOL)status
{
   [AuswahlenKnopf setEnabled:status];
   if (status)
   {
      [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB present", nil)];
     // [AuswahlenKnopf setKeyEquivalent:@"\r"];
      //DLog(@"setLeseboxOK LeseboxOK setState ON vor: %ld LeseboxOK: %@",(long)[LeseboxOK state],LeseboxOK);
      //[LeseboxOK setState:NSOnState];
      //DLog(@"setLeseboxOK LeseboxOK setState ON nach: %ld",(long)[LeseboxOK state]);
  
   }
   else
   {
       [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB not present but installable", nil)];
     // [AuswahlenKnopf setKeyEquivalent:@""];
      //[LeseboxOK setState:NSOffState];
      
   }
}

- (void)setLastPfadOK:(BOOL)lastpfadok
{
 //  DLog(@"Volumes setLastPfadOK: %d",lastpfadok);
 //  [PfadwahlFeld setStringValue:NSLocalizedString(@"Last used Path", nil)];
   if (lastpfadok)
       {
          [SuchenKnopf setKeyEquivalent:@""];
          [SuchenKnopf setTitle: NSLocalizedString(@"search other LB", nil)];
       //   [AuswahlenKnopf setEnabled:YES];
         [AuswahlenKnopf setKeyEquivalent:@"\r"];
                 }
   else
   {
       [SuchenKnopf setKeyEquivalent:@"\r"];
      [SuchenKnopf setTitle: NSLocalizedString(@"search LB", nil)];

      [AuswahlenKnopf setKeyEquivalent:@""];
     // [AuswahlenKnopf setEnabled:NO];
   }
   //[LeseboxOK setState:NSOnState];

}

- (void)setPfadwahl:(NSString*)pfadwahl
{
   
  DLog(@"*Volumes setPfadLabel: %@",pfadwahl);
   [PfadwahlFeld setStringValue:pfadwahl];
  // [AuswahlenKnopf setEnabled:YES];
   //[AuswahlenKnopf setEnabled:NO];
 
}


- (void) setUserArray:(NSArray*) dieUser
{
	//NSMutableArray* tempArray=[[NSMutableArray alloc] initWithCapacity:0];
	
	if ([dieUser count])
	{
		//DLog(@"Volumes setUserArray start	dieUser anz: %d desc: %@ \n",[dieUser count],[dieUser description]);
		
		NSEnumerator* enumerator=[dieUser objectEnumerator];
		id einObjekt;
		//DLog(@"setUserArray nach Enum");
		while (einObjekt=[enumerator nextObject])
		{
			//DLog(@"setUserArray: einObjekt: %@",[einObjekt description])
			NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			int LeseboxOrt=0;
			NSNumber* LeseboxOrtNumber=[einObjekt objectForKey:@"leseboxort"];
			if (LeseboxOrtNumber)
			{
				LeseboxOrt=[LeseboxOrtNumber intValue];
				[tempUserDic setObject:LeseboxOrtNumber forKey:@"leseboxort"];
			}
			
			NSNumber* UserLeseboxOKNumber=[einObjekt objectForKey:@"userleseboxok"];
			if (UserLeseboxOKNumber)
			{
				[tempUserDic setObject:UserLeseboxOKNumber forKey:@"userleseboxok"];
			}
			
			NSNumber* VolumeLeseboxOKNumber=[einObjekt objectForKey:@"volumeleseboxok"];
			if (VolumeLeseboxOKNumber)
			{
				[tempUserDic setObject:VolumeLeseboxOKNumber forKey:@"volumeleseboxok"];
			}
			
			NSString* NetzVolumePfad=[einObjekt objectForKey:@"netzvolumepfad"];
			if (NetzVolumePfad)
			{
				[tempUserDic setObject:NetzVolumePfad forKey:@"netzvolumepfad"];
			}
			
			NSString* VolumeLeseboxPfad=[einObjekt objectForKey:@"volumeleseboxpfad"];
			if (VolumeLeseboxPfad)
			{
				[tempUserDic setObject:VolumeLeseboxPfad forKey:@"volumeleseboxpfad"];
			}
			
			NSString* UserNameString=[einObjekt objectForKey:@"username"];
			NSString* HostNameString=[einObjekt objectForKey:@"host"];
			//DLog(@"setUserArray Namen:		LeseboxOrt: %d HostNameString: %@  UserNameString: %@",LeseboxOrt,HostNameString,UserNameString);
			if (UserNameString &&[UserNameString length])
			{
				switch (LeseboxOrt)
				{
					case 0://keine Lesebox
					{
						//Noch nichts vorhanden: 
						if (HostNameString &&[HostNameString length])//&& ![HostNameString isEqualToString:UserNameString])
						{
							[tempUserDic setObject:HostNameString forKey:@"host"];
						}
						[tempUserDic setObject:UserNameString forKey:@"username"];
						
						//volumeleseboxpfad fehlt
						if ([tempUserDic objectForKey:@"netzvolumepfad"])
						{
							NSString* tempVolumeDocumentPfad=[[tempUserDic objectForKey:@"netzvolumepfad"]stringByAppendingPathComponent:@"Documents"];
							NSString* tempVolumeLeseboxPfad=[tempVolumeDocumentPfad stringByAppendingPathComponent:@"Lesebox"];
							[tempUserDic setObject:tempVolumeLeseboxPfad forKey:@"volumeleseboxpfad"];
				
							
				// **						
						//	[tempUserDic setObject:[NSNumber numberWithInt:1] forKey:@"leseboxort"]; // auf Volume
							[tempUserDic setObject:[NSNumber numberWithInt:2] forKey:@"leseboxort"]; // auf Volume
							
				// **
						}
					}break;
						
					case 1://auf Volume
					{
						[tempUserDic setObject:UserNameString forKey:@"host"];
					}break;
						
						
					case 2://in Documemts
					{
						if (HostNameString &&[HostNameString length])//&& ![HostNameString isEqualToString:UserNameString])
						{
							[tempUserDic setObject:HostNameString forKey:@"host"];
						}
						[tempUserDic setObject:UserNameString forKey:@"username"];
						
					}break;
				}//switch
				
				NSNumber* tempLeseboxOK=[einObjekt objectForKey:@"userleseboxOK"];
				NSNumber* tempVolumeLeseboxOK=[einObjekt objectForKey:@"volumeleseboxOK"];
				
				NSNumber* tempLeseboxOrt=[einObjekt objectForKey:@"leseboxort"];
				[tempUserDic setObject:tempLeseboxOrt forKey:@"userleseboxOK"];
				
				/*
				 if (tempLeseboxOK)
				 {
				 [tempUserDic setObject:tempLeseboxOK forKey:@"userleseboxOK"];
				 }
				 else if (tempVolumeLeseboxOK)
				 {
				 [tempUserDic setObject:tempVolumeLeseboxOK forKey:@"userleseboxOK"];
				 }
				 NSString* tempHostString=[einObjekt objectForKey:@"host"];
				 if (tempHostString && [tempHostString length])
				 {
				 [tempUserDic setObject:tempHostString forKey:@"host"];
				 }
				 */
				//DLog(@"tempUserDic: %@",[tempUserDic description]);
				[UserArray addObject:[tempUserDic copy]];
				//[neuerHostName setString:@""];
				//[UserDic setObject:UserNameString forKey:NamenString];
			}
			
		}//while
		//DLog(@"setUserArray nach while");
	}//count
	else
	{
		//[UserArray addObject:@"Lesebox im Netz suchen"];
		//[[[UserTable tableColumnWithIdentifier:@"volume"]dataCellForRow:0]setSelectable:NO];
		
		//[ComputerimNetzString setStringValue:@"Lesebox im Netz suchen"];
		
	}
	//DLog(@"Volumes setUserArray :	UserArray fertig: %@",[UserArray description]);
	NSString* NetzwerkString=@"Lesebox im Netz suchen";
	//[tempArray release];
	//[UserArray addObject:NetzwerkString];
//	[UserDic setObject:@"Netzwerk" forKey:NetzwerkString];
	
	[UserTable setEnabled:YES];
	

	int erfolg=[[self window]makeFirstResponder:self];

	//[AuswahlenKnopf setEnabled:YES];
	[AuswahlenKnopf setKeyEquivalent:@"\r"];
	
//	return;
	//DLog(@"Volumes setUserArray :1");
	[UserTable reloadData];
//	[VolumesPop setEnabled:NO];
	SEL DoppelSelektor;
	DoppelSelektor=@selector(VolumeOK:);
	[UserTable setDoubleAction:DoppelSelektor];
	NSEnumerator* UserEnum=[UserArray reverseObjectEnumerator];
	id einUserDic;
	BOOL keineLesebox=YES;//noch kein User mit Lesebox gefunden
	int LeseboxIndex=(int)[UserArray count];//letzte zeile
	while((einUserDic=[UserEnum nextObject])&&keineLesebox)
	{
		//DLog(@"einUserDic: %@",[einUserDic description]);
		NSNumber* tempOKNumber=[einUserDic objectForKey:@"userleseboxOK"];
		if (tempOKNumber&&[tempOKNumber boolValue])
		{
			keineLesebox=NO;
		}
		LeseboxIndex--;
	}//while
	[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:LeseboxIndex] byExtendingSelection:NO];

//	[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[UserArray count]] byExtendingSelection:NO];
	NSColor * SuchenFarbe=[NSColor blueColor];
	NSTextFieldCell* c=[[NSTextFieldCell alloc]init];
	c=	[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:[UserArray count]-1];
	[[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:(0)]setTextColor:SuchenFarbe];
	//DLog(@"Volumes setUserArray :2");
	[UserTable reloadData];
//	//DLog(@"Volumes setUserArray :end");
}

- (void)setNetworkArray:(NSArray*) derNetworkArray
{
	//NSMutableArray* tempArray=[[NSMutableArray alloc] initWithCapacity:0];
	//DLog(@"setNetworkArray start");
	if ([derNetworkArray count])
	{
		//DLog(@"setNetworkArray: %@",[derNetworkArray description]);

		NSEnumerator* enumerator=[derNetworkArray objectEnumerator];
		id einObjekt;
		while (einObjekt=[enumerator nextObject])
		{
			NSMutableDictionary* tempNetworkDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			NSString* NetworkNameString=[einObjekt objectForKey:@"networkname"];
			//DLog(@"setNetworkArray NetworkNameString: %@",NetworkNameString);
			if (NetworkNameString &&[NetworkNameString length])
			{
				[tempNetworkDic setObject:NetworkNameString forKey:@"networkname"];
				NSNumber* tempLeseboxOK=[einObjekt objectForKey:@"networkloginOK"];
				if (tempLeseboxOK)
				{
				[tempNetworkDic setObject:tempLeseboxOK forKey:@"networkloginOK"];
				}
				[NetworkArray addObject:tempNetworkDic];
				//[UserDic setObject:UserNameString forKey:NamenString];
			}
			
		}//while
		
	}//count
	else
	{
		
	}
	//DLog(@"setNetworkArray ende: %@",[NetworkArray description]);
	[NetworkTable reloadData];
	//DLog(@"setNetworkArray reloadData");
	SEL DoppelSelektor;
	/*
	DoppelSelektor=@selector(VolumeOK:);
	[UserTable setDoubleAction:DoppelSelektor];
	[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	NSColor * SuchenFarbe=[NSColor blueColor];
	NSTextFieldCell* c=[[NSTextFieldCell alloc]init];
	c=	[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:[UserArray count]-1];
	[[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:(0)]setTextColor:SuchenFarbe];
	*/
}

- (IBAction)toggleDrawer:(id)sender;
{
   if (!NetzwerkDrawer)
   {
     //NetzwerkDrawer = []
   }
   if (!NetzwerkDrawer)
   {
      return;
   }
	if ([NetzwerkDrawer state]==NSDrawerClosedState)
	{
	//	[NetzwerkDrawer close:sender];
	}
	else
	{
	//	[NetzwerkDrawer open:sender];
	}
	
	[NetzwerkDrawer toggle:sender];
}

- (IBAction)Abbrechen:(id)sender
{
	//DLog(@"Abbrechen: stopModalWithCode 0");
	NSNumber* n=[NSNumber numberWithBool:NO];
	NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
//	[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
	
    [NSApp stopModalWithCode:0];
	[[self window] orderOut:NULL];
   [NSApp terminate:self];
}

- (IBAction)HomeDirectory:(id)sender
{	
	NSString* s=@"Lesebox";
	LeseboxPfad=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:s];
	//DLog(@"LeseboxPfad: %@",[LeseboxPfad description]);
	[NSApp stopModalWithCode:3];
	//DLog(@"Home");
	NSNumber* n=[NSNumber numberWithBool:YES];
	NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
	
	//[UserTable setEnabled:NO];
	//[UserTable setEnabled:![HomeKnopf state]];
	[UserTable deselectAll:sender];
	//[OKKnopf setEnabled:[HomeKnopf state]];
}

-(void)LeseboxpfadChoosed:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	NSString* lb=@"Lesebox";
	NSString* tempLeseboxPfad;
	//DLog(@"LeseboxpfadChoosed returnCode: %d",returnCode);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[NotificationDic setObject:@"volumes" forKey:@"quelle"];
	if (returnCode==NSAlertFirstButtonReturn)
	{
		NSArray* FileArray=[panel URLs];
		tempLeseboxPfad =[[FileArray objectAtIndex:0]path]; //gewähltes "home", nur 1 Objekt in Array
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"erfolg"];
		LeseboxPfad= [tempLeseboxPfad stringByAppendingPathComponent:lb];
		[NotificationDic setObject:LeseboxPfad forKey:@"leseboxpfad"];
		
		//DLog(@"NSAlertFirstButtonReturn: tempLeseboxPfad: %@",LeseboxPfad);
	}
	if (returnCode==NSAlertSecondButtonReturn)
	{
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"erfolg"];
		//DLog(@"NSAlertSecondButtonReturn: Abbrechen");
		[LeseboxerfolgFeld setStringValue:@"An diesem Ort ist noch keine Lesebox eingerichtet."];
		//[self Markierungenreset];
		return;
	}
	
	
	// Ausgewaehlten Pfad testen
	
	NSFileManager* Filemanager= [NSFileManager defaultManager];
	BOOL istOrdner=0;
	
	// Hat der User den Pfad zu weit gewählt?
	NSRange r=[tempLeseboxPfad rangeOfString:lb];
	
	if (r.location < NSNotFound) // Lesebox ist im Pfad, weitere Komponenten abschneiden
	{
		while ([tempLeseboxPfad rangeOfString:lb].location < NSNotFound)
		{
			tempLeseboxPfad= [tempLeseboxPfad stringByDeletingLastPathComponent];
			//DLog(@"tempLeseboxPfad: %@",tempLeseboxPfad);
		}//while
		LeseboxPfad= [tempLeseboxPfad stringByAppendingPathComponent:lb];
		//DLog(@"LeseboxPfad: %@",LeseboxPfad);
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"erfolg"];
		[LeseboxerfolgFeld setStringValue:@"An diesem Ort ist eine Lesebox eingerichtet."];
		[NotificationDic setObject:LeseboxPfad forKey:@"leseboxpfad"];

		//return;
	}
	// Ist es eine Lesebox?
	
	else if ([Filemanager fileExistsAtPath:[tempLeseboxPfad stringByAppendingPathComponent:lb] isDirectory:&istOrdner] && istOrdner)
	{
	
	//DLog(@"Abfrage Documents: tempLeseboxPfad: %@",tempLeseboxPfad);
		// Lesebox ist schon da
		LeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:lb];
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"erfolg"];
		[LeseboxerfolgFeld setStringValue:@"An diesem Ort ist eine Lesebox eingerichtet."];
		[NotificationDic setObject:LeseboxPfad forKey:@"leseboxpfad"];
		
	}
	else 
	{
		//DLog(@"LeseboxpfadChoosed: Leseboxpfad unvollständig:  tempLeseboxPfad: %@",tempLeseboxPfad);
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"erfolg"];
		[LeseboxerfolgFeld setStringValue:@"An diesem Ort ist noch keine Lesebox eingerichtet."];
		[NotificationDic setObject:tempLeseboxPfad forKey:@"leseboxpfad"];
	}
	[PfadFeld setStringValue:LeseboxPfad];
	
	//DLog(@"LeseboxpfadChoosed end  LeseboxPfad: %@",LeseboxPfad);
	//DLog(@"Lesebox an Pfad: %@",[[Filemanager contentsOfDirectoryAtPath:LeseboxPfad error:NULL]description]);
	[nc postNotificationName:@"Volumespfad" object:self userInfo:NotificationDic];

}




- (NSString*)chooseNetworkLeseboxPfad
{
   
   NSOpenPanel * LeseboxDialog=[NSOpenPanel openPanel];
   NSImage* OpenPanelImg=[NSImage imageNamed:@"MicroIcon120.png"];
   NSRect cellFeld = NSMakeRect(0, 0, 60, 60);
   NSImageView* OpenPanelView = [[NSImageView alloc] initWithFrame:cellFeld];
   [OpenPanelView setImage:OpenPanelImg];
   LeseboxDialog.accessoryView = OpenPanelView;
   LeseboxDialog.title = @"Lesebox suchen";
   [LeseboxDialog setCanChooseDirectories:YES];
   [LeseboxDialog setCanChooseFiles:NO];
   [LeseboxDialog setAllowsMultipleSelection:NO];
   LeseboxDialog.prompt = @"Ordner auswählen";
   [LeseboxDialog setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]]];
   NSString* s1=@"Wo ist die Lesebox zu finden?";
   NSString* s2=@"Wenn noch keine Lesebox vorhanden ist, kann sie auch nach dem Login eingerichtet werden";
   NSString* s3=@"Auswahl des Orders, in dem die Lesebox liegt oder dem die Lesebox eingerichtet werden soll";
   s3=@"";
   NSFont* TitelFont=[NSFont fontWithName:@"Helvetica" size: 24];
   NSString* DialogTitelString=[NSString stringWithFormat:@"%@\r%@\r%@",s1,s2,s3];
   //[DialogTitelString setFont:TitelFont];
   
   [LeseboxDialog setMessage:DialogTitelString];
   
   [LeseboxDialog setCanCreateDirectories:YES];
   NSString* tempLeseboxPfad;
   int LeseboxHit=0;
   
   //LeseboxHit=[LeseboxDialog runModalForDirectory:NSHomeDirectory() file:@"Network" types:NULL];
   //LeseboxHit=[LeseboxDialog runModalForDirectory:NetzPfad file:@"Network" types:NULL];
   
   [LeseboxDialog beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result)
    
    {
       
       if (result == NSModalResponseOK)
       {
          DLog(@"NSModalResponseOK pfad: %@",[[LeseboxDialog URL]path]);
         	NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:[LeseboxDialog URL] forKey:@"url"];
          [LeseboxDic setObject:[[LeseboxDialog URL]path ]forKey:@"pfad"];
         [LeseboxDic setObject:[NSNumber numberWithInt:1]forKey:@"LeseboxDa"];
          NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
          [nc postNotificationName:@"StartVolumeWahl" object:self userInfo:LeseboxDic];
 //         [PfadFeld setStringValue:[[LeseboxDialog URL]path]];
 //         [AuswahlenKnopf setEnabled:YES];
         [AuswahlenKnopf setKeyEquivalent:@"\r"];
  //        [LeseboxOK setState:1];
          neuerLeseboxPfad = [[LeseboxDialog URL]path ];
          DLog(@"Volumes neuerLeseboxPfad: %@",neuerLeseboxPfad);
          [SuchenKnopf setKeyEquivalent:@""];
          [AuswahlenKnopf setEnabled:YES];
          [AuswahlenKnopf setKeyEquivalent:@"\r"];
          BOOL isDir=NO;
          if ([neuerLeseboxPfad rangeOfString:@"Lesebox"].location < NSNotFound) // Lesebox im Pfad, Vorhandensein testen
          {
             
             if ([[NSFileManager defaultManager]fileExistsAtPath:neuerLeseboxPfad isDirectory:&isDir]) // LB ist da und ist ordner
             {
                if (isDir)
                {
                   [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB present", nil)];
                }
                else
                {
                   [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB not present", nil)];
                }
             }
          }
          else if ([[NSFileManager defaultManager]fileExistsAtPath:[neuerLeseboxPfad stringByAppendingPathComponent:@"Lesebox"] isDirectory:&isDir]) // LB ist da und ist ordner
          {
             if (isDir)
             {
                [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB present", nil)];
                
             }
             else
             {
                [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB not present", nil)];
             }
            
          }
          else // keine LB da
          {
             [LeseboxDaFeld setStringValue:NSLocalizedString(@"LB not present but installable", nil)];
          }
          [PfadFeld setStringValue:neuerLeseboxPfad];
          
         // [[self window]makeFirstResponder:AuswahlenKnopf];
          ALog(@"choose: neuerLeseboxPfad: %@",neuerLeseboxPfad);

       }
       
    }];

   /*
    [LeseboxDialog beginSheetForDirectory:NetzPfad file:NULL types:NULL
    modalForWindow:[self window]
    modalDelegate:self
    didEndSelector:@selector(LeseboxpfadChoosed: returnCode: contextInfo:)
    contextInfo:NULL];
    */
   /*
		  [Warnung beginSheetModalForWindow:AdminFenster
    modalDelegate:self
    didEndSelector:@selector(alertDidEnd: returnCode: contextInfo:)
    contextInfo:@"TextchangedWarnung"];
    
    */
   
   // Nicht verwendet, von CompletionHandler uebersprungen
   /*
    if (LeseboxHit==NSModalResponseOK)
    {
    tempLeseboxPfad=[[LeseboxDialog URL]path]; //gewähltes "home"
    //DLog(@"choose: LeseboxPfad roh: %@",tempLeseboxPfad);
    NSArray* tempPfadArray=[tempLeseboxPfad pathComponents];
    //DLog(@"tempPfadArray: %@",[tempPfadArray description]);
    if ([tempPfadArray count]>2)
    {
    NSArray* UserPfadArray=[tempPfadArray subarrayWithRange:NSMakeRange(0,3)];
    NSString* UserPfad=[NSString pathWithComponents:UserPfadArray];
    //DLog(@"UserPfad: %@",UserPfad);
    
    BOOL LeseboxCheck=[self checkUserAnPfad:tempLeseboxPfad];
    //DLog(@"tempLeseboxPfad: %@  LeseboxCheck: %d",tempLeseboxPfad,LeseboxCheck);
    
    }
    else
    {
    //Kein gültiger Pfad
    NSAlert *Warnung = [[NSAlert alloc] init];
    [Warnung addButtonWithTitle:@"OK"];
    [Warnung setMessageText:@"Kein gültiger Pfad"];
    [Warnung setAlertStyle:NSWarningAlertStyle];
    
    //[Warnung setIcon:RPImage];
    [Warnung runModal];
    
    tempLeseboxPfad=[NSString string];
    }
    
    }
    else//Abbrechen
    {
    //tempLeseboxPfad=[NSString string];
    //NSNumber* n=[NSNumber numberWithBool:NO];
    //NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
    //NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    //[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
    tempLeseboxPfad=[NSString string];
    
    }
    */
   return tempLeseboxPfad;
}

- (void)VolumepfadAktion:(NSNotification*)note
{
//DLog(@"VolumepfadAktion note: %@",[[note userInfo]description]);
}


- (IBAction)VolumeOK:(id)sender
{
	[NSApp stopModalWithCode:1];
	//int HomeStatus=[HomeKnopf state];
	NSString* NetzwerkString=@"Lesebox im Netz suchen";
	//DLog(@"OKSheet:  stopModalWithCode HomeStatus: %d", HomeStatus);
	//NSString* lb=@"Lesebox";
	  {
		if ([UserTable numberOfSelectedRows])
		  {
			long Zeile=[UserTable selectedRow];
			if ([UserArray objectAtIndex:Zeile]==NetzwerkString)//->Lesebox im Netz suchen
			  {
				//DLog(@"VolumeOK >Lesebox im Netz suchen");
				LeseboxPfad=[self chooseNetworkLeseboxPfad];
			  }
			else
			  {
				//Eines der Netz-Volumes mit Lesebox
				LeseboxPfad=[UserDic objectForKey:[UserArray objectAtIndex:Zeile]];
			  }
		  }
	  }
	NSNumber* n=[NSNumber numberWithBool:YES];
	NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
	
	//NSMutableDictionary* UserDic=[NSMutableDictionary dictionaryWithObject:LeseboxPfad forKey:@"LeseboxVolume"];
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"VolumeWahl" object:self userInfo:UserDic];
	return;
}

- (NSString*)LeseboxPfad
{
	return LeseboxPfad;
}

- (BOOL)istSystemVolume
{
	return istSystemVolume;
}

- (IBAction)reportOpenNetwork:(id)sender
{
   DLog(@"\nreportOpenNetwork\n\n");
   NSString* NetwerkLeseboxPfad=[self chooseNetworkLeseboxPfad];
   DLog(@"\nende reportOpenNetwork: path: %@",NetwerkLeseboxPfad);
   if (NetwerkLeseboxPfad)
   {
      NSURL* NetzURL=[NSURL fileURLWithPath:NetwerkLeseboxPfad];
      //CFStringRef=CFURLCopyHostName
      DLog(@"\nende reportOpenNetwork: URL: %@\n\n",NetzURL);
   }
   
}


- (IBAction)reportAuswahlen:(id)sender
{
	istSystemVolume=NO;
	NSString* lb=@"Lesebox";
	//DLog(@"reportAuswahlen lb: %@",lb);
   
   //DLog(@"Externe HD oder Server UserPfad: %@",UserPfad);
   
   NSString* UserPfad= [PfadFeld stringValue];
   if ([[UserPfad lastPathComponent]isEqualToString:lb])// Schon eine LB vorhanden
   {
      // Nichts anhaengen
   }
   else
   {
      UserPfad=[UserPfad stringByAppendingPathComponent:lb];
   }
   //DLog(@"Server UserPfad : %@",UserPfad);
   //DLog(@"Server LeseboxPfad vor UserPfad: %@",LeseboxPfad);
   LeseboxPfad=UserPfad;

   
   
   /*
   if ([UserTable numberOfSelectedRows])
	{
		int Zeile=[UserTable selectedRow];
		
		//DLog(@"reportAuswahlen: Zeile: %d",Zeile);
		if (Zeile==0)//home
		{
			LeseboxPfad=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
			istSystemVolume=YES;
         
         //DLog(@"reportAuswahlen: Zeile 0: LeseboxPfad: %@",LeseboxPfad);
		}
		else
		{
			NSFileManager *Filemanager=[NSFileManager defaultManager];
			//DLog(@"reportAuswahlen: Zeile: %d %@",Zeile,[[UserArray objectAtIndex:Zeile] description]);
			NSString* Username=[[UserArray objectAtIndex:Zeile]objectForKey:@"username"];
			NSString* Hostname=[[UserArray objectAtIndex:Zeile]objectForKey:@"host"];
			NSString* UserPfad=[NSString string];;
			int LeseboxOrt=[[[UserArray objectAtIndex:Zeile]objectForKey:@"leseboxort"]intValue];
         
         LeseboxOrt = 2;
         
			//DLog(@"Volumes:	LeseboxOrt: %d",LeseboxOrt);
			switch (LeseboxOrt)
			{
				case 0:
				case 1://Volume
				{
               
					if (Hostname && [Hostname length])
					{
						//UserPfad=[NSString stringWithFormat:@"/Volumes/%@",Hostname];
						UserPfad= [[UserArray objectAtIndex:Zeile]objectForKey:@"volumeleseboxpfad"];
					}
				}break;
				case 2: //Documents
				{
					if (Username && [Username length])
					{
						UserPfad=[NSString stringWithFormat:@"/Volumes/%@",Username];
					}
				}break;
               
				default:
				{
					//DLog(@"Kein geeigneter Leseboxort da");
					return;
				}
			}//switch
			
			//DLog(@"reportAuswahlen: UserPfad: %@",UserPfad);
			if ([Filemanager fileExistsAtPath:[UserPfad stringByAppendingPathComponent:@"Library"]]//ist Volume mit System
				 &&![Filemanager fileExistsAtPath:[UserPfad stringByAppendingPathComponent:@"Users"]])//ist nicht die HD oder Server
			{
				//DLog(@"Dokumente");
				istSystemVolume=YES;
				NSString* lb=@"Lesebox";
				NSString* DocumentsPfad=[NSString stringWithFormat:@"%@/Documents",UserPfad];
				LeseboxPfad=[DocumentsPfad stringByAppendingPathComponent:lb];
				
			}
			else//Externe HD
			{
				//DLog(@"Externe HD oder Server UserPfad: %@",UserPfad);
				if ([[UserPfad lastPathComponent]isEqualToString:lb])// Schon eine LB vorhanden
				{
					// Nichts anhaengen
				}
				else
				{
				UserPfad=[UserPfad stringByAppendingPathComponent:lb];
				}
				//DLog(@"Externe HD oder Server LeseboxPfad: %@",LeseboxPfad);
				LeseboxPfad=UserPfad;
			
			}
		}
	}
	
	//DLog(@"Volumes reportAuswahlen: LeseboxPfad: %@",LeseboxPfad);
	*/
	//Der Leseboxpfad wird in chooselesebox gelesen und in Leseboxvorbereiten gesetzt
	
	
   
	NSNumber* n=[NSNumber numberWithBool:YES];
	NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
	[LeseboxDic setObject:[NSNumber numberWithBool:istSystemVolume] forKey:@"istsysvol"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
	//DLog(@"LeseboxDic: %@",[LeseboxDic description]);
	//NSMutableDictionary* UserDic=[NSMutableDictionary dictionaryWithObject:LeseboxPfad forKey:@"LeseboxVolume"];
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"VolumeWahl" object:self userInfo:UserDic];[
	[NSApp stopModalWithCode:3];
   
	return;
	
}
- (IBAction)reportAnmelden:(id)sender
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	if ([NetworkTable numberOfSelectedRows])
	{
		
		
		NSMutableString* ComputerName=[[[NetworkArray objectAtIndex:[NetworkTable selectedRow]]objectForKey:@"networkname"]mutableCopy];
		//DLog(@"ComputerName: %@",ComputerName);
		[neuerHostName setString:ComputerName];
		//DLog(@"neuerHostName: %@",neuerHostName);
		[ComputerName replaceOccurrencesOfString:@"." withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [ComputerName length])];
		[ComputerName replaceOccurrencesOfString:@" " withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [ComputerName length])];
		NSArray* MV=[[NSWorkspace sharedWorkspace]mountedLocalVolumePaths];
		//int AnzUser=[MV count];
		//DLog(@"MV: %@  Anzahl: %d",[MV description], AnzUser);
		BOOL istOK=NO;
		NSString* afpString=@"afp://";
		NSString* ComputerNameString=[[afpString stringByAppendingString:ComputerName]stringByAppendingString:@".local"];
		//NSString* ComputerNameString=[afpString stringByAppendingString:ComputerName];
		//DLog(@"ComputerNameString: %@",[ComputerNameString description]);
		
		//istOK=[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:@"afp://g4"]];
		//istOK=[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:@"afp://g4/ruediheimlicher/Dokumente/Lesebox/Archiv"]];
		NSURL* ComputerURL=[NSURL URLWithString:ComputerNameString];
		NSURLRequest* ComputerRequest = [NSURLRequest requestWithURL:ComputerURL]; 
		NSData* ComputerData = [NSMutableData data];
		NSURLConnection *ComputerConnection; 
		ComputerConnection=[NSURLConnection connectionWithRequest:ComputerRequest 
														 delegate:self]; 
		//[ComputerConnection retain];
		istOK=[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:ComputerNameString]];
		if (istOK)
		{	
			[neuerHostName setString:ComputerName];
			
			NSString* neuerUserDocumentsPfad=[NSString stringWithFormat:@"/Volumes/%@/Documents",ComputerName];
			//DLog(@"ComputerNameString: %@",[neuerUserDocumentsPfad description]);
			[PrufenKnopf setEnabled:YES];
			[AnmeldenKnopf setEnabled:NO];
			NSNumber* LoginOK=[NSNumber numberWithBool:YES];
			[[NetworkArray objectAtIndex:[NetworkTable selectedRow]]setObject:LoginOK forKey:@"networkloginOK"];
			[NetworkTable reloadData];
		}
		else
			//DLog(@"openURL: nichts");
			[AnmeldenKnopf setEnabled:NO];
		//DLog(@"reportAnmelden: neuerHostName: %@",neuerHostName);
	}
	
	
}

- (IBAction)checkUser:(id)sender
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	
	NSMutableArray* neueMountedVols=(NSMutableArray *)[[NSWorkspace sharedWorkspace]mountedLocalVolumePaths];//Liste der gemounteten Vols
	long anz=[neueMountedVols count];
	[neueMountedVols removeObject:@"/"];
	[neueMountedVols removeObject:@"/Network"];
	//DLog(@"neueMountedVols: %@ anz: %ld  neuer Hostname: %@",[neueMountedVols description],anz,neuerHostName);
	//DLog(@"UserArray: %@",[UserArray description]);
	if ([neueMountedVols count])
	{
		NSEnumerator* MVEnum=[neueMountedVols objectEnumerator];
		id einUser;
		while (einUser=[MVEnum nextObject])//mounted Volumes
		{
			NSString* tempMountedUserName=[einUser lastPathComponent];//Name des Users in neueMountedVols
			BOOL NameIstNeu=YES;
			NSEnumerator* UserArrayEnum=[UserArray objectEnumerator];//Array der schon vorhandenen User
			id einDic;
			while (einDic=[UserArrayEnum nextObject])
			{
				NSString* UserNameString=[einDic objectForKey:@"username"];
			//	NSString* HostNameString=[einDic objectForKey:@"host"];
				//DLog(@"UserNameString: %@  HostNameString: %@",UserNameString,HostNameString);
				if (UserNameString)
				{
					if ([UserNameString isEqualToString:tempMountedUserName])
					//&&[HostNameString isEqualTo: neuerHostName])//neuer User ist schon in UserArray
					{
						NameIstNeu=NO;
					}
				}//if UserNameString
				
			}//while UserArrayEnum
			
			if (NameIstNeu)
			{
				NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[tempUserDic setObject:tempMountedUserName forKey:@"username"];
				if ([neuerHostName length])
				{
					[tempUserDic setObject:[neuerHostName copy] forKey:@"host"];
				}
				else
				{
					[tempUserDic setObject:@"-" forKey:@"host"];
				}
				BOOL LeseboxOK=NO;
				NSString* lb=@"Lesebox";
				NSString* tempPfad=[[einUser stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
				//DLog(@"tempPfad: %@",tempPfad);
				if ([Filemanager fileExistsAtPath:tempPfad])
				{
					LeseboxOK=YES;
				}
				[tempUserDic setObject:[NSNumber numberWithBool:LeseboxOK] forKey:@"userleseboxOK"];
				//DLog(@"checkUsert: add tempUserDic: %@",[tempUserDic description]);
				[UserArray addObject:tempUserDic];
				[UserTable reloadData];
				[neuerHostName setString:@""];
			}//if NameIstNeu
			
		}//while MVEnum
		
		
	}//count
	[PrufenKnopf setEnabled:NO];
	[AnmeldenKnopf setEnabled:YES];
	//[AuswahlenKnopf setEnabled:YES];

	[[self window]makeFirstResponder:UserTable];
	//DLog(@"checkUser: %@",[UserArray description]);
	
}

- (BOOL)checkUserAnPfad:(NSString*)derUserPfad
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	LeseboxPfad=[NSString string];
	NSString* tempUserPfad=[derUserPfad copy];
	NSString* tempMountedUserName=[tempUserPfad lastPathComponent];//Name des Netzwerk-Users in derUserPfad
	BOOL NameIstNeu=YES;
	NSEnumerator* UserArrayEnum=[UserArray objectEnumerator];//Array der schon vorhandenen User
	id einDic;
	while (einDic=[UserArrayEnum nextObject])
	{
		NSString* UserNameString=[einDic objectForKey:@"username"];
		NSString* HostNameString=[einDic objectForKey:@"host"];
		//DLog(@"UserNameString: %@  HostNameString: %@",UserNameString,HostNameString);
		if (UserNameString)
		{
			if ([UserNameString isEqualToString:tempMountedUserName])
			//&&[HostNameString isEqualTo: neuerHostName])//neuer User ist schon in UserArray
			{
				NameIstNeu=NO;//User ist schon in der Liste
			}
		}//if UserNameString
		
	}//while UserArrayEnum
	BOOL LeseboxOK=NO;
	if (NameIstNeu)
	{
		NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[tempUserDic setObject:tempMountedUserName forKey:@"username"];
		if ([neuerHostName length])
		{
			[tempUserDic setObject:[neuerHostName copy] forKey:@"host"];
		}
		else
		{
			[tempUserDic setObject:@"-" forKey:@"host"];
		}
	
		[tempUserDic setObject:tempMountedUserName forKey:@"host"];
	
		NSString* lb=@"Lesebox";
		[tempUserDic setObject:[NSNumber numberWithInt:0] forKey:@"leseboxort"];
		NSString* tempUserLeseboxPfad=[tempUserPfad stringByAppendingPathComponent:lb];
		//DLog(@"tempUserLeseboxPfad: %@",tempUserLeseboxPfad);

		if ([Filemanager fileExistsAtPath:tempUserLeseboxPfad])//Lesebox ist auf dem Volume
		{
			//DLog(@"Lesebox ist auf dem Volume");
			LeseboxOK=YES;
			[tempUserDic setObject:[NSNumber numberWithBool:NO] forKey:@"leseboxindocuments"];
			[tempUserDic setObject:[NSNumber numberWithInt:1] forKey:@"leseboxort"];
			LeseboxPfad=tempUserLeseboxPfad;
		}

		NSString* tempDocumentLeseboxPfad=[[tempUserPfad stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
		//DLog(@"tempDocumentLeseboxPfad: %@",tempDocumentLeseboxPfad);
		if ([Filemanager fileExistsAtPath:tempDocumentLeseboxPfad])
		{
			//DLog(@"Lesebox ist auf in Documents");

			LeseboxOK=YES;
			[tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"leseboxindocuments"];
			[tempUserDic setObject:[NSNumber numberWithInt:2] forKey:@"leseboxort"];
			LeseboxPfad=tempDocumentLeseboxPfad;

		}
		[tempUserDic setObject:[NSNumber numberWithBool:LeseboxOK] forKey:@"userleseboxOK"];
		//DLog(@"checkUserAnPfad:	tempUserDic: %@",[tempUserDic description]);
		[UserArray addObject:tempUserDic];
		
		[UserTable reloadData];
		[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[UserArray count]-1] byExtendingSelection:NO];
		[neuerHostName setString:@""];
	}//if NameIstNeu
		
	
   return LeseboxOK;
}

- (IBAction)reportHelp:(id)sender
{
   NSString* name =[@"info"stringByAppendingString:[sender alternateTitle]];
   
   if (![[name pathExtension]length])
   {
      name = [name stringByAppendingPathExtension:@"txt"];
   }
   //DLog(@"ident: %@",[sender alternateTitle]);
   NSString* helpPfad =[[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"Contents/Resources"]stringByAppendingPathComponent:name];
   DLog(@"Volumes helpPfad: %@",helpPfad);
   if ([[NSFileManager defaultManager]fileExistsAtPath:helpPfad] )
   {
      NSString* helpString = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:helpPfad] encoding:NSUTF8StringEncoding error:nil];
      //DLog(@"helpString: %@",helpString);
      if ([helpString length])
      {
         NSArray* helpArray;
         if ([helpString rangeOfString:@"\n"].location < NSNotFound)
         {
            helpArray= [helpString componentsSeparatedByString:@"\n"];
         }
         
         else if ([helpString rangeOfString:@"\r"].location < NSNotFound)
         {
            helpArray= [helpString componentsSeparatedByString:@"\r"];
         }
         else
         {
            return;
         }
         //DLog(@"helpArray: %@",helpArray);
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung setMessageText:[helpArray objectAtIndex:0]];
         NSRect cellFeld = NSMakeRect(0, 0, 400, 100);
         
         NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:
                                     cellFeld];
         [scrollView setHasVerticalScroller:YES];
         [scrollView setHasHorizontalScroller:NO];
         
         
         NSTextView* helpView = [[NSTextView alloc] initWithFrame:cellFeld];
         NSRange inforange =NSMakeRange(1, [helpArray count]-1);
         //DLog(@"inforange loc: %ld len: %ld",inforange.location, inforange.length);
         NSString* infoString = [[helpArray subarrayWithRange:NSMakeRange(1, [helpArray count]-1)]componentsJoinedByString:@"\r"];
         //DLog(@"infoString: %@",infoString); // korrectes encoding!!!
         
         [helpView insertText:[[helpArray subarrayWithRange:NSMakeRange(1, [helpArray count]-1)]componentsJoinedByString:@"\r"]];
         [helpView setEditable:NO];
         [scrollView setDocumentView:helpView];
         
         Warnung.accessoryView = scrollView;
         //Warnung.accessoryView = helpView;
         Warnung.alertStyle = NSInformationalAlertStyle;
         
         [Warnung addButtonWithTitle:@"OK"];
         
         [Warnung runModal];
         
         
      }
      
   }
}
#pragma mark -
#pragma mark URL Delegate:

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data 
{ 
//DLog(@"didReceiveData");
     // add the new data to the old data 
    // [ComputerData appendData:data]; 
     // great opportunity to provide progress to the user 
}

#pragma mark -
#pragma mark UserTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
switch ([aTableView tag])
{
case 0:
{
    return [UserArray count];
	}break;
	
	case 1:
	{
	 return [NetworkArray count];
	}
	
	}//switch
   return -1;
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(long)rowIndex
{
id einObjekt;
//DLog(@"tableView tag: %d",[aTableView tag]);
switch ([aTableView tag])
{
case 0:
{
      // NSDictionary *einUserDic;
	//DLog(@"UserArray: %@",[UserArray description]);
	if (rowIndex<[UserArray count])
	  {
    NS_DURING
        einObjekt = [[UserArray objectAtIndex: rowIndex]objectForKey:[aTableColumn identifier]];
		
    NS_HANDLER
        if ([[localException name] isEqual: @"NSRangeException"])
		  {
            return nil;
		  }
        else [localException raise];
    NS_ENDHANDLER
	  }

	}break;
	
	case 1:
	{
	    // NSDictionary *einVolumeDic;
	//DLog(@"objectValue NetworkArray: %@",[NetworkArray description]);
	if (rowIndex<[NetworkArray count])
	  {
    NS_DURING
        einObjekt = [[NetworkArray objectAtIndex: rowIndex]objectForKey:[aTableColumn identifier]];
		
    NS_HANDLER
        if ([[localException name] isEqual: @"NSRangeException"])
		  {
            return nil;
		  }
        else [localException raise];
    NS_ENDHANDLER
	  }

	}
	
	}//switch

	
  return einObjekt;
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
	switch ([aTableView tag])
	{
		case 0:
		{
			
			
		}break;
			
		case 1:
		{
			
		}
			
	}//switch
	
    /*
	 NSString* einVolume;
	 if (rowIndex<[UserArray count])
	 {
		 einVolume=[UserArray objectAtIndex:rowIndex];
		 [UserArray insertObject:anObject atIndex:rowIndex];
	 }
	 */
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
BOOL selectOK=YES;
	switch ([tableView tag])
	{
		case 0:
		{
			
		}break;
			
		case 1:
		{
			if (row<=[NetworkArray count])
			{
				[AnmeldenKnopf setEnabled:YES];
				[AuswahlenKnopf setEnabled:NO];
			}
			else
			{
				[AnmeldenKnopf setEnabled:NO];
				[PrufenKnopf setEnabled:NO];
			}
	 	}
			
	}//switch
	
	{
		//DLog(@"shouldSelectRow im Bereich: row %d",row);
		
	}
	return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	switch ([tableView tag])
	{
		case 0:
		{
			if ([[tableColumn identifier] isEqualToString:@"host"])
			{
				if (([UserArray count]>1)&&(row==0))
				{
					NSColor * SuchenFarbe=[NSColor orangeColor];
					[cell setTextColor:SuchenFarbe];
				}
				else
				{
					NSColor * TextFarbe=[NSColor blackColor];
					[cell setTextColor:TextFarbe];
				}
			}
		}break;
			
		case 1:
		{
			
		}
			
	}//switch
	
	NSFont* Tablefont;
	Tablefont=[NSFont fontWithName:@"Helvetica" size: 14];
	[cell setFont:Tablefont];
	if ((row==[UserArray count]-1)&&[[tableColumn identifier] isEqualToString:@"username"])
	{
		NSColor * SuchenFarbe=[NSColor orangeColor];
		//[cell setTextColor:SuchenFarbe];
	}
	else
	{
		NSColor * TextFarbe=[NSColor blackColor];
		//[cell setTextColor:TextFarbe];
		
	}
}

@end
