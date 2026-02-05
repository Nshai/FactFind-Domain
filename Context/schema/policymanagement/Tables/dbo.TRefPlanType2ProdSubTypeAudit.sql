CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[ProdSubTypeId] [int] NULL,
[RefPortfolioCategoryId] [int] NULL,
[RefPlanDiscriminatorId] [int] NULL,
[DefaultCategory] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeAudit_IsArchived] DEFAULT ((0)),
[IsConsumerFriendly] [bit] NULL,
[RegionCode] [varchar] (2) NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeAudit_RegionCode] DEFAULT (('GB')) 
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeAudit] ADD CONSTRAINT [PK_TRefPlanType2ProdSubTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TRefPlanType2ProdSubTypeAudit_RefPlanType2ProdSubTypeId_ConcurrencyId] ON [dbo].[TRefPlanType2ProdSubTypeAudit] ([RefPlanType2ProdSubTypeId], [ConcurrencyId])
GO
