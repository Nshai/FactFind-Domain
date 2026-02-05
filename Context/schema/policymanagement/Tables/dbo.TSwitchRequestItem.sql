CREATE TABLE [dbo].[TSwitchRequestItem]
(
[SwitchRequestItemId] [int] NOT NULL IDENTITY(1, 1),
[SwitchRequestId] [int] NULL,
[FundId] [int] NOT NULL,
[SedolCode] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[FundName] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[Sector] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[ExistingUnits] [decimal] (18, 5) NULL,
[ExistingPercentage] [decimal] (9, 5) NULL,
[RevisedPercentage] [decimal] (9, 5) NOT NULL,
[IsAddedFund] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[BuySell] [nvarchar](500) NULL
)
GO
ALTER TABLE [dbo].[TSwitchRequestItem] ADD CONSTRAINT [PK_TSwitchRequestItem] PRIMARY KEY CLUSTERED  ([SwitchRequestItemId])
GO
