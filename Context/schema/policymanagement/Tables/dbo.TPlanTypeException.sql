CREATE TABLE [dbo].[TPlanTypeException]
(
[PlanTypeExceptionId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanType2ProdSubTypeId] [int] NULL,
[PreSaleSumAssured] [decimal] (15, 2) NULL,
[PreSaleLumpSumContribution] [decimal] (15, 2) NULL,
[PreSaleRegularContribution] [decimal] (15, 2) NULL,
[PreSaleAgeLowerLimit] [int] NULL,
[PreSaleAgeUpperLimit] [int] NULL,
[PostSaleSumAssured] [decimal] (15, 2) NULL,
[PostSaleLumpSumContribution] [decimal] (15, 2) NULL,
[PostSaleRegularContribution] [decimal] (15, 2) NULL,
[PostSaleAgeLowerLimit] [int] NULL,
[PostSaleAgeUpperLimit] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PlanTypeExceptionName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[SumAssured] [decimal] (15, 2) NULL,
[LumpSumContribution] [decimal] (15, 2) NULL,
[RegularContribution] [decimal] (15, 2) NULL,
[AgeLowerLimit] [int] NULL,
[AgeUpperLimit] [int] NULL,
[IsPreSale] [bit] NOT NULL CONSTRAINT [DF_TPlanTypeException_IsPreSale] DEFAULT ((0)),
[IsPostSale] [bit] NOT NULL CONSTRAINT [DF_TPlanTypeException_IsPostSale] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TPlanTypeException_IsArchived] DEFAULT ((0)),
[IsPOA] [bit] NOT NULL CONSTRAINT [DF_TPlanTypeException_IsPOA] DEFAULT ((0)), 
[RiskProfileType] [int] NOT NULL CONSTRAINT [DF_TPlanTypeException_RiskProfileType] DEFAULT ((1)), 
[Location] [varchar](255) NULL,
[AtrTemplateId] [int] NULL,
[AdviceCaseStatusId] [int] NULL,
[IsVulnerableCustomer]  [bit] NULL 
)
GO
ALTER TABLE [dbo].[TPlanTypeException] ADD CONSTRAINT [PK_TPlanTypeException] PRIMARY KEY CLUSTERED  ([PlanTypeExceptionId])
GO
