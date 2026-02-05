SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnComputePHIClientToAge](@Term int, @PolicyStartDate datetime,@CRMContactId bigint)
RETURNS int
AS
BEGIN

DECLARE @ToAge int

	IF(@Term IS NULL OR @Term = 0 OR @PolicyStartDate IS NULL OR @CRMContactId IS NULL)
	RETURN 0
	ELSE
			SELECT @ToAge =				
				CASE   
						WHEN C.DOB IS NULL THEN 0
						ELSE CONVERT(INT, ((@Term - DateDiff(year,@PolicyStartDate,GetDate())) + DateDiff(year, C.DOB,GetDate())))		       
				 END			 
			FROM CRM..TCRMContact C
			WHERE CRMContactId = @CRMContactId
			
	RETURN @ToAge
	
END
GO
