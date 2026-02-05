SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure dbo.SpNioCustomCSVPolicyOwners	
	@PolicyBusinessIds  VARCHAR(8000),
	@TenantId bigint
AS
		
	if object_id('tempdb..#pbOwners') is not null drop table #pbOwners
	Create Table #pbOwners (PolicyBusinessId bigint, Owners varchar(max) default(''))

	INSERT INTO #pbOwners (PolicyBusinessId)
	SELECT pb.PolicyBusinessId
	FROM policymanagement..TPolicyBusiness pb
	JOIN policymanagement.dbo.FnSplit(@PolicyBusinessIds, ',') parslist   
            ON pb.PolicyBusinessId = parslist.Value 
	where pb.IndigoClientId = @TenantId

	UPDATE o
	set Owners = Convert(varchar(max), (
	select ',' + ISNULL(co.CorporateName, co.FirstName + ' ' +co.LastName)
		FROM policymanagement..TPolicyBusiness pb		
		JOIn policymanagement..TPolicyDetail pd on pb.PolicyDetailId = pd.PolicyDetailId
		JOIN policymanagement..TPolicyOwner po on po.PolicyDetailId = pd.PolicyDetailId
		JOIN crm..TCRMContact co ON co.CRMContactId = po.CRMContactId
		where pb.IndigoClientId = @TenantId and pb.PolicyBusinessId = o.PolicyBusinessId
	for xml path(''), type
	))
	From #pbOwners o

	
	SELECT 
	ow.PolicyBusinessId AS PolicyBusinessId,
	ow.Owners AS Owners
	from #pbOwners ow

	
