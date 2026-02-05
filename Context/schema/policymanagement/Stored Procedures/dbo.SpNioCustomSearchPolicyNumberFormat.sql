SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNioCustomSearchPolicyNumberFormat]
@UserFormat varchar(100) = '',
@Example varchar(100) = '',
@ProductProviderId bigint = 0,
@RefPlanTypeId bigint = 0,
@TenantId bigint

AS

Select @UserFormat = @UserFormat + '%', @Example = @Example + '%'

Select 
A.PolicyNumberFormatId as [PolicyNumberFormatId], 
A.UserFormat as [UserFormat], 
A.Example as [Example], 
A.RegularExpression as [RegularExpression], 
A.RefProdProviderId as [ProductProviderId], 
A.RefPlanTypeId as [RefPlanTypeId], 
A.IndigoClientId as [TenantId], 
A.ConcurrencyId as [ConcurrencyId], 
C.CorporateName as [ProductProviderName], 
D.PlanTypeName as [PlanTypeName]

From TPolicyNumberFormat A
Inner Join TRefProdProvider B
	On A.RefProdProviderId = B.RefProdProviderId
Inner Join Crm..TCrmContact C
	On B.CRMContactId = C.CRMContactId
Inner Join TRefPlanType D
	On A.RefPlanTypeId = D.RefPlanTypeId
Where UserFormat like @UserFormat And Example Like @Example
And ((@ProductProviderId = 0) Or (@ProductProviderId > 0 And B.RefProdProviderId = @ProductProviderId))
And ((@RefPlanTypeId = 0) Or (@RefPlanTypeId > 0 And D.RefPlanTypeId = @RefPlanTypeId))
And IndigoClientId = @TenantId


GO
