CREATE TABLE [dbo].[TDiscount]
(
[DiscountId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [decimal] (15, 2) NULL,
[Percentage] [decimal] (5, 2) NULL,
[Reason] [nvarchar] (800) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[GroupId] [int] NULL,
[IsRange] [bit] NOT NULL CONSTRAINT [DF_TDiscount_IsRange] DEFAULT ((0)),
[MinAmount] [decimal] (10, 2)  NULL,
[MaxAmount] [decimal] (10, 2)  NULL,
[MinPercentage] [decimal] (5, 2) NULL,
[MaxPercentage] [decimal] (5, 2) NULL
)
GO
ALTER TABLE [dbo].[TDiscount] ADD CONSTRAINT [PK_TDiscount] PRIMARY KEY CLUSTERED  ([DiscountId])
GO
CREATE NONCLUSTERED INDEX [IX_TDiscount_GroupId] ON [dbo].[TDiscount] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TDiscount_TenantId] ON [dbo].[TDiscount] ([TenantId])
GO
