//
//  DocManager.m
//  Cookie
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "DocManager.h"

@implementation DocManager

static NSURL *_documentDir;
static NSMutableDictionary *documentDict;


/**************************************************************************
 Setup document directory URL
 *************************************************************************/
+ (NSURL*)documentDir {
    if (_documentDir == nil) {
        _documentDir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                              inDomain:NSUserDomainMask
                                                     appropriateForURL:nil
                                                                create:YES
                                                                 error:NULL];
    }
    return _documentDir;
}

/**************************************************************************
 Document saving helper
 *************************************************************************/
+ (void)saveDocument:(UIManagedDocument*)document withURL:(NSURL*)url {
    [document saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"document Helper - Document %@ saved", document.localizedName);
        }
        else {
            NSLog(@"document Helper - ERROR: Failed to save %@", document.localizedName);
        }
    }];
}


/**************************************************************************
 Open or create the document as needed before executing a block using it
 *************************************************************************/
+ (void)useSharedManagedDocumentForDocumentNamed:(NSString *)documentName
                                  toExecuteBlock:(completion_block_t)completionBlock {
    UIManagedDocument *document;
    NSURL *url = [[DocManager documentDir] URLByAppendingPathComponent:documentName];
    
    // get the ManagedDocument from "documentDict", if not exist, create it
    @synchronized(documentDict) {
        if (documentDict == nil) {
            documentDict = [NSMutableDictionary new];
        }

        document = [documentDict objectForKey:documentName];
        
        if (document == nil) {
            document = [[UIManagedDocument alloc] initWithFileURL:url];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
                [document saveToURL:url 
                   forSaveOperation:UIDocumentSaveForCreating 
                  completionHandler:^(BOOL success) {
                      if (success) {
                          NSLog(@"document Helper - Created %@ on disk", document.localizedName);
                          //after create the file, execute the block
                          completionBlock(document);
                          //then save the change after the execution
                          [DocManager saveDocument:document withURL:url];
                      } else {
                          NSLog(@"document Helper - ERROR: Failed to create %@ on disk", document.localizedName);
                      }
                  }];
            }else if(document.documentState == UIDocumentStateClosed){
                //the document is exist and closed, so just open it
                [document openWithCompletionHandler:^(BOOL success){
                    //after opening, execute the block
                    completionBlock(document);
                    //then save the change
                    [DocManager saveDocument:document withURL:url];
                }];
            }else if(document.documentState == UIDocumentStateNormal){
                //if already open normal, directly execute the block 
                completionBlock(document);
                //then save the change after the execution
                [DocManager saveDocument:document withURL:url];
            }
            [documentDict setObject:document forKey:documentName];
        }
        else {
            if (document.documentState == UIDocumentStateNormal) {
                //if already open normal, directly execute the block 
                completionBlock(document);
                //then save the change after the execution
                [DocManager saveDocument:document withURL:url];
                
            } else if (document.documentState == UIDocumentStateClosed) {
                //else if the ManagedDocoment is closed, need to be reopened
                [document openWithCompletionHandler:^(BOOL success) {
                    if (success) {
                        //after opening, execute the block
                        completionBlock(document);
                        //then save the change
                        [DocManager saveDocument:document withURL:url];
                    }
                }];
            }
        }
    }
    
   
}



@end
