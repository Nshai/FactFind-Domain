create view v_BI_RiskProfile
as
select X.IndigoClientId, X.CRMContactId, X.BriefDescription as InvesmentRiskProfile, Y.BriefDescription as RetirementRiskProfile
from 
	(select C.IndigoClientId, B.CRMContactId, C.BriefDescription, C.Descriptor
	from (select max(AtrInvestmentGeneralId) as AtrInvestmentGeneralId, CRMContactId from FactFind.dbo.TAtrInvestmentGeneral group by CRMContactId) A
	join FactFind.dbo.TAtrInvestmentGeneral B on A.AtrInvestmentGeneralId = B.AtrInvestmentGeneralId
	join PolicyManagement.dbo.TRiskProfile C on B.CalculatedRiskProfile = C.Guid) X
left join 
	(select C.IndigoClientId, B.CRMContactId, C.BriefDescription, C.Descriptor
	from (select max(AtrRetirementGeneralId) as AtrRetirementGeneralId, CRMContactId from FactFind.dbo.TAtrRetirementGeneral group by CRMContactId) A
	join FactFind.dbo.TAtrRetirementGeneral B on A.AtrRetirementGeneralId = B.AtrRetirementGeneralId
	join PolicyManagement.dbo.TRiskProfile C on B.CalculatedRiskProfile = C.Guid) Y on X.CRMContactId = Y.CRMContactId