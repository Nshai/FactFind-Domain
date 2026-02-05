SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveFormatValidationByIndigoClientIdAndEntity]
@IndigoClientId bigint,
@Entity varchar (50)
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FormatValidationId AS [FormatValidation!1!FormatValidationId], 
    T1.IndigoClientId AS [FormatValidation!1!IndigoClientId], 
    T1.Entity AS [FormatValidation!1!Entity], 
    T1.RuleType AS [FormatValidation!1!RuleType], 
    T1.ValidationExpression AS [FormatValidation!1!ValidationExpression], 
    ISNULL(T1.ErrorMessage, '') AS [FormatValidation!1!ErrorMessage], 
    T1.ConcurrencyId AS [FormatValidation!1!ConcurrencyId]
  FROM TFormatValidation T1

  WHERE (T1.IndigoClientId = @IndigoClientId) AND 
        (T1.Entity = @Entity)

  ORDER BY [FormatValidation!1!FormatValidationId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
