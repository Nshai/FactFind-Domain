CREATE TABLE [dbo].[TRefOpportunityType2ProdSubTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ProdSubTypeId] [int] NULL,
[OpportunityTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOpportunityType2ProdSubTypeAudit_ConcurrencyId_2__56] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefOpportunityType2ProdSubTypeAudit_IsArchived] DEFAULT ((0)),
[RefOpportunityType2ProdSubTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefOpportunityType2ProdSubTypeAudit_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefOpportunityType2ProdSubTypeAudit] ADD CONSTRAINT [PK_TRefOpportunityType2ProdSubTypeAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefOpportunityType2ProdSubTypeAudit_RefOpportunityType2ProdSubTypeId_ConcurrencyId] ON [dbo].[TRefOpportunityType2ProdSubTypeAudit] ([RefOpportunityType2ProdSubTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO