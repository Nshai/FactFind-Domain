SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpDBSetupCreateRefProdProviderPlanType] 
@RefProdProviderId bigint

as

begin

	INSERT INTO TRefProdProviderPlanType (RefProdProviderId, RefPlanTypeId) 
	SELECT @RefProdProviderId, RefPlanTypeId
	FROM TRefPlanType

end
GO
