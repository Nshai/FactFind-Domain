SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePerson]
@StampUser varchar (255),
@Title varchar (255) = NULL,
@FirstName varchar (255),
@MiddleName varchar (255) = NULL,
@LastName varchar (255),
@MaidenName varchar (255) = NULL,
@DOB datetime = NULL,
@GenderType varchar (255) = NULL,
@NINumber varchar (255) = NULL,
@IsSmoker varchar (10) = NULL,
@UKResident tinyint = NULL,
@ResidentIn varchar (50) = NULL,
@Salutation varchar (50) = NULL,
@RefSourceTypeId bigint = NULL,
@IntroducerSource varchar (50) = NULL,
@MaritalStatus varchar (16) = NULL,
@MarriedOn datetime = NULL,
@Residency varchar (32) = NULL,
@UKDomicile bit = NULL,
@Domicile varchar (32) = NULL,
@TaxCode varchar (12) = NULL,
@Nationality varchar (32) = NULL,
@ArchiveFG tinyint = 0,
@IndClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PersonId bigint

  INSERT INTO TPerson (
    Title, 
    FirstName, 
    MiddleName, 
    LastName, 
    MaidenName, 
    DOB, 
    GenderType, 
    NINumber, 
    IsSmoker, 
    UKResident, 
    ResidentIn, 
    Salutation, 
    RefSourceTypeId, 
    IntroducerSource, 
    MaritalStatus, 
    MarriedOn, 
    Residency, 
    UKDomicile, 
    Domicile, 
    TaxCode, 
    Nationality, 
    ArchiveFG, 
    IndClientId, 
    ConcurrencyId ) 
  VALUES (
    @Title, 
    @FirstName, 
    @MiddleName, 
    @LastName, 
    @MaidenName, 
    @DOB, 
    @GenderType, 
    @NINumber, 
    @IsSmoker, 
    @UKResident, 
    @ResidentIn, 
    @Salutation, 
    @RefSourceTypeId, 
    @IntroducerSource, 
    @MaritalStatus, 
    @MarriedOn, 
    @Residency, 
    @UKDomicile, 
    @Domicile, 
    @TaxCode, 
    @Nationality, 
    @ArchiveFG, 
    @IndClientId, 
    1) 

  SELECT @PersonId = SCOPE_IDENTITY()
  INSERT INTO TPersonAudit (
    Title, 
    FirstName, 
    MiddleName, 
    LastName, 
    MaidenName, 
    DOB, 
    GenderType, 
    NINumber, 
    IsSmoker, 
    UKResident, 
    ResidentIn, 
    Salutation, 
    RefSourceTypeId, 
    IntroducerSource, 
    MaritalStatus, 
    MarriedOn, 
    Residency, 
    UKDomicile, 
    Domicile, 
    TaxCode, 
    Nationality, 
    ArchiveFG, 
    IndClientId, 
    ConcurrencyId,
    PersonId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Title, 
    T1.FirstName, 
    T1.MiddleName, 
    T1.LastName, 
    T1.MaidenName, 
    T1.DOB, 
    T1.GenderType, 
    T1.NINumber, 
    T1.IsSmoker, 
    T1.UKResident, 
    T1.ResidentIn, 
    T1.Salutation, 
    T1.RefSourceTypeId, 
    T1.IntroducerSource, 
    T1.MaritalStatus, 
    T1.MarriedOn, 
    T1.Residency, 
    T1.UKDomicile, 
    T1.Domicile, 
    T1.TaxCode, 
    T1.Nationality, 
    T1.ArchiveFG, 
    T1.IndClientId, 
    T1.ConcurrencyId,
    T1.PersonId,
    'C',
    GetDate(),
    @StampUser

  FROM TPerson T1
 WHERE T1.PersonId=@PersonId
  EXEC SpRetrievePersonById @PersonId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
