SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCreateFinancialPlanningScenarioAssetAllocation] 

@FinancialPlanningId bigint,
@ScenarioId bigint,
@AssetName varchar(255),
@AssetPercentage decimal (18,2),
@AssetColour varchar(50),
@IsFinal bit
as

insert into TFinancialPlanningScenarioAllocation
(FinancialPlanningId,
ScenarioId,
AssetName,
AssetPercentage,
AssetColour,
IsFinal)
select
@FinancialPlanningId,
@ScenarioId,
@AssetName,
@AssetPercentage,
@AssetColour,
@IsFinal

GO
