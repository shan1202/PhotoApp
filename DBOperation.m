//
//  DBOperation.m
//  
//
//  Created by Andy on 9/19/11.
//  Copyright 2011 JXT. All rights reserved.
//

#import "DBOperation.h"


@implementation DBOperation


-(NSString *)filePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
	return [directory stringByAppendingPathComponent:@"data.sql"];
}

-(void)openDB{
    if (sqlite3_open([[self filePath]UTF8String],&db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"DataBase failed to open!");
    }
}

-(void)createTable:(NSString *)sql{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert(0,@"Table failed to create.");
	}
    sqlite3_close(db);
}

-(void)insertToTable:(NSString *)sql{
    char* err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
		sqlite3_close(db);
		NSAssert1(0,@"Table failed to update.%s",err);
	}
    sqlite3_close(db);

}

-(NSDictionary *)selectFromTable:(NSString *)sql{
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			char *key = (char *)sqlite3_column_text(stmt, 0);
            char *theme = (char *)sqlite3_column_text(stmt, 1);
            char *name = (char *)sqlite3_column_text(stmt, 2);
            char *place = (char *)sqlite3_column_text(stmt, 3);
            char *other = (char *)sqlite3_column_text(stmt, 4);

			dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%s",key],@"id",[NSString stringWithFormat:@"%s",theme],@"Theme",
                   [NSString stringWithFormat:@"%s",name],@"Name",[NSString stringWithFormat:@"%s",place],@"Place",[NSString stringWithFormat:@"%s",other],@"Other",nil];
		}
	}
    
	sqlite3_finalize(stmt);
    sqlite3_close(db);

    return dic;
}

@end
