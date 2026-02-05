CREATE TABLE [dbo].[TProtectionSessionAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[LastUpdateDateTime] [datetime] NOT NULL,
	[LastUpdateByUserId] [int] NOT NULL,
	[CompletedDateTime] [datetime] NULL,
	[ExpiryDateTime] [datetime] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[PrimaryPartyId] [int] NOT NULL,
	[SecondaryPartyId] [int] NULL,
	[DisposabeIncomeAmount] [money],
	[BudgetAmount] [money] NULL,
	[StageComplete] [int] NOT NULL,
	[DocumentBinderId] [int] NULL,
	[ProtectionSessionId] [int] NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionSessionAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionSessionAudit] ADD CONSTRAINT [PK_TProtectionSessionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionSessionAudit_StampDateTime_ProtectionSessionId] ON [dbo].[TProtectionSessionAudit] (StampDateTime, ProtectionSessionId) WITH (FILLFACTOR=90)
go