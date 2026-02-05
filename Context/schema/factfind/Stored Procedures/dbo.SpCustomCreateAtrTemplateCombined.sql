SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateAtrTemplateCombined]
  @StampUser varchar(255),
  @Guid uniqueidentifier
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN	
  INSERT INTO TAtrTemplateCombined (
    Guid,
    AtrTemplateId,
    Identifier,
    Descriptor,
    Active,
    HasModels,
    BaseAtrTemplate,
    ConcurrencyId,
    IndigoClientId,
    IndigoClientGuid)
  SELECT
    A.Guid,
    A.AtrTemplateId,
    A.Identifier,
    A.Descriptor,
    A.Active,
    A.HasModels,
    A.BaseAtrTemplate,
    A.ConcurrencyId,
    I.IndigoClientId,
    I.Guid
  FROM
    TAtrTemplate A
    JOIN Administration..TIndigoClient I ON I.IndigoClientId = A.IndigoClientId
  WHERE
    A.Guid = @Guid

  INSERT INTO TAtrTemplateCombinedAudit (  
    Guid,
    AtrTemplateId,
    Identifier,
    Descriptor,
    Active,
    HasModels,
    BaseAtrTemplate,
    IndigoClientId,
    IndigoClientGuid,
    ConcurrencyId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    Guid,
    AtrTemplateId,
    Identifier,
    Descriptor,
    Active,
    HasModels,
    BaseAtrTemplate,
    IndigoClientId,
    IndigoClientGuid,
    ConcurrencyId,
    'C',
    GETDATE(),
    @StampUser
  FROM
    TAtrTemplateCombined
  WHERE
    Guid = @Guid

  SELECT 
    *
  FROM
    TAtrTemplateCombined
  WHERE
    Guid = @Guid
  FOR
    XML RAW
    
  IF @@ERROR != 0 GOTO errh
  IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
IF @tx = 0 ROLLBACK TRANSACTION TX
RETURN (100)
GO
