SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RiskProfile_Custom_Update]  
@RiskProfileId bigint,  
@RiskNumber int,  
@BriefDescription varchar(255),  
@Descriptor varchar(5000),  
@TenantGuid uniqueidentifier,  
@LowerBand int,  
@UpperBand int,  
@ATRTemplate uniqueidentifier,  
@IndigoClientId bigint,  
@Guid uniqueidentifier  
  
  
  
AS
BEGIN  
  
 insert into TRiskProfileAudit(Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,StampAction,StampDateTime,StampUser)
	select	Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,
	'U',getdate(),'99887766'
	from TRiskProfile where @RiskProfileId = RiskProfileId


	insert into TRiskProfileCombinedAudit	
	(RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,StampAction,StampDateTime,StampUser)
select
RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,
'U',getdate(),'99887766'
from TRiskProfileCombined
where	@RiskProfileId = RiskProfileId and @TenantGuid = IndigoClientGuid

 UPDATE TRiskProfileCombined  
 SET Descriptor=@Descriptor,  
 BriefDescription=@BriefDescription,  
 RiskNumber=@RiskNumber,  
 LowerBand=@LowerBand,  
 UpperBand=@UpperBand,
 ConcurrencyId=ConcurrencyId + 1  
  
 WHERE Guid=@Guid   
 AND RiskProfileId=@RiskProfileId  
  
 UPDATE TRiskProfile  
 SET Descriptor=@Descriptor,  
 BriefDescription=@BriefDescription,  
 RiskNumber=@RiskNumber,  
 LowerBand=@LowerBand,  
 UpperBand=@UpperBand,
 ConcurrencyId=ConcurrencyId + 1
   
 WHERE Guid=@Guid   
 AND RiskProfileId=@RiskProfileId  
   
   
END
GO
