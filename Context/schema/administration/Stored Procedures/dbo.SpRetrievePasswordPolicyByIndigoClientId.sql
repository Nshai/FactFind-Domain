SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrievePasswordPolicyByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PasswordPolicyId AS [PasswordPolicy!1!PasswordPolicyId], 
    T1.Expires AS [PasswordPolicy!1!Expires], 
    ISNULL(T1.ExpiryDays, '') AS [PasswordPolicy!1!ExpiryDays], 
    ISNULL(T1.UniquePasswords, '') AS [PasswordPolicy!1!UniquePasswords], 
    ISNULL(T1.MaxFailedLogins, '') AS [PasswordPolicy!1!MaxFailedLogins], 
    ISNULL(T1.ChangePasswordOnFirstUse, '') AS [PasswordPolicy!1!ChangePasswordOnFirstUse], 
    ISNULL(T1.AutoPasswordGeneration, '') AS [PasswordPolicy!1!AutoPasswordGeneration], 
    ISNULL(T1.AllowExpireAllPasswords, '') AS [PasswordPolicy!1!AllowExpireAllPasswords], 
    ISNULL(T1.AllowAutoUserNameGeneration, '') AS [PasswordPolicy!1!AllowAutoUserNameGeneration], 
    T1.IndigoClientId AS [PasswordPolicy!1!IndigoClientId], 
    T1.ConcurrencyId AS [PasswordPolicy!1!ConcurrencyId]
  FROM TPasswordPolicy T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [PasswordPolicy!1!PasswordPolicyId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
