//
//  ViewController+Clean.m
//  Lesestudio_15
//
//  Created by Ruedi Heimlicher on 29.09.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "ViewController+Clean.h"

enum
{
   NamenViewTag=1111,
   TitelViewTag=2222
};

@implementation ViewController (Clean)

- (void)CleanOptionNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   //NSString* alle=@"alle";
   NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //DLog(@"+Clean CleanNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Pop AnzahlNamen
   NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
   if (AnzahlNamenNummer)
	  {
        //DLog(@"CleanNotifikationAktion: AnzahlNamen: %d",[AnzahlNamenNummer intValue]);
     }
   
   //Pop AnzahlTitel
   NSNumber* AnzahlTitelNummer=[OptionDic objectForKey:@"AnzahlTitel"];
   if (AnzahlTitelNummer)
	  {
        //DLog(@"CleanNotifikationAktion: AnzahlTitel: %d",[AnzahlTitelNummer intValue]);
     }
   
   //Radio NamenBehaltenOption
   NSNumber* NamenBehaltenNummer=[OptionDic objectForKey:@"NamenBehalten"];
   if (NamenBehaltenNummer)
	  {
        //DLog(@"CleanNotifikationAktion: NamenBehalten: %d",[NamenBehaltenNummer intValue]);
     }
   
   //Radio TitelBehaltenOption
   NSNumber* TitelBehaltenNummer=[OptionDic objectForKey:@"TitelBehalten"];
   if (TitelBehaltenNummer)
	  {
        //DLog(@"CleanNotifikationAktion: TitelBehalten: %d",[TitelBehaltenNummer intValue]);
     }
   
   NSNumber* nurTitelZuNamenOptionNummer=[OptionDic objectForKey:@"nurTitelZuNamenOption"];
   if (nurTitelZuNamenOptionNummer)
   {
      //DLog(@"CleanNotifikationAktion: nurTitelZuNamenOption: %d",[nurTitelZuNamenOptionNummer intValue]);
      nurTitelZuNamenOption=[nurTitelZuNamenOptionNummer intValue];
      //[CleanFenster clearTitelListe:NULL];
      if(nurTitelZuNamenOption>0)
      {
         NSDictionary* TempNamenDic=[OptionDic objectForKey:selektiertenamenzeile];
         //DLog(@"**  nurTitelZuNamenOption: TempNamenDic: %@",[TempNamenDic description]);
         if([TempNamenDic objectForKey:@"name"])
         {
            
            NSString* tempname=[TempNamenDic objectForKey:@"name"];
            //DLog(@"**  nurTitelZuNamenOption: tempname: %@",[tempname description]);
            
            [self setCleanTitelVonLeser:tempname];
         }
      }
   }
   //Alle Titel einsetzen
   NSNumber* alleTitelEinsetzenNummer=[OptionDic objectForKey:@"setalletitel"];
   if (alleTitelEinsetzenNummer)
   {
      //DLog(@"CleanNotifikationAktion: alleTitelEinsetzenNummer: %d",[alleTitelEinsetzenNummer intValue]);
      if ([alleTitelEinsetzenNummer intValue])
      {
         [self setAlleTitel];
      }
      
   }
   
   
}



- (void)setCleanTitelVonLeser:(NSString*)derLeser
{
   //[CleanFenster TitelListeLeeren];
   NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSArray* TitelMitAnzahlArray =[NSArray arrayWithArray:[self TitelMitAnzahlArrayVon:derLeser]];
   if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
   {
      //DLog(@"************setCleanTitelVonLeser: %@ *******Es hat noch %d  Titel in TitelMitAnzahlArray",derLeser, [TitelMitAnzahlArray count]);
      NSEnumerator* TitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
      id einNeuerTitel;
      while (einNeuerTitel=[TitelEnum nextObject])
      {
         NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:@"titel"]
                                                                         forKey:@"titel"];
         //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
         [tempDic setObject:[einNeuerTitel objectForKey:@"anzahl"]
                     forKey:@"anzahl"];
         //NSArray* tempNamenArray=[NSArray arrayWithObjects:derLeser,nil];
         [tempDic setObject:[NSArray arrayWithObjects:derLeser,nil]
                     forKey:@"leser"];
         [tempDic setObject:[NSNumber numberWithInt:0]
                     forKey:@"auswahl"];
         [tempDic setObject:[NSNumber numberWithInt:1]
                     forKey:@"anzleser"];
         
         //DLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
         [CleanTitelDicArray insertObject:tempDic
                                  atIndex:[CleanTitelDicArray count]];
         
      }
      
      //DLog(@"CleanViewNotifikationAktion: 4");
      
      if([CleanTitelDicArray count])
      {
         //DLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
         [self.CleanFenster setTitelArray:CleanTitelDicArray];
      }//if
      
   }
}

- (void)setAlleTitel
{
   NSArray* tempNamenArray=[self.CleanFenster NamenArray];//Namen der Leser
   [self.CleanFenster TitelListeLeeren];
   //DLog(@"Clean tempNamenArray: %@",[tempNamenArray description]);
   NSMutableArray* TitelDicSammelArray=[[NSMutableArray alloc]initWithCapacity:0];

   NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   //						  //DLog(@"\n\n-----------------------------Clean");//leerer Array für schon vorhandenen TitelDics in Clean
   [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]]; // eventuell vorhandene Titel


   
   //NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* NamenResetEnum=[tempNamenArray objectEnumerator];
   id einName;
   while (einName=[NamenResetEnum nextObject])
   {
      //if ([[einName objectForKey:@"auswahl"]intValue])//Name ist angeklickt, also einsetzen
      {
         //DLog(@"Clean NamenResetEnum: einName objectForKey:@"name" : %@",[[einName objectForKey:name] description]);
         NSString* tempName=[einName objectForKey:@"name"];
         //[self setCleanTitelVonLeser:[einName objectForKey:@"name"]];
          NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
         NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         //Array mit den Aufnahmen in der Lesebox für den Leser tempName
         
         [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName:  'titel', 'anzahl'
         // In CleanTitelDicArray einfuegen, sofern noch nicht vorhanden
         if ([TitelMitAnzahlArray count])
         {
            //Titel zu tempName zufuegen
            
            // schon eingetragene Titel
            NSArray* vorhandeneTitelArray = [CleanTitelDicArray valueForKey:@"titel"];
            
            // Titel des neuen Lesers
            NSArray* TitelVonNamenArray =[TitelMitAnzahlArray valueForKey:@"titel"];
            
            // neue Titel iterieren, ob schon ein Eintrag  in CleanTitelDicArray vorhanden ist.
            // ja: Anzahl im Dic incrementieren
            // nein: neuen Dic anlegen und einsetzen
            for (int titelindex = 0;titelindex < [TitelMitAnzahlArray count];titelindex++)
            {
               //NSDictionary* tempDic =[TitelMitAnzahlArray objectAtIndex:titelindex];
               long titelpos = [[CleanTitelDicArray valueForKey:@"titel"] indexOfObject:[[TitelMitAnzahlArray objectAtIndex:titelindex]objectForKey: @"titel"]];
               if (titelpos == NSNotFound )
               {
                  // Titel noch nicht da, Dic anlegen
                  [CleanTitelDicArray addObject:[TitelMitAnzahlArray objectAtIndex:titelindex]];
               }
               else
               {
                  // Titel schon da, Anzahl editieren
                  NSDictionary* tempTitelDic =[TitelMitAnzahlArray objectAtIndex:titelindex];
                  int neueAnzahl = [[tempTitelDic objectForKey:@"anzahl"]intValue];
                  int vorhandeneAnzahl = [[[CleanTitelDicArray objectAtIndex:titelpos]objectForKey: @"anzahl"]intValue];
                  
                  [[CleanTitelDicArray objectAtIndex:titelpos] setObject:[NSNumber numberWithInt:(vorhandeneAnzahl + neueAnzahl)] forKey:@"anzahl"];
                  
               }
                  
            }
            
         }
         
           //DLog(@"CleanTitelDicArray: %@",CleanTitelDicArray);
         continue;

         {
         
            
            NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
            id einTitel;
            int index=0;
            while(einTitel=[TitelDicEnum nextObject])		//in neueTitelArray neue Titel(nur String) am Ende einfuellen
            {
               
               
               [neueTitelArray insertObject:[einTitel objectForKey:@"titel"] atIndex:[neueTitelArray count]];
               index++;
            
            }
            
            
            
           
            
                        //DLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
            
            
            NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
            id eineCleanTitelDicZeile;
            while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
            {
               int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
               
               NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:@"titel"]; //Titel aus Clean
               //DLog(@"tempTitel: %@\n",[tempTitel description]);
               
               if ([neueTitelArray containsObject:tempTitel])//tempTitel ist schon in neueTitelArray
               {
                  //DLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                  int neueAnzahl=0;
                  
                  NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                  id eineTitelZeile;
                  double neuerTitelIndex=-1;
                  BOOL NameSchonDa=NO;
                  while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                  {
                     //DLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                     if ([[eineTitelZeile objectForKey:@"titel"]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                     {
                        if ([[eineCleanTitelDicZeile objectForKey:@"leser"]containsObject:tempName])
                        {
                           //DLog(@"Name schon da: %@",tempName);
                           neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                           NameSchonDa=YES;
                        }
                        else
                        {
                           //DLog(@"Name noch nicht da: %@",tempName);
                           neueAnzahl=[[eineTitelZeile objectForKey:@"anzahl"]intValue];
                           neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                           gefunden=1;
                        }
                     }
                  }//while
                  if (NameSchonDa)//Einträge loeschen
                  {
                     [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                     [neueTitelArray removeObject:tempTitel];
                  }
                  
                  //DLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                  if (gefunden==1)
                  {
                     
                     int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:@"anzahl"]intValue];//Anzahl Aufnahmen zum titel in Clean
                     
                     //DLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                     NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                     [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:@"anzahl"];
                     //DLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                     
                     //neuen namen in Liste 'leser'
                     NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:@"leser"]mutableCopy];
                     if (tempArray)
                     {
                        //DLog(@"tempArray: %@",[tempArray description]);
                        [tempArray addObject:tempName];
                        //DLog(@"tempArray neu: %@",[tempArray description]);
                     }
                     [eineCleanTitelDicZeile setObject:tempArray forKey:@"leser"];
                     NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithInteger:[tempArray count]];
                     [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:@"anzleser"];
                     
                     //DLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                     if (neuerTitelIndex>=0)
                     {
                        [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                        [neueTitelArray removeObject:tempTitel];
                     }
                  }//gefunden
                  
                  
               }//if containsObject
            }//while tempEnum
            
         }	//Nicht Namenweg
									
         //DLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
         
         
         if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
         {
            //DLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
            NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
            id einNeuerTitel;
            while (einNeuerTitel=[nochTitelEnum nextObject])
            {
               NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:@"titel"]
                                                                               forKey:@"titel"];
               //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
               [tempDic setObject:[einNeuerTitel objectForKey:@"anzahl"]
                           forKey:@"anzahl"];
               //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
               [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                           forKey:@"leser"];
               [tempDic setObject:[NSNumber numberWithInt:0]
                           forKey:@"auswahl"];
               [tempDic setObject:[NSNumber numberWithInt:1]
                           forKey:@"anzleser"];
               
               //DLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
               [CleanTitelDicArray insertObject:tempDic
                                        atIndex:[CleanTitelDicArray count]];
               
               
            }
            
            
            //DLog(@"CleanViewNotifikationAktion: 4");
            
            
         }//if TitelArray count
         if([CleanTitelDicArray count])
         {
            //DLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
           // [self.CleanFenster setTitelArray:CleanTitelDicArray];
            [TitelDicSammelArray addObjectsFromArray:CleanTitelDicArray];
         }//if
       
      }//if
     
   }//while
   
   
   [self.CleanFenster setTitelArray:CleanTitelDicArray];

   
}

- (void)ExportNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   NSString* export=@"export";
   NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //DLog(@"ViewController ExportNotificationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Namen
   NSMutableArray* exportNamenArray=[OptionDic objectForKey:@"exportnamen"];
   if (exportNamenArray)
   {
      //DLog(@"ViewController ExportNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
   }
   
   NSMutableArray* exportTitelArray=[OptionDic objectForKey:@"exporttitel"];
   if (exportTitelArray)
   {
      //DLog(@"ViewController ExportNotificationAktion*** exportTitelArray: %@",[exportTitelArray description]);
   }
   
   NSNumber*  exportVariantenNumber=[OptionDic objectForKey:@"exportvariante"];//markierteAufnahmen oder nach Anzahl
   if (exportVariantenNumber)
   {
      //DLog(@"ViewController ExportNotificationAktion exportVariante: %d",[exportVariantenNumber intValue]);
   }
   
   NSNumber*  exportAnzahlNumber=[OptionDic objectForKey:@"exportanzahl"];//Anzahl zu exportierende A.
   if (exportAnzahlNumber)
   {
      //DLog(@"ViewController ExportNotificationAktion*** exportAnzahl: %d",[exportAnzahlNumber intValue]);
   }
   
   NSString*  exportFormat=[OptionDic objectForKey:@"exportformat"];//Format aus Pop
   if (exportFormat)
   {
      //DLog(@"ViewController ExportNotificationAktion*** exportFormat: %@",[exportFormat description]);
   }
   
   //DLog(@"ExportNotificationAktion OptionDic: %@",[OptionDic description]);
   
   [self Export:OptionDic];
   
}


- (void)Export:(NSDictionary*)derExportDic
{
   //DLog(@"Export: derExportDic: %@",[derExportDic description]);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   int exportvariante=[[derExportDic objectForKey:@"exportvariante"]intValue];
   int exportformatvariante=[[derExportDic objectForKey:@"exportformatvariante"]intValue];
   NSString* exportformatString=[derExportDic objectForKey:@"exportformat"];
   int anzahlExportieren=[[derExportDic objectForKey:@"exportanzahl"]intValue];
   if (anzahlExportieren<0)
   {
      //DLog(@"Anzahl nochmals überlegen");
      return;
   }
   
   ExportFormatString=(NSMutableString*)[NSString stringWithString: exportformatString];
   //DLog(@"Export: ExportFormatString: %@",[ExportFormatString description]);
   
   //[self ExportPrefsSchreiben];
   
   //DLog(@"Clean:  Variante: %d  behalten: %d  anzahl: %d",var, behalten, anzahl);
   NSMutableArray* exportNamenArray=[derExportDic objectForKey:@"exportnamen"];
   
   //DLog(@"Export	exportNamenArray: %@",[exportNamenArray description]);
   
   if (exportNamenArray)
   {
      //DLog(@"ClearNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
      
      NSMutableArray* exportTitelArray=[derExportDic objectForKey:@"exporttitel"];
      //DLog(@"Export	exportTitelArray: %@",[exportTitelArray description]);
      
      if (exportTitelArray)
      {
         //DLog(@"Export*** exportTitelArray: %@",[exportTitelArray description]);
         //Array für zu l√∂schende Aufnahmen
         NSMutableArray* ExportTitelPfadArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         NSFileManager* Filemanager=[NSFileManager defaultManager];
         NSEnumerator* NamenEnum=[exportNamenArray objectEnumerator];
         id einName;
         while(einName=[NamenEnum nextObject])
         {
            
            NSString* tempNamenPfad=[self.ProjektPfad stringByAppendingPathComponent:einName];
            DLog(@"Export*** tempNamenPfad %@",tempNamenPfad);
            
            BOOL istOrdner;
            if (([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner])&&istOrdner)
            {
               //DLog(@"Export*** Ordner am Pfad %@ ist da",tempNamenPfad);
               NSMutableArray* tempAufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:tempNamenPfad error:NULL]mutableCopy];
               int index=0;
               if ([tempAufnahmenArray count])
               {
                  if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
                  {
                     [tempAufnahmenArray removeObjectAtIndex:0];
                  }
                  if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
                  {
                     [tempAufnahmenArray removeObject:@"Anmerkungen"];
                  }
                  //DLog(@"Clean*** tempAufnahmenArray: %@",[tempAufnahmenArray description]);
                  //tempAufnahmenArray=(NSMutableArray*)[self sortNachNummer:tempAufnahmenArray];
                  
                  
                  tempAufnahmenArray=[[self sortNachABC:tempAufnahmenArray]mutableCopy];
                  //DLog(@"Export*** tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
                  
                  switch (exportvariante) //
                  {//
                     case 0://nur markierte exportieren
                     {
                        NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                        NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                        int anz=0;
                        id eineAufnahme;
                        while(eineAufnahme=[AufnahmenEnum nextObject])
                        {
                           NSString* testtitel =[self AufnahmeTitelVon:eineAufnahme];
                           if ([testtitel length] < 4)
                               {
                                  //DLog(@"kurzer titel: %@",testtitel);
                               }
                           if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                           {
                              NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                              if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                              {
                                 BOOL AdminMark=[self AufnahmeIstMarkiertAnPfad:tempLeserAufnahmePfad];
                                 if (AdminMark)
                                 {
                                    //DLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                    [ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                    
                                 }
                                 else
                                 {
                                    //DLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                    //[DeleteTitelArray addObject:eineAufnahme];
                                    
                                 }
                               }//if tempLeserAufnahmePfad
                           }//if in exportTitelArray
                        }//while AufnahmeEnum
                     }break;
                        
                     case 1://Anzahl: anzahlExportieren exportierenn
                     {
                        NSArray* tempLeserTitelArray=[self TitelArrayVon:einName anProjektPfad:self.ProjektPfad];
                        NSEnumerator* LeserTitelEnum=[tempLeserTitelArray objectEnumerator];
                        id einLeserTitel;
                        while(einLeserTitel=[LeserTitelEnum nextObject])
                        {
                           NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                           NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                           int anz=0;
                           id eineAufnahme;
                           while(eineAufnahme=[AufnahmenEnum nextObject])
                           {
                              if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                              {
                                 
                                 NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                                 if ([einLeserTitel rangeOfString:tempTitel].location < NSNotFound)
                                 {
                                    NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                    if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                    {
                                       [tempExportTitelArray addObject:eineAufnahme ];
                                       
                                    }//if tempLeserAufnahmePfad
                                 }
                              }//if in exportTitelArray
                           }//while AufnahmenEnum
                           
                           //DLog(@"einLeserTitel: %@ * tempExportTitelArray: %@",einLeserTitel,[tempExportTitelArray description]);
                           if ([tempExportTitelArray count])
                           {
                              tempExportTitelArray=[[self sortNachNummer:tempExportTitelArray]mutableCopy];
                              //DLog(@"			*** *** tempExportTitelArray nach sort: %@",[tempExportTitelArray description]);
                           }
                           
                           NSEnumerator* ExportEnum=[tempExportTitelArray objectEnumerator];
                           id eineExportAufnahme;
                           int i=0;
                           while(eineExportAufnahme=[ExportEnum nextObject])
                           {
                              if (i<anzahlExportieren)//Anzahl zu exportierende Aufnahmen
                              {
                                 //[ExportTitelPfadArray addObject:eineExportAufnahme];
                                 [ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineExportAufnahme]];
                                 
                              }
                              i++;
                           }//while ExportEnum
                           
                           
                           
                        }//while LeserTitelEnum
                        
                        
                     }break;//case 1
                        
                        
                  }//switch beahlten
                  
                  
                  
               }//if ([tempTitelArray count])
               
            }//if fileExists tempNamenPfad
            
         }//while NamenEnum
         
         //DLog(@"Export Ergebnis*** ExportTitelPfadArray: %@",[ExportTitelPfadArray description]);
         if ([ExportTitelPfadArray count])
         {
            
            
            int status=0;
            switch (exportformatvariante)
            {
               case 0://letztes Format
               {
                  //DLog(@"Export mit bisherigem Format");
                  
                  [self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:NO];
                  
                  
               }break;
                  
               case 1://anderes Format
               {
                  //DLog(@"Export mit anderem Format");
                  NSEnumerator* exportEnum=[ExportTitelPfadArray objectEnumerator];
                  id einAufnahmePfad;
                  BOOL suchen=YES;
                  OSErr err=0;
                  while ((einAufnahmePfad=[exportEnum nextObject])&&(suchen))
                  {
                     if ([Filemanager fileExistsAtPath:einAufnahmePfad])
                     {
                        /*
                         OSErr err=[self getExportEinstellungenvonAufnahme:einAufnahmePfad];
                         if (err)
                         {
                         //DLog(@"getExportEinstellungenvonAufnahme misslungen. err: %d",err);
                         return ;
                         }
                         */
                        suchen=NO;
                     }
                  }//while exportEnum
                  [self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:YES];
                  
               }break;
                  
            }//switch
            
            
            
         }
         else
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            [Warnung setMessageText:@"Keine markierten Aufnahmen"];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            [Warnung runModal];
            
            //DLog(@"Nichts zu exportieren");
         }
      }//if (exportTitelArray)
   }//if (exportNamenArray)
   
}

- (void) AufnahmenArrayExportieren:(NSArray*)derAufnahmenArray
                     mitUserDialog:(BOOL)userDialogOK
{
   OSErr err=0;
   int anzAufnahmen = (int)[derAufnahmenArray count];
   if ([derAufnahmenArray count]==0)
      return;
   NSMutableArray* fehlendeArray=[[NSMutableArray alloc]initWithCapacity:0];
   RPExportdaten=[[[NSUserDefaults standardUserDefaults]dataForKey:@"RPExportdaten"]mutableCopy];
   
   ExportOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
   //DLog(@"AufnahmenArrayExportieren\n\n");
   //DLog(@"AufnahmenArrayExportieren:Nach Dialog: Exportdaten: %@",[RPExportdaten length]);
   
   // 8.12.08: HomeDirectory wieder eingestellt
   //ExportOrdnerPfad=[AdminLeseboxPfad stringByDeletingLastPathComponent];//Documents
   
   
   //ExportOrdnerPfad bestimmen
   
   NSString* ExportOrdnerName = @"Lesestudioexport";
   
   NSString *bundlePfad = [[NSBundle mainBundle] bundlePath];
   //DLog(@"AufnahmenArrayExportieren	bundlePfad: %@",bundlePfad);
   NSArray* homeArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[bundlePfad stringByDeletingLastPathComponent] error:nil];
   
   long leseboxindex = [homeArray indexOfObject:@"Lesebox"];
   //DLog(@"AufnahmenArrayExportieren	homeArray: %@ leseboxindex: %ld",homeArray,leseboxindex);
   if (leseboxindex < NSNotFound)
   {
      NSString* tempLeseboxPfad =[[bundlePfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Lesebox" ];
      BOOL isDir;
      if ([[NSFileManager defaultManager]fileExistsAtPath:tempLeseboxPfad isDirectory:&isDir] && isDir)
      {
         [VolumesPanel setLeseboxPfad:tempLeseboxPfad];
         [VolumesPanel setLeseboxOK:YES];
      }
      else
      {
         [VolumesPanel setLeseboxPfad:@"--"];
      }
   }
   else
   {
      [VolumesPanel setLeseboxPfad:@"--"];
   }
      NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"OK"];
   [Warnung setMessageText:@"Mehrere Aufnahmen exportieren"];
   NSString* i1= @"Es kann nur der Speicherort für den Ordner mit den Aufnahmen gewählt werden.\rDer Ordner mit den Aufnahmen hat den Namen 'Lesestudioexport'";
   NSTextField *ExportOrdnerFeld = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
   [ExportOrdnerFeld setStringValue:ExportOrdnerName];
   
   NSString* string2=@"Änderungen im Namen werden ignoriert.";
   
   
   NSData *data = [string2 dataUsingEncoding:NSUTF8StringEncoding];
   NSString *i2 = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
   
   NSString* i3=@"Einzelne Aufnahmen können in Admin exportiert werden.";
   NSString* I0=[NSString stringWithFormat:@"%@\n%@\n%@",i3,i2,i1];
 //  [Warnung setAccessoryView:ExportOrdnerFeld];
   [Warnung setInformativeText:I0];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   
   long ersteaufnahmeantwort=[Warnung runModal];
   
   
   if (ersteaufnahmeantwort == NSModalResponseCancel)
   {
      return;
   }
   
   ExportOrdnerName = [ExportOrdnerFeld stringValue];
   
   NSString* ersteAufnahme=[[derAufnahmenArray objectAtIndex:0]lastPathComponent];
   
   NSSavePanel * ExportPanel = [NSSavePanel savePanel];
   [ExportPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"m4a",@"aif",@"mp3",nil]];
   //	[ExportPanel setRequiredFileType:@"wav"];
   [ExportPanel setCanCreateDirectories:YES];
   [ExportPanel setCanSelectHiddenExtension:YES];
   
   //NSString* ExportPanelPfad = [NSHomeDirectory()stringByAppendingPathComponent:@"Desktop"];
   NSString* ExportPanelPfad = [self.LeseboxPfad stringByDeletingLastPathComponent];
   
   //DLog(@"ExportPanelPfad: %@",ExportPanelPfad);
   [ExportPanel setDirectoryURL:[NSURL fileURLWithPath:ExportPanelPfad]];
   [ExportPanel setNameFieldStringValue:ersteAufnahme];
   NSString* labelString=@"Erste Aufnahme, die im Ordner gesichert wird:";
   [ExportPanel setNameFieldLabel:labelString];
   NSString* titleString=@"Aufnahmen exportieren";
   [ExportPanel setTitle:titleString];
   
   
   long modalAntwort=[ExportPanel runModal] ;//ForDirectory:ExportOrdnerPfad file:ersteAufnahme];
   
   
   //DLog(@"ExportPanel: modalAntwort: %d",modalAntwort);
   //DLog(@"AufnahmenArrayExportieren:Nach Dialog: Expotdaten: %@",[RPExportdaten length]);
   switch (modalAntwort)
   {
      case NSFileHandlingPanelOKButton:
      {
         DLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[ExportPanel filename],ExportOrdnerPfad);
         NSString* 	tempExportFilePfad=[[[ExportPanel URL]path]copy];
         DLog(@"ExportPanel: filename: %@ tempExportFilePfad: %@",[ExportPanel filename],tempExportFilePfad);
         ExportOrdnerPfad=[tempExportFilePfad stringByDeletingLastPathComponent];
         DLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[[ExportPanel URL]path],ExportOrdnerPfad);
         
         
      }break;
      case NSFileHandlingPanelCancelButton:
      {
         //DLog(@"ExportPanel: keine Eingabe ExportOrdnerPfad: %@",ExportOrdnerPfad);
         return;
      }break;
   }//switch
   
   int exporterfolg = 0;
   
   //DLog(@"AufnahmenArrayExportieren:Nach Dialog: Exportdaten: %d",[RPExportdaten length]);
   ExportOrdnerPfad =[ExportOrdnerPfad stringByAppendingPathComponent:ExportOrdnerName ];
   
   int exportordnererfolg = [[NSFileManager defaultManager]createDirectoryAtPath:ExportOrdnerPfad withIntermediateDirectories:NO attributes:nil error:nil];
   
   NSEnumerator* ExportEnum=[derAufnahmenArray objectEnumerator];
   id einAufnahmePfad;
   int index=0;
   
   
   
   
   while (einAufnahmePfad=[ExportEnum nextObject])
   {
      //DLog(@"AufnahmenArrayExportieren: einAufnahmePfad: %@",einAufnahmePfad);
      // if (index==0)//Bei erster Aufnahme nach Speicherort fragen
      {
         
         //DLog(@"AufnahmenarrayExport userDialogOK: %d",userDialogOK);
         long erfolg =  [self Aufnahme:einAufnahmePfad exportierenMitPfad:ExportOrdnerPfad];
         if (erfolg)
         {
            exporterfolg++;
         }
         else
         {
            [fehlendeArray addObject:[einAufnahmePfad lastPathComponent]];
         }
         
         //DLog(@"ExportPanel: AufnahmePfad: %@ exporterfolg: %d",einAufnahmePfad,exporterfolg);
         
      }
      index++;
   }//ExportEnum
   //DLog(@"AufnahmenArrayExportieren:2");
   //DLog(@"AufnahmenArrayExportieren anzAufnahmen: %d exporterfolg: %d",anzAufnahmen,exporterfolg);
   NSString* infoOKString = [NSString stringWithFormat:@"Die exportierten Aufnahmen liegen im Ordner %@ am Pfad\r%@",ExportPanelPfad,ExportOrdnerPfad];
   NSString* infoFehlerString = [NSString stringWithFormat:@"Folgende Aufnahmen konnten exportiert werden. \r%@\r%@",[fehlendeArray componentsJoinedByString:@"\r" ],infoOKString];
   
   
   NSAlert *ExportAlert = [[NSAlert alloc] init];
   [ExportAlert setMessageText:@"Export beendet"];
   
   if (anzAufnahmen == exporterfolg)
   {
      [ExportAlert setInformativeText:infoOKString];
   }
   else
   {
   [ExportAlert setInformativeText:infoFehlerString];
   }
   [ExportAlert setAlertStyle:NSInformationalAlertStyle];
   
   [ExportAlert addButtonWithTitle:@"OK"];
   
   [ExportAlert runModal];
  
   if (anzAufnahmen == exporterfolg)
   {
      //DLog(@"AufnahmenArrayExportieren Alles exportiert");
   }
   else{
      //DLog(@"AufnahmenArrayExportieren Fehlende Aufnahmen: \r%@",[fehlendeArray componentsJoinedByString:@"\r" ]);
   }
   
}//AufnahmenArrayExportieren



- (BOOL) Aufnahme:aufnahmePfad exportierenMitPfad:(NSString*)exportPfad
{
   
   int exporterfolg=0;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* aufnahmeName=[aufnahmePfad lastPathComponent];
   //DLog(@"AdminPlayPfad : %@ aufnahmeName: %@",aufnahmePfad,aufnahmeName);
   
   NSString* tempexportPfad = exportPfad;
   if ([Filemanager fileExistsAtPath:aufnahmePfad])
   {
      NSString* aufnahmeSuffix = [aufnahmeName pathExtension];
       {
         //DLog(@"tempExportPfad: %@",exportPfad);
          int repeatindex=1;
         while ( ([Filemanager fileExistsAtPath:[exportPfad stringByAppendingPathComponent:aufnahmeName]])) // File schon da
         {
            //File existiert schon
            NSString* nameZusatz = [NSString stringWithFormat:@"_%d",repeatindex++];
            aufnahmeName = [[[aufnahmeName stringByDeletingPathExtension]stringByAppendingString:nameZusatz]stringByAppendingPathExtension:aufnahmeSuffix];
            
            //exporterfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:[exportPfad stringByAppendingPathComponent:ExportAufnahmeName]] error:nil];
            //DLog(@"Export: removeFileAtPath: erfolg: %d",erfolg);
            tempexportPfad = [[tempexportPfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:aufnahmeName];
         }
          
         exporterfolg =  [Filemanager copyItemAtPath:aufnahmePfad toPath:[exportPfad stringByAppendingPathComponent:aufnahmeName] error:nil];
          
          
         
      }
      
   }//File exists
   return exporterfolg;
}



- (void)CleanViewNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Views des Cleanfensters
   //DLog(@"												CleanViewNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   //NSNumber* ViewZeilenNumber=[OptionDic objectForKey:@"ZeilenNummer"];
   //int ViewZeilennummer=[ViewZeilenNumber intValue];
   //Pop AnzahlNamen
   NSNumber* ViewTagNumber=[OptionDic objectForKey:@"Quelle"];
   if (ViewTagNumber)
	  {
        switch([ViewTagNumber intValue])
        {
           case NamenViewTag:
           {
              NSString* tempName=[OptionDic objectForKey:@"name"];//aktueller Name
              int NamenWeg=[[OptionDic objectForKey:@"namenweg"]intValue];//sollen die Titel zum Namen entfernt weden?
              NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
              //DLog(@"\n\n-----------------------------CleanViewNotifikationAktion: CleanTitelDicArray: \n%@\n",[CleanTitelDicArray description]);
              //Array mit schon vorhandenen TitelDics in Clean
              NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
              //DLog(@"CleanTitelDicArray von: %@: \n%@\n",tempName, [CleanTitelDicArray description]);
              NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
              
              [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName
              //DLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
              
              if (nurTitelZuNamenOption)
              {
                 //DLog(@"nurTitelZuNamenOption");
                 //[CleanFenster clearTitelListe:NULL];
                 [self.CleanFenster TitelListeLeeren];
                 
                 
              }
              else
              {
                 //DLog(@"nicht TitelZuNamenOption");
                 if (NamenWeg>0)//Die Titel von tempName sollen entfernt werden
                 {
                    //DLog(@"NamenWeg>0");
                    [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];//vorhandene Titel mit Anzahlen
                    NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                    id einTitel;
                    int index=0;
                    while(einTitel=[TitelDicEnum nextObject])		//neue Titel einf√ºllen
                    {
                       [neueTitelArray insertObject:[einTitel objectForKey:@"titel"] atIndex:[neueTitelArray count]];
                       index++;
                    }
                    NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                    id eineCleanTitelDicZeile;
                    while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                    {
                       int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                       
                       //int neueAnzahl=[[eineZeile objectForKey:anzahl]intValue];
                       //DLog(@"eineZeile: %@ anzahl: %d",[eineZeile description],n);
                       NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:@"titel"]; //Titel aus Clean
                       //DLog(@"tempTitel: %@\n",[tempTitel description]);
                       
                       
                       if ([neueTitelArray containsObject:tempTitel])
                       {
                          //DLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                          int TitelWegAnzahl=0;
                          
                          NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                          id eineTitelZeile;
                          double wegTitelIndex=-1;
                          BOOL NameSchonDa=NO;
                          while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                          {
                             //DLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                             if ([[eineTitelZeile objectForKey:@"titel"]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                             {
                                if ([[eineCleanTitelDicZeile objectForKey:@"leser"]containsObject:tempName])
                                {
                                   //DLog(@"Name schon in Liste 'leser': %@",tempName);
                                   wegTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   
                                   TitelWegAnzahl=[[eineTitelZeile objectForKey:@"anzahl"]intValue];
                                   NameSchonDa=YES;
                                   gefunden=1;
                                }
                                else
                                {
                                   //für diesen Titel hat tempLeser keinen Eintrag
                                   //DLog(@"Name noch nicht da: %@",tempName);
                                }
                             }
                          }//while
                          if (NameSchonDa)//Einträge l√∂schen
                          {
                             
                             if (wegTitelIndex>=0)
                             {
                                [TitelMitAnzahlArray removeObjectAtIndex:wegTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                          }
                          
                          //DLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                          if (gefunden==1)
                          {
                             
                             int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:@"anzahl"]intValue];//Anzahl Aufnahmen zum titel in Clean
                             
                             //DLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                             NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:alteAnzahl-TitelWegAnzahl];
                             [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:@"anzahl"];
                             //DLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                             
                             //neuen namen aus Liste 'leser' entfernen
                             NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:@"leser"]mutableCopy];
                             if (tempArray)
                             {
                                //DLog(@"tempArray: %@",[tempArray description]);
                                [tempArray removeObject:tempName];
                                //DLog(@"tempArray neu: %@",[tempArray description]);
                             }
                             [eineCleanTitelDicZeile setObject:tempArray forKey:@"leser"];
                             NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithDouble:[tempArray count]];
                             [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:@"anzleser"];
                             
                             //DLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                          }//gefunden
                          
                       }//if containsObject
                    }//while (eineCleanTitelDicZeile
                    //DLog(@"while (eineCleanTitelDicZeile) fertig");
                    BOOL nochZeilenMitNull=YES;
                    long schleifenindex=[CleanTitelDicArray count];
                    while (nochZeilenMitNull&&(schleifenindex>=0))
                    {
                       //DLog(@"Anzahl: %d  CleanTitelDicArray: %@  schleifenindex: %d",[CleanTitelDicArray count],[CleanTitelDicArray description],schleifenindex);
                       NSEnumerator* CleanTitelWegEnum=[CleanTitelDicArray objectEnumerator];
                       //Array mit vebliebenen Dics  aus Clean
                       id eineCleanTitelWegZeile;
                       int ZeileMitNullGefunden=-1;
                       int zeilenIndex=0;
                       while ((eineCleanTitelWegZeile=[CleanTitelWegEnum nextObject])&&(ZeileMitNullGefunden<0))//Zeilen mit Anzahl=0 entfernen
                       {
                          if ([[eineCleanTitelWegZeile objectForKey:@"anzahl"]intValue]==0)
                          {
                             ZeileMitNullGefunden=zeilenIndex;
                          }
                          zeilenIndex++;
                       }//while eineCleanTitelWegZeile
                       
                       if (ZeileMitNullGefunden<0)
                       {
                          nochZeilenMitNull=NO;
                       }
                       else
                       {//Es hat noch eine Zeile mit Anzahl 0
                          [CleanTitelDicArray removeObjectAtIndex:ZeileMitNullGefunden];
                       }
                       
                       schleifenindex--;
                    }//while nochZeilenMitNull
                    [self.CleanFenster TitelListeLeeren];
                    [self.CleanFenster deselectNamenListe];
                 }//if (NamenWeg>0)
                 else
                 {
                    //Titel zu tempName zufuegen
                    [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];
                    NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                    id einTitel;
                    int index=0;
                    while(einTitel=[TitelDicEnum nextObject])		//neue Titel einf√ºllen
                    {
                       [neueTitelArray insertObject:[einTitel objectForKey:@"titel"] atIndex:[neueTitelArray count]];
                       index++;
                    }
                    //DLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
                    //DLog(@"CleanViewNotifikationAktion: NamenView Zeilennummer:%d Name:%@",ViewZeilennummer,tempName);
                    
                    NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                    id eineCleanTitelDicZeile;
                    while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                    {
                       int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                       
                       //int neueAnzahl=[[eineZeile objectForKey:anzahl]intValue];
                       //DLog(@"eineZeile: %@ anzahl: %d",[eineZeile description],n);
                       NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:@"titel"]; //Titel aus Clean
                       //DLog(@"tempTitel: %@\n",[tempTitel description]);
                       
                       
                       if ([neueTitelArray containsObject:tempTitel])
                       {
                          //DLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                          int neueAnzahl=0;
                          
                          NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                          id eineTitelZeile;
                          double neuerTitelIndex=-1;
                          BOOL NameSchonDa=NO;
                          while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                          {
                             //DLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                             if ([[eineTitelZeile objectForKey:@"titel"]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                             {
                                if ([[eineCleanTitelDicZeile objectForKey:@"leser"]containsObject:tempName])
                                {
                                   //DLog(@"Name schon da: %@",tempName);
                                   neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   NameSchonDa=YES;
                                }
                                else
                                {
                                   //DLog(@"Name noch nicht da: %@",tempName);
                                   neueAnzahl=[[eineTitelZeile objectForKey:@"anzahl"]intValue];
                                   neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   gefunden=1;
                                }
                             }
                          }//while
                          if (NameSchonDa)//Einträge l√∂schen
                          {
                             
                             
                             [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                             [neueTitelArray removeObject:tempTitel];
                          }
                          
                          //DLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                          if (gefunden==1)
                          {
                             
                             int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:@"anzahl"]intValue];//Anzahl Aufnahmen zum titel in Clean
                             
                             //DLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                             NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                             [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:@"anzahl"];
                             //DLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                             
                             //neuen namen in Liste 'leser'
                             NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:@"leser"]mutableCopy];
                             if (tempArray)
                             {
                                //DLog(@"tempArray: %@",[tempArray description]);
                                [tempArray addObject:tempName];
                                //DLog(@"tempArray neu: %@",[tempArray description]);
                             }
                             [eineCleanTitelDicZeile setObject:tempArray forKey:@"leser"];
                             NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithDouble:[tempArray count]];
                             [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:@"anzleser"];
                             
                             //DLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                             if (neuerTitelIndex>=0)
                             {
                                [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                          }//gefunden
                          
                          
                       }//if containsObject
                    }//while tempEnum
                    
                 }//if ! NamenWeg
                 
              }//NOT if nurTitelZuNamen
              
              if	([TitelMitAnzahlArray count]&&(NamenWeg==0)) //es hat noch Titel in TitelMitAnzahlArray
              {
                 //DLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
                 NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
                 id einNeuerTitel;
                 while (einNeuerTitel=[nochTitelEnum nextObject])
                 {
                    NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:@"titel"]
                                                                                    forKey:@"titel"];
                    //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
                    [tempDic setObject:[einNeuerTitel objectForKey:@"anzahl"]
                                forKey:@"anzahl"];
                    //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
                    [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                                forKey:@"leser"];
                    [tempDic setObject:[NSNumber numberWithInt:0]
                                forKey:@"auswahl"];
                    [tempDic setObject:[NSNumber numberWithInt:1]
                                forKey:@"anzleser"];
                    
                    //DLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
                    [CleanTitelDicArray insertObject:tempDic
                                             atIndex:[CleanTitelDicArray count]];
                    
                 }
                 
                 //DLog(@"CleanViewNotifikationAktion: 4");
                 
                 
              }
              
              
              if([CleanTitelDicArray count])
              {
                 //DLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
                 [self.CleanFenster setTitelArray:CleanTitelDicArray];
              }//if
              else
              {
                 //DLog(@"CleanTitelDicArray null: %@",[CleanTitelDicArray description]);
                 [self.CleanFenster deselectNamenListe];
              }
              //[CleanFenster deselectNamenListe];
              
              
           }break;//NamenViewTag
              
           case TitelViewTag:
           {
              //DLog(@"CleanViewNotifikationAktion: TitelView Zeilennummer:%d",ViewZeilennummer);
              
           }break;//TitelViewTag
              
              
        }//switch tag
     }
}





- (void)ClearNotificationAktion:(NSNotification*)note // von Clean
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   //NSString* clear=@"clear";
   //NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //DLog(@"CleanNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Namen
   NSMutableArray* clearNamenArray=[OptionDic objectForKey:@"clearnamen"];
   if (clearNamenArray)
   {
      //DLog(@"ClearNotificationAktion*** clearNamenArray: %@",[clearNamenArray description]);
      
   }
   
   NSMutableArray* clearTitelArray=[OptionDic objectForKey:@"cleartitel"];
   if (clearTitelArray)
   {
      //DLog(@"ClearNotificationAktion*** clearTitelArray: %@",[clearTitelArray description]);
   }
   [self Clean:OptionDic];
   //NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
   
}


- (void)Clean:(NSDictionary*)derCleanDic
{
   int var=[[derCleanDic objectForKey:@"clearentfernen"]intValue];
   int behalten=[[derCleanDic objectForKey:@"clearbehalten"]intValue];
   int anzahlBehalten=[[derCleanDic objectForKey:@"clearanzahl"]intValue];
   if (anzahlBehalten<0)
   {
      //DLog(@"Anzahl nochmals überlegen");
      return;
   }
   
   //DLog(@"Clean  Variante: %d  behalten: %d  anzahl: %d",var, behalten, anzahl);
   //DLog(@"ClearNotificationAktion*** derCleanDic: %@",[derCleanDic description]);
   NSMutableArray* clearNamenArray=[derCleanDic objectForKey:@"clearnamen"];
   if (clearNamenArray)
	  {
        // Namen, von denen Aufnahmen entfernt werden sollen
        //DLog(@"ClearNotificationAktion*** clearNamenArray: %@",[clearNamenArray description]);
        
        NSMutableArray* clearTitelArray=[derCleanDic objectForKey:@"cleartitel"];//angeklickte Titel
        if (clearTitelArray)
        {
           // Titel, die entfernt werden sollen
           //DLog(@"Clean*** clearTitelArray: %@",[clearTitelArray description]);
           
           NSMutableArray* DeleteTitelPfadArray=[[NSMutableArray alloc]initWithCapacity:0];//Array für zu loeschende Aufnahmen
           
           NSFileManager* Filemanager=[NSFileManager defaultManager];
           NSEnumerator* NamenEnum=[clearNamenArray objectEnumerator];
           id einName;
           
           // Namen iterieren
           while(einName=[NamenEnum nextObject])
           {
              
              NSString* tempNamenPfad=[self.ProjektPfad stringByAppendingPathComponent:einName];
              //DLog(@"Clean*** tempNamenPfad %@",tempNamenPfad);
              
              BOOL istOrdner;
              if (([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]) && istOrdner)
              {
                 //DLog(@"Clean*** Ordner fuer Namen  am Pfad %@ ist da",tempNamenPfad);
                 NSMutableArray* tempAufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:tempNamenPfad error:NULL]mutableCopy];
                 
                 if ([tempAufnahmenArray count])
                 {
                    if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
                    {
                       [tempAufnahmenArray removeObjectAtIndex:0];
                    }
                    if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
                    {
                       [tempAufnahmenArray removeObject:@"Anmerkungen"];
                    }
                    //DLog(@"Clean*** tempAufnahmenArray raw: %@",[tempAufnahmenArray description]);
                    //tempAufnahmenArray=(NSMutableArray*)[self sortNachNummer:tempAufnahmenArray];
                    
                    
                    tempAufnahmenArray=[[self sortNachABC:tempAufnahmenArray]mutableCopy];
                    //DLog(@"Clean*** tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
                    
                    switch (behalten) //
                    {//
                       case 0://nur markierte behalten
                       {
                          // Aufnahmen iterieren
                          NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator]; //
                          //NSMutableArray* tempDeleteTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                          //int anz=0;
                          id eineAufnahme;
                          while(eineAufnahme=[AufnahmenEnum nextObject])
                          {
                             if ([clearTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                             {
                                NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                {
                                   BOOL AdminMark=[self AufnahmeIstMarkiertAnPfad:tempLeserAufnahmePfad];
                                   if (AdminMark)
                                   {
                                      //DLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                   }
                                   else
                                   {
                                      //DLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                      //[DeleteTitelArray addObject:eineAufnahme];
                                      [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                      
                                   }
                                   
                                   /*
                                    NSMutableDictionary* AufnahmeAttribute=[[[Filemanager fileAttributesAtPath:tempLeserAufnahmePfad traverseLink:YES]mutableCopy]autorelease];
                                    if (AufnahmeAttribute )
                                    {
                                    
                                    if([AufnahmeAttribute fileHFSCreatorCode]==[FileCreatorNumber intValue])
                                    {
                                    //DLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                    }
                                    else
                                    {
                                    //DLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                    //[DeleteTitelArray addObject:eineAufnahme];
                                    [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                    }
                                    
                                    
                                    }//if (AufnahmeAttribute )
                                    */
                                }//if tempLeserAufnahmePfad
                             }//if in clearTitelArray
                          }//while AufnahmeEnum
                       }break;
                       case 1://alle bis auf anzahlBehalten löschen
                       {
                          NSArray* tempLeserTitelArray=[self TitelArrayVon:einName anProjektPfad:self.ProjektPfad];//Titel der Aufnahmen für den Leser
                          NSEnumerator* LeserTitelEnum=[tempLeserTitelArray objectEnumerator];
                          id einLeserTitel;
                          while(einLeserTitel=[LeserTitelEnum nextObject])  /// Handlungsbedarf
                          {
                             NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                             NSMutableArray* tempDeleteTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                             id eineAufnahme;
                             while(eineAufnahme=[AufnahmenEnum nextObject])
                             {
                                //DLog(@"einLeserTitel: %@		  AufnahmeTitelVon:eineAufnahme: %@",einLeserTitel,[self AufnahmeTitelVon:eineAufnahme]);
                                
                                if ([clearTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                                {
                                   
                                   NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                                   if ([einLeserTitel isEqualToString:tempTitel])
                                   {
                                      NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                      //DLog(@"tempLeserAufnahmePfad: %@",tempLeserAufnahmePfad);
                                      
                                      if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                      {
                                         //DLog(@"tempLeserAufnahmePfad: File da");
                                         [tempDeleteTitelArray addObject:eineAufnahme ];
                                         
                                      }//if tempLeserAufnahmePfad
                                   }
                                }//if in clearTitelArray
                             }//while AufnahmenEnum
                             
                             //DLog(@"einLeserTitel: %@ * tempDeleteTitelArray: %@",einLeserTitel,[tempDeleteTitelArray description]);
                             if ([tempDeleteTitelArray count])
                             {
                                tempDeleteTitelArray=[[self sortNachNummer:tempDeleteTitelArray]mutableCopy];
                                //DLog(@"			*** *** tempDeleteTitelArray nach sort: %@",[tempDeleteTitelArray description]);
                             }
                             
                             NSEnumerator* DeleteEnum=[tempDeleteTitelArray objectEnumerator];
                             id eineDeleteAufnahme;
                             int i=0;
                             // neuste Aufnahmen behalten
                             while(eineDeleteAufnahme=[DeleteEnum nextObject])
                             {
                                if (i>=anzahlBehalten)//Anzahl zu behaltende Aufnahmen
                                {
                                   //[DeleteTitelArray addObject:eineDeleteAufnahme];
                                   [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineDeleteAufnahme]];
                                   
                                }
                                i++;
                             }//while DeleteEnum
                             
                             
                             
                          }//while LeserTitelEnum
                          
                          
                       }break;//case 1
                          
                          
                    }//switch beahlten
                    
                    
                    
                 }//if ([tempTitelArray count])
                 
              }//if fileExists tempNamenPfad
              
           }//while NamenEnum
           
           //DLog(@"Clean***				*** DeleteTitelPfadArray: %@",[DeleteTitelPfadArray description]);
           if ([DeleteTitelPfadArray count])
           {
              switch (var)
              {
                 case 0://in den Papierkorb
                 {
                    //DLog(@"Clean in Papierkorb");
                    NSEnumerator* clearEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einClearAufnahmePfad;
                    while (einClearAufnahmePfad=[clearEnum nextObject])
                    {
                       [Utils inPapierkorbMitPfad:einClearAufnahmePfad];
                       
                    }//while clearEnum
                    
                    //
                 }break;
                    
                 case 1://ins Magazin
                 {
                    //DLog(@"Clean ins Magazin");
                    NSEnumerator* magEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einMagazinAufnahmePfad;
                    while (einMagazinAufnahmePfad=[magEnum nextObject])
                    {
                      [Utils insMagazinMitPfad:einMagazinAufnahmePfad];
                    }//while clearEnum
                 }break;
                    
                 case 2://ex und hopp
                 {
                    //DLog(@"Clean ex");
                    NSEnumerator* exEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einExAufnahmePfad;
                    while (einExAufnahmePfad=[exEnum nextObject])
                    {
                      [Utils exMitPfad:einExAufnahmePfad];
                    }//while clearEnum
                 }break;
              }//switch
              //[self resetAdminPlayer];
              //[self setAdminPlayer:AdminLeseboxPfad inProjekt:[self.ProjektPfad lastPathComponent]];
              
              //TitelArray mit angeklickten Namen neu aufsetzen
              NSArray* tempNamenArray=[self.CleanFenster NamenArray];//Namen der Leser
              [self.CleanFenster TitelListeLeeren];
              //DLog(@"Clean tempNamenArray: %@",[tempNamenArray description]);
              
              NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
              NSEnumerator* NamenResetEnum=[tempNamenArray objectEnumerator];
              id einName;
              while (einName=[NamenResetEnum nextObject])
              {
                 if ([[einName objectForKey:@"auswahl"]intValue])//Name ist angeklickt, also einsetzen
                 {
                    //DLog(@"Clean NamenResetEnum: einName objectForKey:@"name" : %@",[[einName objectForKey:@"name"] description]);
                    NSString* tempName=[einName objectForKey:@"name"];
                    //[self setCleanTitelVonLeser:[einName objectForKey:@"name"]];
            //        NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
                    //						//DLog(@"\n\n-----------------------------Clean");//leerer Array für schon vorhandenen TitelDics in Clean
                    NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
                    NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
                    //Array mit den Aufnahmen in der Lesebox für den Leser tempName
                    [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName
                    {
                       //Titel zu tempName zuf√ºgen
                       [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];
                       NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                       id einTitel;
                       int index=0;
                       while(einTitel=[TitelDicEnum nextObject])		//in neueTitelArray neue Titel(nur String) einf√ºllen
                       {
                          [neueTitelArray insertObject:[einTitel objectForKey:@"titel"] atIndex:[neueTitelArray count]];
                          index++;
                       }
                       //DLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
                       
                       
                       NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                       id eineCleanTitelDicZeile;
                       while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                       {
                          int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                          
                          NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:@"titel"]; //Titel aus Clean
                          //DLog(@"tempTitel: %@\n",[tempTitel description]);
                          
                          if ([neueTitelArray containsObject:tempTitel])//tempTitel ist schon in neueTitelArray
                          {
                             //DLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                             int neueAnzahl=0;
                             
                             NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                             id eineTitelZeile;
                             double neuerTitelIndex=-1;
                             BOOL NameSchonDa=NO;
                             while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                             {
                                //DLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                                if ([[eineTitelZeile objectForKey:@"titel"]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                                {
                                   if ([[eineCleanTitelDicZeile objectForKey:@"leser"]containsObject:tempName])
                                   {
                                      //DLog(@"Name schon da: %@",tempName);
                                      neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                      NameSchonDa=YES;
                                   }
                                   else
                                   {
                                      //DLog(@"Name noch nicht da: %@",tempName);
                                      neueAnzahl=[[eineTitelZeile objectForKey:@"clearanzahl"]intValue];
                                      neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                      gefunden=1;
                                   }
                                }
                             }//while
                             if (NameSchonDa)//Einträge l√∂schen
                             {
                                
                                
                                [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                             
                             //DLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                             if (gefunden==1)
                             {
                                
                                int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:@"clearanzahl"]intValue];//Anzahl Aufnahmen zum titel in Clean
                                
                                //DLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                                NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                                [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:@"clearanzahl"];
                                //DLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                                
                                //neuen namen in Liste 'leser'
                                NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:@"leser"]mutableCopy];
                                if (tempArray)
                                {
                                   //DLog(@"tempArray: %@",[tempArray description]);
                                   [tempArray addObject:tempName];
                                   //DLog(@"tempArray neu: %@",[tempArray description]);
                                }
                                [eineCleanTitelDicZeile setObject:tempArray forKey:@"leser"];
                                NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithDouble:[tempArray count]];
                                [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:@"anzleser"];
                                
                                //DLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                                if (neuerTitelIndex>=0)
                                {
                                   [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                   [neueTitelArray removeObject:tempTitel];
                                }
                             }//gefunden
                             
                             
                          }//if containsObject
                       }//while tempEnum
                       
                    }	//Nicht Namenweg
                    //DLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
                    if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
                    {
                       //DLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
                       NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
                       id einNeuerTitel;	
                       while (einNeuerTitel=[nochTitelEnum nextObject])
                       {
                          NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:@"titel"]
                                                                                          forKey:@"titel"];
                          //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
                          [tempDic setObject:[einNeuerTitel objectForKey:@"anzahl"]
                                      forKey:@"anzahl"];
                          //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
                          [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                                      forKey:@"leser"];
                          [tempDic setObject:[NSNumber numberWithInt:0]
                                      forKey:@"auswahl"];
                          [tempDic setObject:[NSNumber numberWithInt:1]
                                      forKey:@"anzleser"];
                          
                          //DLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
                          [CleanTitelDicArray insertObject:tempDic 
                                                   atIndex:[CleanTitelDicArray count]];
                          
                       }
                       
                       //DLog(@"CleanViewNotifikationAktion: 4");
                       
                       
                    }//if TitelArray count
                    
                    /*
                    if([CleanTitelDicArray count])
                    {
                       //DLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
                       [self.CleanFenster setTitelArray:CleanTitelDicArray];
                    }//if
                    */
                 }//Auswahl=1
                 
              } // while einName
              
              if([CleanTitelDicArray count])
              {
                 //DLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
                 [self.CleanFenster setTitelArray:CleanTitelDicArray];
              }//if
              
              
           }
           //else
           //{
           //	//DLog(@"Nichts zu l√∂schen");
           //}
        }//if (clearTitelArray)
     }//if (clearNamenArray)
}
// von AdminPlayer

- (NSArray*)sortNachABC:(NSArray*)derArray
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   tempArray =[derArray mutableCopy];
   //return derArray;
   //[derArray release];
   long anz=[tempArray count];
   BOOL tausch=YES;
   int index=0;
   int stop=0;
   //DLog(@"sortNachABC: derArray vor sortieren: %@",[derArray description]);
   while (tausch&&stop<100)
	  {
        tausch=NO;
        for (index=0;index<anz-1;index++)
        {
           NSString* n=[[[tempArray objectAtIndex:index]componentsSeparatedByString:@" "]objectAtIndex:2];
           NSString* m=[[[tempArray objectAtIndex:index+1]componentsSeparatedByString:@" "]objectAtIndex:2];
           //DLog(@"m: %@  n:%@",m,n);
           if ([m caseInsensitiveCompare:n]==NSOrderedDescending)
           {
              //DLog(@"tauschen:          m: %@  n:%@",m,n);
              tausch=YES;
              [tempArray exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
           }
        }//for index
        stop++;
     }//while tausch
   //DLog(@"sortNachNummer: derArray nach sortieren: %@",[tempArray description]);
   
   
   return tempArray;
}

- (NSArray*)sortNachNummer:(NSArray*)derArray
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   tempArray =[derArray mutableCopy];
   //return derArray;
   //[derArray release];
   long anz=[tempArray count];
   BOOL tausch=YES;
   int index=0;
   int stop=0;
   //DLog(@"sortNachNummer: derArray vor sortieren: %@",[derArray description]);
   while (tausch&&stop<100)
	  {
        tausch=NO;
        for (index=0;index<anz-1;index++)
        {
           int n=[[[[tempArray objectAtIndex:index]componentsSeparatedByString:@" "]objectAtIndex:1]intValue];
           int m=[[[[tempArray objectAtIndex:index+1]componentsSeparatedByString:@" "]objectAtIndex:1]intValue];
           //DLog(@"m: %d  n:%d",m,n);
           if (m>n)
           {
              //DLog(@"m: %d  n:%d",m,n);
              tausch=YES;
              [tempArray exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
           }
        }//for index
        stop++;
     }//while tausch
   //DLog(@"sortNachNummer: derArray nach sortieren: %@",[tempArray description]);
   
   
   return tempArray;
}




- (NSArray*)TitelMitAnzahlArrayVon:(NSString*)derLeser
{
   NSString* titel=@"titel";
   NSString* anzahl=@"anzahl";
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* LeserPfad=[self.ProjektPfad stringByAppendingPathComponent:derLeser];
   //NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:kommentar];//Kommentarordner des Lesers
   
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        //DLog(@"TitelMitAnzahlArrayVon: %@" ,derLeser);
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           long KommentarIndex=NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
           }
           [tempAufnahmenArray removeObject:@"Kommentar"];//Sicherheit. Eventuell von alten Versionen noch vorhanden
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //DLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray: %@",[tempAufnahmenArray description]);
              tempAufnahmenArray=(NSMutableArray*)[self sortNachABC:tempAufnahmenArray];
              //DLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              int anz=1;
              NSString* lastTitel=[NSString string];
              while (eineAufnahme=[enumerator nextObject])
              {
                 //DLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //DLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                 {
                    NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                    if ([tempTitel length])
                    {
                       if ([tempTitelArray containsObject:tempTitel])
                       {
                          anz++;
                          // if (![lastTitel length])
                          {
                             //DLog(@"Titel schon in Liste       tempTitel: %@ anz: %d lastTitel: %@",tempTitel,anz, lastTitel);
                          }
                       }
                       else
                       {
                          //DLog(@"neuer Titel: %@ lastTitel: %@  anz: %d",tempTitel,lastTitel,anz);
                          [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                          if ((![tempTitel isEqualToString:lastTitel])&&[lastTitel length])
                          {
                             NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                                             forKey:titel];
                             [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
                             [tempTitelDicArray insertObject:tempDic
                                                     atIndex:[tempTitelDicArray count]];
                             
                             anz=1;
                             
                          }
                          lastTitel=tempTitel;
                       }
                    }
                    //DLog(@"TitelMitAnzahlArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                 }
                 else
                 {
                    //DLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //letztes Dic einsetzen:
              NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                              forKey:titel];
              [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
              [tempTitelDicArray insertObject:tempDic 
                                      atIndex:[tempTitelDicArray count]];
              
              //DLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //DLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //DLog(@"TitelMitAnzahlArrayVon: %@   %@",derLeser, [tempTitelDicArray description]);
   return tempTitelDicArray;
}


- (NSString*)AufnahmeTitelVon:(NSString*) dieAufnahme
{
   
   NSString* tempAufnahme=[dieAufnahme copy];
   int posLeerstelle1=0;
   int posLeerstelle2=0;
   int Leerstellen=0;
   NSString*  tempString;
   
   int charpos=0;
   int Leerschlag=0;
   int TitelChars=0;
   while (charpos<[tempAufnahme length])
	  {
        if ([tempAufnahme characterAtIndex:charpos]==' ')
        {
           Leerschlag++;
           if (Leerschlag==1)
              Leerstellen++;
           if (Leerstellen==1)
           {
              posLeerstelle1=charpos;//erste Leerstelle gefunden
           }
           if (Leerstellen==2)
           {
              posLeerstelle2=charpos;//zweite Leerstelle gefunden
           }
        }
        else //kein Leerschlag
        {
           Leerschlag=0;
           if (Leerstellen==2)
              TitelChars++; //chars nach 2. Leerstelle
        }
        charpos++;
     }//while pos
   
   //DLog(@"tempAufnahme: %@   pos Leerstelle1:%d pos Leerstelle2:%d  TitelChars: %d",tempAufnahme,posLeerstelle1,posLeerstelle2,TitelChars);
   
   if ((posLeerstelle2 - posLeerstelle1)>1&&TitelChars)//Nummer an zweiter Stelle und chars nach 2. Leerstelle
	  {
        tempString=[tempAufnahme substringFromIndex:posLeerstelle2+1];
     }
   else
	  {
        tempString=[tempAufnahme copy];
     }
   tempString = [tempString stringByDeletingPathExtension];
   return tempString;
}//AufnahmeTitelVon


- (NSArray*)TitelArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad
{
   //DLog(@"TitelArrayVon: derLeser: %@  derProjektPfad: %@",derLeser, derProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   // NSString* locKommentar=NSLocalizedString(@"Comments",@"Anmerkungen");
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   //NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:kommentar];//Kommentarordner des Lesers
   
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           double KommentarIndex=NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
           }
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //DLog(@"\n\nTitelArrayVon:  tempAufnahmenArray: %@\n\n",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              while (eineAufnahme=[enumerator nextObject])
              {
                 //DLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //DLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                 {
                    NSString* tempTitel=[[self AufnahmeTitelVon:eineAufnahme]stringByDeletingPathExtension];
                    if ([tempTitel length])
                    {
                       if (![tempTitelArray containsObject:tempTitel])
                       {
                          [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                       }
                    }
                    //DLog(@"TitelArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                 }
                 else
                 {
                    //DLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //DLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //DLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //DLog(@"TitelArrayVon: ende");
   return tempTitelArray;
}

- (BOOL)AufnahmeIstMarkiertAnPfad:(NSString*)derAufnahmePfad
{
   enum
   {
      Datum=2,
      Bewertung,
      Noten,
      UserMark,
      kAdminMark,
      Kommentar
   };

   BOOL istMarkiert=NO;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* AnmerkungenPfad=[[derAufnahmePfad stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Anmerkungen"];
   
   NSString* tempPfad =[[[derAufnahmePfad lastPathComponent]stringByDeletingPathExtension]stringByAppendingPathExtension:@"txt"];
   AnmerkungenPfad=[AnmerkungenPfad stringByAppendingPathComponent:tempPfad];
   
   if ([Filemanager fileExistsAtPath:AnmerkungenPfad])
   {
      //DLog(@"File exists an Pfad: %@",derAufnahmePfad);
      NSString* tempKommentarString=[NSString stringWithContentsOfFile:AnmerkungenPfad encoding:NSMacOSRomanStringEncoding error:NULL];
      NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
      //DLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
      if (tempKommentarArrary &&[tempKommentarArrary count])
      {
         NSNumber* AdminMarkNumber=[tempKommentarArrary objectAtIndex:kAdminMark];
         //DLog(@"istMarkiert		AdminMarkNumber: %d",[AdminMarkNumber intValue]);
         
         istMarkiert=[AdminMarkNumber intValue];
         
      }
      
      
   }//file exists
   else
   {
      //DLog(@"Kein File an Pfad: %@",derAufnahmePfad);
      
   }
   
   
   return istMarkiert;
}
@end
