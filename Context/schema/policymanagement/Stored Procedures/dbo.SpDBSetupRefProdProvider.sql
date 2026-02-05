SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDBSetupRefProdProvider]  
@StampUser varchar (255),  
@CRMContactId bigint ,  
@RefProdProviderId bigint  
  
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  --DECLARE @RefProdProviderId bigint  
  
  SET IDENTITY_INSERT TRefProdProvider ON  
  
  INSERT INTO TRefProdProvider   
  ( CRMContactId , RetireFg, ConcurrencyId , RefProdProviderId )   
  VALUES ( @CRMContactId, 0, 1 , @RefProdProviderId )   
  
  SELECT @RefProdProviderId = SCOPE_IDENTITY()  
  
  SET IDENTITY_INSERT TRefProdProvider OFF  
  
  INSERT INTO TRefProdProviderAudit   
  ( CRMContactId, FundProviderId, NewProdProviderId, RetireFg, ConcurrencyId,RefProdProviderId,StampAction,StampDateTime,StampUser)  
  SELECT T1.CRMContactId, T1.FundProviderId, T1.NewProdProviderId, T1.RetireFg, T1.ConcurrencyId,T1.RefProdProviderId,'C',GetDate(),@StampUser  
  FROM TRefProdProvider T1  
 WHERE T1.RefProdProviderId=@RefProdProviderId  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
  

GO
