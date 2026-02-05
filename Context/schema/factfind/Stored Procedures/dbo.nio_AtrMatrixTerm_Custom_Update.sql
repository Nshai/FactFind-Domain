SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrMatrixTerm_Custom_Update]  
@AtrMatrixTermId bigint=null,  
@Identifier varchar(255),  
@Ordinal tinyint,  
@Starting tinyint,  
@Ending tinyint,  
@TenantGuid uniqueidentifier,  
@Tenant bigint,  
@ATRTemplate uniqueidentifier,  
@Guid uniqueidentifier  
  
  
  
AS  

DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'   

IF ISNULL(@AtrMatrixTermId,0)=0
BEGIN
	SELECT @AtrMatrixTermId=AtrMatrixTermId FROM TAtrMatrixTermCombined WHERE Guid=@Guid 
END
  
BEGIN  


 Update TAtrMatrixTerm   
 SET Identifier=@Identifier,Ordinal=@Ordinal,  
 Starting=@Starting,Ending=@Ending   
  
 WHERE Guid=@Guid AND AtrMatrixTermId=@AtrMatrixTermId  

 
 EXEC FactFind..SpNAuditAtrMatrixTermCombined @StampUser,@AtrMatrixTermId,'U'
  
 Update TAtrMatrixTermCombined   
 SET Identifier=@Identifier,Ordinal=@Ordinal,  
 Starting=@Starting,Ending=@Ending   
  
 WHERE Guid=@Guid AND AtrMatrixTermId=@AtrMatrixTermId  
  
  
  
END  
  
GO
