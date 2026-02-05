SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RiskProfile_Custom_Delete]  
@Guid uniqueidentifier  
  
  
AS  
  
 insert into TRiskProfileAudit(Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,StampAction,StampDateTime,StampUser)
	select	Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,
	'D',getdate(),'99887766'
	from TRiskProfile where @Guid = Guid


	insert into TRiskProfileCombinedAudit	
	(RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,StampAction,StampDateTime,StampUser)
select
RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,
'D',getdate(),'99887766'
from TRiskProfileCombined
where	@Guid = Guid
  
DELETE FROM TRiskProfile WHERE Guid=@Guid  
  
DELETE FROM TRiskProfileCombined WHERE Guid=@Guid  
  
  
GO
