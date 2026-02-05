SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrMatrixTerm_Custom_Create]  
@Identifier varchar(255),  
@Ordinal tinyint,  
@Starting tinyint,  
@Ending tinyint,  
@TenantGuid uniqueidentifier,  
@Tenant bigint,  
@ATRTemplate uniqueidentifier,  
@Guid uniqueidentifier  
  
  
AS  
  
DECLARE @AtrMatrixTermId bigint  
  
DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'  
  
BEGIN  
 INSERT TAtrMatrixTerm  
  (Identifier,  
   Ordinal,  
   Starting,  
   Ending,  
   IndigoClientId,  
   AtrTemplateGuid,  
   Guid,  
   ConcurrencyId)  
  
 SELECT @Identifier,@Ordinal,@Starting,@Ending,@Tenant,@ATRTemplate,@Guid,1  
  
 SELECT @AtrMatrixTermId=SCOPE_IDENTITY()  
 
  
 INSERT TAtrMatrixTermCombined  
  (Guid,  
  AtrMatrixTermId,  
  Identifier,  
  Ordinal,  
  Starting,  
  Ending,  
  IndigoClientId,  
  IndigoClientGuid,  
  AtrTemplateGuid,  
  ConcurrencyId)  
  
  SELECT @Guid,@AtrMatrixTermId,@Identifier,@Ordinal,@Starting,@Ending,@Tenant,@TenantGuid,@ATRTemplate,1  
   
EXEC FactFind..SpNAuditAtrMatrixTermCombined @StampUser,@AtrMatrixTermId,'C'
  
  
END  
  
GO
