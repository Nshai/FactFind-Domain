SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateRefMortgageBorrowerType]
@StampUser varchar (255),
@MortgageBorrowerType varchar (50),
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RefMortgageBorrowerTypeId bigint

  INSERT INTO TRefMortgageBorrowerType (
    MortgageBorrowerType, 
    ConcurrencyId ) 
  VALUES (
    @MortgageBorrowerType, 
    1) 

  SELECT @RefMortgageBorrowerTypeId = SCOPE_IDENTITY()
  INSERT INTO TRefMortgageBorrowerTypeAudit (
    MortgageBorrowerType, 
    ConcurrencyId,
    RefMortgageBorrowerTypeId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.MortgageBorrowerType, 
    T1.ConcurrencyId,
    T1.RefMortgageBorrowerTypeId,
    'C',
    GetDate(),
    @StampUser

  FROM TRefMortgageBorrowerType T1
 WHERE T1.RefMortgageBorrowerTypeId=@RefMortgageBorrowerTypeId
  EXEC SpRetrieveRefMortgageBorrowerTypeById @RefMortgageBorrowerTypeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
