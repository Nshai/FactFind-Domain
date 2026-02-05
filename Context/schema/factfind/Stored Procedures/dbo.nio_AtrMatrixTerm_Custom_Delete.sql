SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrMatrixTerm_Custom_Delete]  
@Guid uniqueidentifier  
  
  
  
AS  

  
DECLARE @StampUser varchar(255),@AtrMatrixTermId bigint

SELECT @StampUser='999999998'    

IF ISNULL(@AtrMatrixTermId,0)=0
BEGIN
	SELECT @AtrMatrixTermId=AtrMatrixTermId FROM TAtrMatrixTermCombined WHERE Guid=@Guid 
END
  
BEGIN  
 

 DELETE FROM TAtrMatrixTerm WHERE Guid=@Guid  

 EXEC FactFind..SpNAuditAtrMatrixTermCombined @StampUser,@AtrMatrixTermId,'D'
  
 DELETE FROM TAtrMatrixTermCombined WHERE Guid=@Guid  
  
END  
  
GO
