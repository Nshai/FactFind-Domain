SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[spCustomSearchProductProviders] 
@IsConsumerFriendly bit,
@IsArchived tinyint,
@PartName varchar(20)

AS

BEGIN

	SELECT TOP (10) pr.RefProdProviderId, pa.CRMContactId, pa.CorporateName
	FROM policymanagement.dbo.TRefProdProvider pr WITH(nolock)
	INNER JOIN crm.dbo.TCRMContact pa WITH(nolock) ON pr.CRMContactId = pa.CRMContactId
	WHERE pr.IsConsumerFriendly = @IsConsumerFriendly
	AND pr.RetireFg = @IsArchived
	AND pa.CorporateId IS NOT NULL
	AND pa.IndClientId = 0
	AND (pa.CorporateName LIKE '%' + @PartName + '%')	

END


GO
