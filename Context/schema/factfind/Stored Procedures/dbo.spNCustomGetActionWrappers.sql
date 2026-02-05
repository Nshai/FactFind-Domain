SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomGetActionWrappers]  
  
@FinancialPLanningId bigint  
  
as  
--spNCustomGetActionWrappers 1  
declare @isPension bit  
  
select @isPension =   
(select case when planningtype = 'pension' then 1 else 0 end from TFinancialPlanning a  
inner join TRefPlanningType b on a.RefPlanningTypeId = b.RefPlanningTypeId  
where FinancialPlanningId =@FinancialPLanningId )  
  
  
select b.RefPlanType2ProdSubTypeId,   
case when ProdSubTypeName is not null then PlanTypeName + ' - ' + ProdSubTypeName else PlanTypeName end as PlanType  
from TRefPlanTypeToSection a  
inner join PolicyManagement..TRefPlanType2ProdSubType b on b.RefPlanType2ProdSubTypeId = a.RefPlanType2ProdSubTypeId  
inner join PolicyManagement..TRefPlanType c on c.RefPlanTypeId = b.RefPlanTypeId  
left join PolicyManagement..TProdSubType d on d.ProdSubTypeId = b.ProdSubTypeId  
where Section in (  
'Other Investments',  
'Savings')  
union  
  
select b.RefPlanType2ProdSubTypeId,   
case when ProdSubTypeName is not null then PlanTypeName + ' - ' + ProdSubTypeName else PlanTypeName end as PlanType  
from TRefPlanTypeToSection a  
inner join PolicyManagement..TRefPlanType2ProdSubType b on b.RefPlanType2ProdSubTypeId = a.RefPlanType2ProdSubTypeId  
inner join PolicyManagement..TRefPlanType c on c.RefPlanTypeId = b.RefPlanTypeId  
left join PolicyManagement..TProdSubType d on d.ProdSubTypeId = b.ProdSubTypeId  
where Section in (  
'Final Salary Schemes',  
'Money Purchase Pension Schemes',
 'Pension Plans') and @isPension = 1  
  
order by PlanType
GO
