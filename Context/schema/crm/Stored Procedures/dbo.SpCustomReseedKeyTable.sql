 


CREATE PROC  [dbo].[SpCustomReseedKeyTable]
(@threshold int = 85, @days_left int = 14, @recipients varchar(500) =   'dba@intelliflo.com'  )
AS
BEGIN
/**************************************************************
** PR   Date                  Author    Description 
** --   --------              -------   ------------------
** 1    September  2018        Lan       Create Sproc

EXEC [dbo].[SpCustomReseedKeyTable] @threshold   = 80, @days_left   = 14, @recipients  =   'dba@intelliflo.com'
****************************************************************/

SET NOCOUNT ON
 
BEGIN TRY
 

DECLARE @sql_msg VARCHAR(max) = '' ,@subject VARCHAR(250), @newline char(2) = CHAR(10)+ CHAR(10)
DECLARE @int int =2147483647  ,  @tablename sysname -- @bigint bigint = 9223372036854775807 
  

IF OBJECT_ID('tempdb..#ID') IS NOT NULL DROP TABLE #ID
CREATE TABLE #ID ( tablename sysname, min_value int, max_value int, range_value int, current_ident int, datatype sysname , max_datatype int , leeway int , pct DECIMAL(5,2))

INSERT INTO #ID (tablename  , min_value  , max_value  , current_ident   , datatype   , max_datatype   )
SELECT '[dbo].[TLeadKey]', MIN([LeadKeyId]), MAX([LeadKeyId]) , IDENT_CURRENT('[dbo].[TLeadKey]') ,'int', @int  FROM [dbo].[TLeadKey]

INSERT INTO #ID (tablename  , min_value  , max_value  , current_ident   , datatype   , max_datatype   )
SELECT '[dbo].[TPractitionerKey]', MIN([PractitionerKeyId]), MAX([PractitionerKeyId]) , IDENT_CURRENT('[dbo].[TPractitionerKey]') ,'int', @int  FROM [dbo].[TPractitionerKey]


UPDATE D
SET range_value = ( max_value - min_value )
, leeway = ( max_datatype - max_value )
, pct = ( max_value *100.00/max_datatype )
FROM #ID D


/*Either the ID usage is over threshold or there is not too many headroom for new keys within @days_left */
DELETE D FROM #ID D  
WHERE  
( ( pct <  @threshold ) AND ( leeway > range_value * @days_left ) )
OR current_ident < min_value  -- In case it is already reseeded 
 

WHILE ( SELECT COUNT(1) FROM #ID) > 0
BEGIN
	SELECT TOP 1 @tablename = TABLENAME 
	, @sql_msg = 'Database:'+ CHAR(9)+ DB_NAME() + @newline + 'TableName:'+ CHAR(9)+ tablename + @newline + 'Old Min Value: '+ CHAR(9)+ cast(min_value as varchar(10)) + @newline + 'Old Max Value: '+ CHAR(9)+ cast(max_value as varchar(10))+ @newline + + 'Percentage Used: '+ CHAR(9)+ cast(pct as varchar(10)) + '%' + @newline +   'Reseed Value: '+ CHAR(9)+ '1'
	FROM #ID
	PRINT (  'Reseed '+ @tablename + ' to 1 ')

	DBCC CHECKIDENT (@tablename, RESEED, 1);

	SET @subject = CAST(@@SERVERNAME AS varchar(128) )  + ': Reseed Key Table ' + @tablename
 
	EXEC msdb.dbo.sp_send_dbmail    @recipients = @recipients 	, @body =@sql_msg	, @subject = @subject	, @profile_name = 'DBAMON' 


	DELETE D FROM #ID D WHERE TABLENAME = @tablename 

END

 
 
 

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @ErrorLine INT
	DECLARE @ErrorNumber INT

	SELECT @ErrorMessage = ERROR_MESSAGE(),
	@ErrorSeverity = ERROR_SEVERITY(),
	@ErrorState = ERROR_STATE(),
	@ErrorNumber = ERROR_NUMBER(),
	@ErrorLine = ERROR_LINE()
 

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

        
SET NOCOUNT OFF
END







 

 