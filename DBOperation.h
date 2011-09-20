//
//  DBOperation.h
//  
//
//  Created by Andy on 9/19/11.
//  Copyright 2011 JXT . All rights reserved.
//

#import <Foundation/Foundation.h>
#import<sqlite3.h>


@interface DBOperation : NSObject {
    NSDictionary *dic;
    sqlite3 *db;
}
-(void)openDB;
-(void)createTable:(NSString *)sql;
-(void)insertToTable:(NSString *)sql;
-(NSDictionary *)selectFromTable:(NSString *)sql;
-(NSString *)filePath;

@end
