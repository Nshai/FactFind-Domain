SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[SpCustomRetrieveClientChargingDataForAuthor]
@CRMContactId bigint

as

begin

select 
1 as tag,
NULL as parent,
@CRMContactId as [Charging!1!CRMContactId],
isnull(SUM(NetAmount + VATAmount),'') as [Charging!1!OneOffFeeAmount]
from TFee f 
join TFeeRetainerOwner fro on fro.FeeId = f.feeid
join TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId
join TRefAdviseFeeType raft on raft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId and raft.Name = 'Ad-hoc Fee'
where fro.CRMContactId = @CRMContactId

FOR XML EXPLICIT

END
GO
