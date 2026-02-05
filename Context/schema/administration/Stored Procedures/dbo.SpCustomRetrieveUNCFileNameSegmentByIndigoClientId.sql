CREATE PROCEDURE [dbo].[SpCustomRetrieveUNCFileNameSegmentByIndigoClientId]  
	@IndigoClientId BIGINT
AS
--**********************************************************************************  
--Date : 01-May-2012
--Author : KK  
--Return the unc-filename for Indigoclientid
--**********************************************************************************  
SET NOCOUNT ON   

DECLARE @FileNameSegment AS VARCHAR(255)

SELECT 
	@FileNameSegment = Value 
FROM 
	TIndigoClientPreference 
WHERE 
	IndigoClientId = @IndigoClientId 
	And PreferenceName = 'UNC_BulkFileValuationFileNameSegment' 
	And Disabled = 0
  
 SELECT FileNameSegment = @FileNameSegment  
  
SET NOCOUNT OFF  
  
RETURN (0) 