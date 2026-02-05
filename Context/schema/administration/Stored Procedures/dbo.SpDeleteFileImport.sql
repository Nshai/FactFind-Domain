 
CREATE PROCEDURE [dbo].[SpDeleteFileImport]
(@Days2Keep int, @BatchSize int = NULL)
AS
BEGIN
SET NOCOUNT ON
Declare @iBatchSize INT,  @iDays2Keep INT, @sql_msg varchar , @minDate DATETIME, @rows INT

SELECT @iBatchSize = ISNULL(@BatchSize, 100000) 
SELECT @iDays2Keep = ISNULL(@Days2Keep ,100 )
SELECT @minDate = DATEADD( DAY, -@iDays2Keep, GETDATE())
SELECT @rows = 1
 
If (@iDays2Keep < 100) 
BEGIN
	RAISERROR ('Days2Keep parameter value has to be greater than or equal to 100 ! '	, 16, 1);
 	RETURN (-1);
END


/*
We don't wrap the deletion within transaction to reduce transaction size. 
If child table fails, the rest records can always be picked up in the next round of purge
*/

WHILE ( @rows > 0 )
BEGIN
	DELETE TOP (@iBatchSize) D
	FROM  TFileImportItem D INNER JOIN TFileImportHeader H
	ON D.FileImportHeaderId = H.FileImportHeaderId
	WHERE H.Status = 'Complete'
	AND  H.LastUpdatedDate < @minDate
	
	SELECT @rows = @@ROWCOUNT

END 

SELECT @rows = 1

WHILE ( @rows > 0 )
BEGIN
	DELETE D FROM TFileImportHeader D
	WHERE Status = 'Complete'
	AND  LastUpdatedDate < @minDate

	SELECT @rows = @@ROWCOUNT

END   

SET NOCOUNT OFF
END
GO


