
CREATE TABLE [dbo].[TProtectionCoverNeedAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[JointPartyId] [int] NULL,
	[Frequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Term] [int] NULL,
	[TermType] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [nvarchar](4000) COLLATE Latin1_General_CI_AS NULL,
	[NeedType] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[CoverAmount] [money],
	[AssociatedCoverSummary] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SystemGenerated] [bit] CONSTRAINT [DF_TProtectionCoverNeedAudit_SystemGenerated] Default(0),
	[ProtectionCoverNeedId] [int] NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionCoverNeedAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)

GO
ALTER TABLE [dbo].[TProtectionCoverNeedAudit] ADD CONSTRAINT [PK_TProtectionCoverNeedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionCoverNeedAudit_StampDateTime_ProtectionCoverNeedId] ON [dbo].[TProtectionCoverNeedAudit] (StampDateTime, ProtectionCoverNeedId) WITH (FILLFACTOR=90)
go
