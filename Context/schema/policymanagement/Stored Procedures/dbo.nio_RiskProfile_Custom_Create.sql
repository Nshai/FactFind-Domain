SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RiskProfile_Custom_Create]  
@RiskProfileId bigint=null,  
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
  
  
  
IF ISNULL(@RiskProfileId,0)=0  
  

BEGIN  
 INSERT TRiskProfile(  
 Descriptor,  
 BriefDescription,  
 IndigoClientId,  
 RiskNumber,  
 LowerBand,  
 UpperBand,  
 AtrTemplateGuid,  
 Guid,  
 ConcurrencyId)  
  
 SELECT @Descriptor, @BriefDescription, @IndigoClientId, @RiskNumber, @LowerBand,  
   @UpperBand, @ATRTemplate, @Guid, 1  
  
 SELECT @RiskProfileId=SCOPE_IDENTITY()  
  
 insert into TRiskProfileAudit(Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,StampAction,StampDateTime,StampUser)
	select	Descriptor,BriefDescription,IndigoClientId,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,Guid,ConcurrencyId,RiskProfileId,
	'C',getdate(),'99887766'
	from TRiskProfile where @Guid = Guid

 INSERT TRiskProfileCombined(
 Guid   ,
 RiskProfileId,  
 Descriptor,  
 BriefDescription,  
 IndigoClientId,  
 IndigoClientGuid,  
 RiskNumber,  
 LowerBand,  
 UpperBand,  
 AtrTemplateGuid,  
 ConcurrencyId)  
  
 SELECT @Guid,@RiskProfileId,@Descriptor, @BriefDescription, @IndigoClientId,@TenantGuid, @RiskNumber, @LowerBand,  
   @UpperBand, @ATRTemplate, 1  
  
	insert into TRiskProfileCombinedAudit	
	(RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,StampAction,StampDateTime,StampUser)
select
RiskProfileId,Descriptor,BriefDescription,IndigoClientId,IndigoClientGuid,RiskNumber,LowerBand,UpperBand,AtrTemplateGuid,ConcurrencyId,Guid,
'C',getdate(),'99887766'
from TRiskProfileCombined
where @Guid = Guid

END  
  




SELECT @Guid AS Guid  
  
GO
