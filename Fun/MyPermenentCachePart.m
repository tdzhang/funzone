//
//  MyPermenentCachePart.m
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPermenentCachePart.h"

@implementation MyPermenentCachePart
static UIManagedDocument *document;
static NSMutableArray* url2datas;
static NSMutableDictionary* keyToFindIfExist;
static int datasize;
static int data_add_count;
static bool init_flag=false;

+(NSMutableArray *)url2datas{
    return url2datas;
}

+(void)init{
    data_add_count=0;
    NSURL *url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url=[url URLByAppendingPathComponent:@"DefaultURLConnectionCacheDatabaseOrangeParc"];
    keyToFindIfExist=[NSMutableDictionary dictionary];
    document = [[UIManagedDocument alloc] initWithFileURL:url];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        //the document file does not exist, so create the file based on the url
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            //document is ready; doing stuff with the UIManagedDocument
            NSLog(@"success init document1");
            [MyPermenentCachePart startFetchingData];
            init_flag=true;
            NSLog(@"success feching document1");
            [self sizeControl];
            NSLog(@"success sizeControl document1");
            
        }];
    }else if(self.document.documentState == UIDocumentStateClosed){
        //the document is exist and closed, so just open it
        [self.document openWithCompletionHandler:^(BOOL success){
            NSLog(@"success init document2");
            [MyPermenentCachePart startFetchingData];
            init_flag=true;
            NSLog(@"success feching document2");
            [self sizeControl];
            NSLog(@"success sizeControl document2");
            ;
        }];
    }else if(self.document.documentState == UIDocumentStateNormal){
        //already open, start to stuff
        NSLog(@"success init document3");
        [MyPermenentCachePart startFetchingData];
        NSLog(@"success feching document2");
        init_flag=true;
        [self sizeControl];
        NSLog(@"success sizeControl document3");
    }
}

+(UIManagedDocument *)document{
    return document;
}

+(void)startFetchingData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"URLConnectionCache"];
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:@"urlName"ascending:YES];
    request.sortDescriptors=[NSArray arrayWithObjects:sortByID, nil];
    //Executing the fetch
    NSManagedObjectContext *moc=[document managedObjectContext];
    NSError *error;
    url2datas = [[moc executeFetchRequest:request error:&error] mutableCopy];
    
    datasize=0;

    NSLog(@"a:%d",[url2datas count]);
    for (URLConnectionCache* temp_url2data in url2datas) {
        [keyToFindIfExist setValue:@"1" forKey:temp_url2data.urlName];
        datasize+=[temp_url2data.data length];
        NSLog(@"c:%@ ------> %d",temp_url2data.urlName,[temp_url2data.data length]);
    }
    //NSLog(@"a:%d",[url2datas count]);

    //add the data to cache
    for (URLConnectionCache* url2data in [MyPermenentCachePart url2datas]) {
        [Cache preAddDataToCache:url2data.urlName withData:url2data.data];
    }
}


+ (void) addDataToCache:(NSString*)urlName withData:(NSData*)data
{
    //dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{  
        //get the image data
        if (!init_flag) {
            [MyPermenentCachePart init];
        }
        
        if ([keyToFindIfExist objectForKey:urlName]) {
            return;
        }
        [keyToFindIfExist setValue:@"1" forKey:urlName];
        
        NSString *key = urlName;
        
        //creat new event
        URLConnectionCache *oneMap=(URLConnectionCache *)[NSEntityDescription insertNewObjectForEntityForName:@"URLConnectionCache" inManagedObjectContext: document.managedObjectContext];
        oneMap.urlName=key;
        oneMap.data=data;

        data_add_count++;
    if (data_add_count%8==0) {
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
            if(!success)
            {
                NSLog(@"failed to save document %@",document.localizedName);
                NSLog(@"%@ ---%d",key,[data length]);
            }
            else{
                datasize+=[data length];
                NSLog(@"success saved");
                NSLog(@"%@ ---%d",key,[data length]);
            }
        }];
    }
        /*
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
            if(!success) 
            {
                NSLog(@"failed to save document %@",document.localizedName);
                NSLog(@"%@ ---%d",key,[data length]);
            }
            else{
                datasize+=[data length];
                NSLog(@"success saved");
                NSLog(@"%@ ---%d",key,[data length]);
            }
        }];
         */
    //});
}

+(void)EXITit{
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        if(!success) 
        {
            NSLog(@"failed to save document %@",document.localizedName);
            //NSLog(@"%@ ---%d",key,[data length]);
        }
        else{
            //datasize+=[data length];
            NSLog(@"success saved");
            //NSLog(@"%@ ---%d",key,[data length]);
        }
    }];
}

//control the total size within a certain range
+(void)sizeControl{
    if (datasize<MYPERMANENTCACHEPART_SATASIZE_LIMITE) {
        NSLog(@"sizeControl not activate:%d",datasize);
        return;
    } 
    else {
        while (datasize>MYPERMANENTCACHEPART_SATASIZE_LIMITE/2&&url2datas&&[url2datas count]>0) {
            //remove the middle part data until it reached the half size of the limite;
            URLConnectionCache *event=[url2datas objectAtIndex:([url2datas count]-1)/2];
            datasize-=[event.data length];
            [url2datas removeObject:event];
            [document.managedObjectContext deleteObject:event];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                if(!success) NSLog(@"failed to delete document %@",document.localizedName);
                else NSLog(@"success delete a event, now %d",datasize);
            }];
        }
    }
}



@end
