create view [dbo].[vPV_PlanEligibilityByProvider] as
--@validadviserstatus tinyint = 4,
--@validplantype tinyint = 16
--@BULKHIDDEN int = 64,
--@BULKMANUAL int = 32,
--@REALTIMEBATCH int = 8, 
--@REALTIME int = 4,
--@BULKPROVIDER int = 16,
--@BULKMANUALTEMPLATE int = 128

select refprodproviderid valuationproviderid, rt_criteria, scheduled_criteria, bulk_criteria, coalesce(bulk_criteria,scheduled_criteria, rt_criteria) criteria_tobeconsidered from
(
select distinct t.refprodproviderid, tmpRT.eligibilityflag rt_criteria, tmpScheduled.eligibilityflag scheduled_criteria, tmpBulk.eligibilityflag bulk_criteria
from tvalproviderconfig t
	left join (select pc.refprodproviderid, SUM(eflag.EligibilityFlag) eligibilityflag, max(supportedservice) supportedservice
					from TValProviderConfig pc 		
						join TValEligibilityCriteria ec on pc.RefProdProviderId = ec.ValuationProviderId 
							cross apply TValRefEligibilityFlag eflag
							where ec.EligibilityMask & eflag.EligibilityFlag = eflag.EligibilityFlag and eflag.EligibilityLevel = 'plan'
					group by pc.refprodproviderid) tmpRT
				on t.RefProdProviderId = tmpRT.RefProdProviderId 
					and 
						(
						tmpRT.supportedservice & 4 = 4
						)
	left join (select pc.refprodproviderid, SUM(eflag.EligibilityFlag) eligibilityflag, max(supportedservice) supportedservice
					from TValProviderConfig pc 		
						join TValEligibilityCriteria ec on pc.RefProdProviderId = ec.ValuationProviderId 
						cross apply TValRefEligibilityFlag eflag
					where ec.EligibilityMask & eflag.EligibilityFlag = eflag.EligibilityFlag and eflag.EligibilityLevel = 'plan'
					group by pc.refprodproviderid) tmpScheduled 
				on t.RefProdProviderId = tmpScheduled.RefProdProviderId
					and 
						(
						tmpScheduled.supportedservice & 8 = 8
						)				
	left join (select pc.refprodproviderid, SUM(eflag.EligibilityFlag) eligibilityflag, max(supportedservice) supportedservice
					from TValProviderConfig pc 		
						join TValEligibilityCriteria ec on pc.RefProdProviderId = ec.ValuationProviderId 
						cross apply TValRefEligibilityFlag eflag
					where ec.EligibilityMask & eflag.EligibilityFlag = eflag.EligibilityFlag and eflag.EligibilityLevel = 'plan'
							and eflag.eligibilityflag not in (4, 16)
					group by pc.refprodproviderid) tmpBulk 
				on t.RefProdProviderId = tmpBulk.RefProdProviderId
					and 
						(
						tmpBulk.supportedservice & 64 = 64
						or
						tmpBulk.supportedservice & 32 = 32
						or
						tmpBulk.supportedservice & 16 = 16
						or
						tmpBulk.supportedservice & 128 = 128
						)				
) v


