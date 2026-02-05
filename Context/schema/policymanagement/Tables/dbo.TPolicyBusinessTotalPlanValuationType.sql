CREATE TABLE [dbo].[TPolicyBusinessTotalPlanValuationType]
(
[PolicyBusinessId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[RefTotalPlanValuationTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyBusinessTotalPlanValuationTypeId] AS ([PolicyBusinessId]),
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TPolicyBusinessTotalPlanValuationType] ADD CONSTRAINT [PK_TPolicyBusinessTotalPlanValuationType] PRIMARY KEY CLUSTERED  ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessTotalPlanValuationType] ADD CONSTRAINT [FK_TPolicyBusinessTotalPlanValuationType_TPolicyBusiness_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessTotalPlanValuationType] ADD CONSTRAINT [FK_TPolicyBusinessTotalPlanValuationType_TRefTotalPlanValuationType_RefTotalPlanValuationTypeId] FOREIGN KEY ([RefTotalPlanValuationTypeId]) REFERENCES [dbo].[TRefTotalPlanValuationType] ([RefTotalPlanValuationTypeId])
GO
create index IX_TPolicyBusinessTotalPlanValuationType_TenantId_PlanMigrationRef on TPolicyBusinessTotalPlanValuationType(TenantId,PlanMigrationRef) 
go 
