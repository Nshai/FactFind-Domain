SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInheritAgencyNumbers]
@PractitionerId bigint,  
@InheritFromPractitionerId bigint,  
@OverwriteExisting bit  

AS  

BEGIN

  DECLARE @MaxId bigint
	
	SELECT @MaxId = (SELECT IDENT_CURRENT('TAgencyNumber'))
	
	IF @OverwriteExisting = 0  
		BEGIN   
			--Insert new agency numbers (inherit records that don't already exist for practitioner)  
			INSERT INTO TAgencyNumber (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged)  
			SELECT @PractitionerId, RefProdProviderId, AgencyNumber, CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)  
			FROM TAgencyNumber   
			WHERE Practitionerid = @InheritFromPractitionerId 
			AND   
			(
				(
					RefProdProviderId NOT IN  
					(
						SELECT RefProdProviderId FROM TAgencyNumber WHERE PractitionerId = @PractitionerId
					)  
				)  
				OR   
				(
					AgencyNumber NOT IN  
					(
						SELECT AgencyNumber FROM TAgencyNumber WHERE PractitionerId = @PractitionerId
					)  
				)
			)  
  
	    END  
	  
	ELSE  

	    BEGIN  
	  
			--Update existing agency numbers  
			
			--AUDIT UPDATES
			insert into tagencynumberaudit (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged, ConcurrencyId, AgencyNumberId, StampAction, StampDateTime, StampUser)
			SELECT t1.PractitionerId, t1.RefProdProviderId, t1.AgencyNumber, t1.DateChanged, t1.ConcurrencyId, t1.AgencyNumberId, 'U', getdate(), '0'
			FROM TAgencyNumber T1  
			INNER JOIN TAgencyNumber T2 ON T1.RefProdProviderId = T2.RefProdProviderId  
			WHERE T1.PractitionerId = @PractitionerId  
			AND T2.PractitionerId = @InheritFromPractitionerId  
	
	
			UPDATE T1  
			SET T1.AgencyNumber = T2.AgencyNumber, T1.DateChanged = CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)  
			FROM TAgencyNumber T1  
			INNER JOIN TAgencyNumber T2 ON T1.RefProdProviderId = T2.RefProdProviderId  
			WHERE T1.PractitionerId = @PractitionerId  
			AND T2.PractitionerId = @InheritFromPractitionerId  
	  
			--Insert new agency numbers  
			INSERT INTO TAgencyNumber (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged)  
			SELECT @PractitionerId, RefProdProviderId, AgencyNumber, CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103)  
			FROM TAgencyNumber 
			WHERE PractitionerId = @InheritFromPractitionerId 
			AND RefProdProviderId NOT IN  
			(
				SELECT RefProdProviderId FROM TAgencyNumber WHERE PractitionerId = @PractitionerId
			)  
	  
	    END  
	
	
	-- AUDIT ANY ADDITIONS
	insert into tagencynumberaudit (PractitionerId, RefProdProviderId, AgencyNumber, DateChanged, ConcurrencyId, AgencyNumberId, StampAction, StampDateTime, StampUser)
	SELECT PractitionerId, RefProdProviderId, AgencyNumber, DateChanged, ConcurrencyId, AgencyNumberId, 'C', getdate(), '0'
	FROM TAgencyNumber WHERE AgencyNumberId > @MaxId

END
GO
