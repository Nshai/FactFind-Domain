SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomDropChangeLogTriggers]
	@TableName varchar(100),
	@Execute bit = 0

AS 


DECLARE @drop_cmd nvarchar(1000)
DECLARE @trigger sysname
DECLARE @owner sysname
DECLARE @uid int

DECLARE TGCursor CURSOR FOR
SELECT name, uid FROM sysobjects WHERE type = 'TR' and parent_obj = OBJECT_ID(@TableName) 
OPEN TGCursor
FETCH NEXT FROM TGCursor INTO @trigger, @uid
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @drop_cmd = N'DROP TRIGGER [' + user_name(@uid) + '].[' + @trigger + ']'

	IF @Execute = 1 
		EXEC sp_executesql @drop_cmd
	ELSE
		PRINT @drop_cmd

FETCH next FROM TGCursor INTO @trigger, @uid
END

CLOSE TGCursor
DEALLOCATE TGCursor
