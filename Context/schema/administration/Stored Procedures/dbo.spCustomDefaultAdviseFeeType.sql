SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




 

CREATE PROCEDURE [dbo].[spCustomDefaultAdviseFeeType]

@IndigoClientId bigint,

@SourceIndigoClientId bigint

AS


Declare @StampUser int =0 , @StampDate datetime=getdate(), @StampCreateAction char='C'


 IF  EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdviseFeeType]') AND type in (N'U'))    

BEGIN    
	INSERT INTO policymanagement..TAdviseFeeType (Name,TenantId,IsArchived,ConcurrencyId,IsRecurring,GroupId,RefAdviseFeeTypeId)
		OUTPUT 
		Inserted.Name,Inserted.TenantId,Inserted.IsArchived,Inserted.ConcurrencyId,Inserted.AdviseFeeTypeId,@StampCreateAction,@StampDate,@StampUser,
		Inserted.IsRecurring,Inserted.GroupId,Inserted.RefAdviseFeeTypeId
			INTO policymanagement..TAdviseFeeTypeAudit(
	    Name,TenantId,IsArchived,ConcurrencyId,AdviseFeeTypeId,StampAction,StampDateTime,StampUser,
		IsRecurring,GroupId,RefAdviseFeeTypeId)
		SELECT Name,@IndigoClientId,IsArchived,ConcurrencyId,IsRecurring,GroupId,RefAdviseFeeTypeId 
			FROM policymanagement..TAdviseFeeType AFY 
		WHERE AFY.TenantId = @SourceIndigoClientId AND AFY.IsArchived=0

END    

GO
