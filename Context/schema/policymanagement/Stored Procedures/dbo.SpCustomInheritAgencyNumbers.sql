SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomInheritAgencyNumbers]
	@PractitionerId bigint,
	@InheritFromPractitionerId bigint,
	@OverwriteExisting bit
AS

IF @OverwriteExisting = 0
    BEGIN	
	--Insert new agency numbers (inherit records that don't already exist for practitioner)
	INSERT INTO TAgencyNumber (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged)
	(SELECT @PractitionerId, RefProdProviderId, AgencyNumber, CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)
	 FROM TAgencyNumber 
	 WHERE Practitionerid = @InheritFromPractitionerId AND 
	 ((RefProdProviderId NOT IN
		(SELECT RefProdProviderId FROM TAgencyNumber WHERE PractitionerId = @PractitionerId)
	  )
	  OR 
	  (AgencyNumber NOT IN
		(SELECT AgencyNumber FROM TAgencyNumber WHERE PractitionerId = @PractitionerId)
	 ))
	)

    END

ELSE
    BEGIN

	--Update existing agency numbers
	UPDATE T1
	SET T1.AgencyNumber = T2.AgencyNumber, T1.DateChanged = CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)
	FROM TAgencyNumber T1
	INNER JOIN TAgencyNumber T2 ON T1.RefProdProviderId = T2.RefProdProviderId
	WHERE T1.PractitionerId = @PractitionerId
	AND T2.PractitionerId = @InheritFromPractitionerId

	--Insert new agency numbers
	INSERT INTO TAgencyNumber (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged)
	(SELECT @PractitionerId, RefProdProviderId, AgencyNumber, CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)
	 FROM TAgencyNumber WHERE PractitionerId = @InheritFromPractitionerId AND RefProdProviderId NOT IN
		(SELECT RefProdProviderId FROM TAgencyNumber WHERE PractitionerId = @PractitionerId)
	)

    END
GO
