SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateIndigoClientById]
	@KeyIndigoClientId bigint,
	@StampUser varchar (255),
	@Identifier varchar (64),
	@Status varchar (24) = 'New',
	@PrimaryContact varchar (128),
	@ContactId bigint = NULL,
	@PhoneNumber varchar (40),
	@EmailAddress varchar (128),
	@PrimaryGroupId bigint = NULL,
	@NetworkId bigint = NULL,
	@SIB varchar (24) = NULL,
	@MCCB varchar (24) = NULL,
	@IOProductType varchar (50),
	@ExpiryDate datetime,
	@AddressLine1 varchar (1000),
	@AddressLine2 varchar (1000) = NULL,
	@AddressLine3 varchar (1000) = NULL,
	@AddressLine4 varchar (1000) = NULL,
	@CityTown varchar (255) = NULL,
	@County varchar (255) = NULL,
	@Postcode varchar (20),
	@Country varchar (128) = 'UK',
	@IsNetwork bit = 0,
	@SupportServiceId bigint = NULL,
	@FirmSize varchar (50),
	@Specialism varchar (128),
	@OtherSpecialism varchar (128) = NULL,
	@SupportLevel varchar (50),
	@EmailSupOptn varchar (50),
	@SupportEmail varchar (128),
	@TelSupOptn varchar (50),
	@SupportTelephone varchar (40),
	@AllowPasswordEmail bit = 1,
	@SessionTimeout int,
	@LicenceType varchar (50),
	@MaxConUsers bigint = NULL,
	@MaxULAGCount bigint = NULL,
	@UADRestriction bit,
	@MaxULADCount bigint = NULL,
	@AdviserCountRestrict bit,
	@MaxAdviserCount bigint = NULL,
	@MaxFinancialPlanningUsers bigint = NULL,
	@EmailFormat varchar (128) = NULL,
	@UserNameFormat varchar (24) = NULL,
	@NTDomain varchar (255) = NULL,
	@IsIndependent bit = 1,
	@BrandDescriptor varchar (64) = NULL,
	@ServiceLevel bigint = NULL,
	@HostingFg bit = 0,
	@CaseLoggingOption int = 0,
	@Guid uniqueidentifier = NULL,
	@RefEnvironmentId bigint = NULL,
	@IsPortfolioConstructionProvider bit = 0,
	@IsAuthorProvider bit = 0,
	@IsAtrProvider bit = 0,
	@MaxAdvisaCentaCoreUsers int = NULL,
	@MaxAdvisaCentaCorePlusLifetimePlannerUsers int = NULL,
	@MaxFeAnalyticsCoreUsers int = NULL,
	@MaxVoyantUsers int = NULL,
	@MaxAdvisaCentaFullUsers int = NULL,
	@MaxAdvisaCentaFullPlusLifetimePlannerUsers int = NULL,
	@MaxPensionFreedomPlannerUsers int = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

EXEC SpNAuditIndigoClient @StampUser, @KeyIndigoClientId, 'U'
  
UPDATE T1
SET 
	T1.Identifier = @Identifier,
	T1.Status = @Status,
	T1.PrimaryContact = @PrimaryContact,
	T1.ContactId = @ContactId,
	T1.PhoneNumber = @PhoneNumber,
	T1.EmailAddress = @EmailAddress,
	T1.PrimaryGroupId = @PrimaryGroupId,
	T1.NetworkId = @NetworkId,
	T1.SIB = @SIB,
	T1.MCCB = @MCCB,
	T1.IOProductType = @IOProductType,
	T1.ExpiryDate = @ExpiryDate,
	T1.AddressLine1 = @AddressLine1,
	T1.AddressLine2 = @AddressLine2,
	T1.AddressLine3 = @AddressLine3,
	T1.AddressLine4 = @AddressLine4,
	T1.CityTown = @CityTown,
	T1.County = @County,
	T1.Postcode = @Postcode,
	T1.Country = @Country,
	T1.IsNetwork = @IsNetwork,
	T1.SupportServiceId = @SupportServiceId,
	T1.FirmSize = @FirmSize,
	T1.Specialism = @Specialism,
	T1.OtherSpecialism = @OtherSpecialism,
	T1.SupportLevel = @SupportLevel,
	T1.EmailSupOptn = @EmailSupOptn,
	T1.SupportEmail = @SupportEmail,
	T1.TelSupOptn = @TelSupOptn,
	T1.SupportTelephone = @SupportTelephone,
	T1.AllowPasswordEmail = @AllowPasswordEmail,
	T1.SessionTimeout = @SessionTimeout,
	T1.LicenceType = @LicenceType,
	T1.MaxConUsers = @MaxConUsers,
	T1.MaxULAGCount = @MaxULAGCount,
	T1.UADRestriction = @UADRestriction,
	T1.MaxULADCount = @MaxULADCount,
	T1.AdviserCountRestrict = @AdviserCountRestrict,
	T1.MaxAdviserCount = @MaxAdviserCount,
	T1.MaxFinancialPlanningUsers = @MaxFinancialPlanningUsers,
	T1.EmailFormat = @EmailFormat,
	T1.UserNameFormat = @UserNameFormat,
	T1.NTDomain = @NTDomain,
	T1.IsIndependent = @IsIndependent,
	T1.BrandDescriptor = @BrandDescriptor,
	T1.ServiceLevel = @ServiceLevel,
	T1.HostingFg = @HostingFg,
	T1.CaseLoggingOption = @CaseLoggingOption,
	T1.RefEnvironmentId = @RefEnvironmentId,
	T1.IsPortfolioConstructionProvider = @IsPortfolioConstructionProvider,
	T1.IsAuthorProvider = @IsAuthorProvider,
	T1.IsAtrProvider = @IsAtrProvider,
	T1.MaxAdvisaCentaCoreUsers = @MaxAdvisaCentaCoreUsers,
	T1.MaxAdvisaCentaCorePlusLifetimePlannerUsers = @MaxAdvisaCentaCorePlusLifetimePlannerUsers,
	T1.MaxFeAnalyticsCoreUsers = @MaxFeAnalyticsCoreUsers,
	T1.MaxVoyantUsers = @MaxVoyantUsers,
	T1.MaxAdvisaCentaFullUsers = @MaxAdvisaCentaFullUsers,
	T1.MaxAdvisaCentaFullPlusLifetimePlannerUsers = @MaxAdvisaCentaFullPlusLifetimePlannerUsers,
	T1.MaxPensionFreedomPlannerUsers = @MaxPensionFreedomPlannerUsers,
	T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TIndigoClient T1
WHERE (T1.IndigoClientId = @KeyIndigoClientId)

SELECT * FROM TIndigoClient [IndigoClient]
WHERE ([IndigoClient].IndigoClientId = @KeyIndigoClientId)
FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
