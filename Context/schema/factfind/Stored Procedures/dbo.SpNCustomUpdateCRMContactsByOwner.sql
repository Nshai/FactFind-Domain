SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateCRMContactsByOwner]  
 @Owner varchar(16),  
 @CRMContactId bigint output, -- this should always be the primary ff client.  
 @CRMContactId2 bigint output -- for edits this could be the existing 2nd owner against the data line  
AS   
-- Get second owner Id for the factfind.  
DECLARE @FF2 bigint  
SELECT @FF2 = CRMContactId2 FROM FactFind..TFactFind WHERE CRMContactId1 = @CRMContactId  
-- No second owner then set to null.  
IF @FF2 = 0 SET @FF2 = NULL  
-- If owner is Client 1  
IF @Owner = 'Client 1'   
 -- make sure second owner is null  
 SET @CRMContactId2 = NULL   
-- Client 2 and FF2 is not null (dont' let crmcontactid become null)
ELSE IF @Owner = 'Client 2'  AND @FF2 IS NOT NULL     
 -- Update the primary owner and null second id  
 SELECT @CRMContactId = @FF2, @CRMContactId2 = NUlL  
-- Joint (and the second FF owner is available)   
ELSE IF @Owner = 'Joint' AND @FF2 IS NOT NULL  
 SET @CRMContactId2 = @FF2  
-- If we're here this means that the owner is specified as Joint   
-- but there's no second client listed for the fact find.  
-- We should leave the second owner as the value that was passed in.  
GO
