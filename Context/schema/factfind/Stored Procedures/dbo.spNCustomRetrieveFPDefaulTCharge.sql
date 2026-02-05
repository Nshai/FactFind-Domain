SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomRetrieveFPDefaulTCharge]

@tenantId bigint

as

select tenantid,
FPDefaultChargeId,
TenantId,
InitialChargeLumpsum,
InitialChargeContribution,
InitialPeriodMonths
from TFPDefaultCharge
where tenantid= @tenantid
GO
