SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomRetrieveDependentsByCRMContactId] @CRMContactId bigint

as

select 
DependantsId,
CRMContactId,
CRMContactId2,
Name,
DOB,
Age,
Relationship,
DependantOf,
FinDep,
AgeOfInd,
ConcurrencyId
from	TDependants
where	CRMContactid = @CRMContactId
GO
