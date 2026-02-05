SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateRefMortgageRepaymentMethod]
@StampUser varchar (255),
@MortgageRepaymentMethod varchar (50),
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RefMortgageRepaymentMethodId bigint

  INSERT INTO TRefMortgageRepaymentMethod (
    MortgageRepaymentMethod, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @MortgageRepaymentMethod, 
    @IndigoClientId, 
    1) 

  SELECT @RefMortgageRepaymentMethodId = SCOPE_IDENTITY()
  INSERT INTO TRefMortgageRepaymentMethodAudit (
    MortgageRepaymentMethod, 
    IndigoClientId, 
    ConcurrencyId,
    RefMortgageRepaymentMethodId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.MortgageRepaymentMethod, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.RefMortgageRepaymentMethodId,
    'C',
    GetDate(),
    @StampUser

  FROM TRefMortgageRepaymentMethod T1
 WHERE T1.RefMortgageRepaymentMethodId=@RefMortgageRepaymentMethodId
  EXEC SpRetrieveRefMortgageRepaymentMethodById @RefMortgageRepaymentMethodId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
