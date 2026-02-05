SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveSubPlanTypes]
	AS 
	
	select 
		1 as tag,
		null as parent,
		null as [PlanTypeToSubTypes!1!],
		null as [PlanTypeToSubType!2!id],		
		null as [PlanTypeToSubType!2!description],
		null as [PlanTypeToSubType!2!section]
		union all
	select
		2 as Tag ,
		1 as parent,
		null,
		
		  P2P.RefPlanType2ProdSubTypeId AS id, 	
			CASE                               
				WHEN LEN(ISNULL(PST.ProdSubTypeName, '')) > 0 THEN  RPT.PlanTypeName + ' (' + PST.ProdSubTypeName + ')'                              
				ELSE RPT.PlanTypeName                              
			END AS description,

		  CASE 
				WHEN SEC.Section = 'Annuities' THEN 'AnnuitySubplans'   
				WHEN SEC.Section = 'Building and Contents Insurance' THEN 'GeneralInsuranceSubplans'   
				WHEN SEC.Section = 'Final Salary Schemes' THEN 'FinalSalarySubplans'   
				WHEN SEC.Section = 'Money Purchase Pension Schemes' THEN 'MoneyPurchaseSubPlans'   
				WHEN SEC.Section = 'Other Investments' THEN 'OtherInvestmentSubplans'   
				WHEN SEC.Section = 'Pension Plans' THEN 'PersonalPensionSubplans'   
				WHEN SEC.Section = 'Savings' THEN 'SavingPlanSubplans'  
		  ELSE Sec.Section + 'Subplans'
		  END AS section  
		FROM
		 PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK)
		 INNER JOIN PolicyManagement..TRefPlanType RPT WITH(NOLOCK) ON P2P.RefPlanTypeId = RPT.RefPlanTypeId
		 LEFT OUTER JOIN PolicyManagement..TProdSubType PST WITH(NOLOCK) ON PST.ProdSubTypeId = P2P.ProdSubTypeId                              
		 INNER JOIN factfind..TRefPlanTypeToSection SEC WITH(NOLOCK) ON P2P.RefPlanType2ProdSubTypeId = SEC.RefPlanType2ProdSubTypeId
		ORDER BY [PlanTypeToSubType!2!description] 
		FOR XML  explicit
GO
