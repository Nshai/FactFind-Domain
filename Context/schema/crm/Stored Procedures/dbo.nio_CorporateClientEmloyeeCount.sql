SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE nio_CorporateClientEmloyeeCount
	@CorporateClientId int
AS

Select Count(Distinct RelationshipId) as EmployeesCount FROM
(
	Select RelationshipId from TRelationship A with(nolock)
	Inner Join TRefRelationshipType B with(nolock) ON A.RefRelTypeId = B.RefRelationshipTypeId
	Where CRMContactFromId = @CorporateClientId 
	And B.RelationshipTypeName in('Employee','Director','Key Person','Shareholder Director','Shareholder Non Director','Partner')
) AS A

