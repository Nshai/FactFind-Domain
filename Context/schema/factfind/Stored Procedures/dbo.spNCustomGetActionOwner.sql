SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[spNCustomGetActionOwner]

@CRMContactId bigint,
@CRMContactId2 bigint

as


select crmcontactid,firstname + ' ' + lastname as name
from crm..TCRMContact 
where @CRMContactId = CRMContactId

union

select crmcontactid,firstname + ' ' + lastname as name
from crm..TCRMContact 
where @CRMContactId2 = CRMContactId
GO
