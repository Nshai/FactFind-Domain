SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalContact] (
	@CRMContactId BIGINT
	,@CRMContactId2 BIGINT
	,@TenantId BIGINT
	)
AS
BEGIN
	SELECT C.ContactId ContactsId
		,C.CRMContactId
		,CASE CRMContactId
			WHEN @CRMContactId
				THEN 'Client 1'
			ELSE 'Client 2'
			END AS [Owner]
		,C.[RefContactType]
		,C.[Value]
		,C.[Description]
		,Convert(BIT, C.DefaultFg) AS DefaultFg
		,C.ConcurrencyId
	FROM CRM..TContact C WITH (NOLOCK)
	WHERE C.CrmContactId IN (
			@CRMContactId
			,@CRMContactId2
			)
		AND C.IndClientId = @TenantId
END
GO
