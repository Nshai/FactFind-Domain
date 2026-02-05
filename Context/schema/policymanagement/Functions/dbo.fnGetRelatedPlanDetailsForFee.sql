SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[fnGetRelatedPlanDetailsForFee](@FeeId bigint, @Type varchar(50))
RETURNS varchar(2000)
AS
BEGIN
	DECLARE @List varchar(2000)
	
	
	SELECT @List = CASE @Type
		WHEN 'PolicyNumber' THEN isnull(@List+', ','') + pb.PolicyNumber
		WHEN 'PlanType' THEN isnull(@List+', ','') + rpt.PlanTypeName
		WHEN 'Provider' THEN isnull(@List+', ','') + c.CorporateName
	END
	FROM TFee2Policy f2p
	JOIN TPolicyBusiness pb on pb.PolicyBusinessId = f2p.PolicyBusinessId
	JOIN TPolicyDetail pd on pd.PolicyDetailId = pb.PolicyDetailId
	JOIN TPlanDescription pds on pds.PlanDescriptionId = pd.PlanDescriptionId
	JOIN TRefPlanType2ProdSubType t on t.RefPlanType2ProdSubTypeId = pds.RefPlanType2ProdSubTypeId
	JOIN TRefPlanType rpt ON rpt.RefPlanTypeId = t.RefPlanTypeId
	JOIN TRefProdProvider rpp on rpp.RefProdProviderId = pds.RefProdProviderId
	JOIN CRM..TCRMContact c on c.CRMContactId = rpp.CRMContactId
	
	WHERE f2p.FeeId = @FeeId

	RETURN (@List)
END

GO
