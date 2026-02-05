Create Table [dbo].[TProtectionNeedAnalysisItemAudit]
(
	AuditId [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[LastUpdateDateTime] [datetime] NOT NULL,
	[LastUpdateByUserId] [int] NOT NULL,
	[ProtectionSessionId] [int] NOT NULL,
	[Description] [nvarchar] (255) NULL,
    [Notes] [varchar] (4000) NULL,
    [ClientId] [int] NOT NULL,
    [JointClientId] [int] NULL,
    [NeedAnalysisType] [nvarchar] (255) NOT NULL,
    [NeedOrder] [int] NOT NULL,
	[NeedOrderForJointParty] [int] NULL,
    [Outcome] [nvarchar] (255) NULL,
    [HasSufficientDetail] [bit] NOT NULL,
	[HasSufficientCover] [bit] NOT NULL CONSTRAINT [DF_TProtectionNeedAnalysisItemAudit_HasSufficientCover] DEFAULT (0),
    [CoverAmount] [money] NULL,
	[CoverType] [nvarchar] (255) NULL,
    [Term] [int] NULL,
    [TermType] [nvarchar] (255) NULL,
	ProtectionNeedAnalysisItemId [int] NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionNeedAnalysisItemAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionNeedAnalysisItemAudit] ADD CONSTRAINT [PK_TProtectionNeedAnalysisItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionNeedAnalysisItemAudit_StampDateTime_ProtectionNeedAnalysisItemId] ON [dbo].[TProtectionNeedAnalysisItemAudit] (StampDateTime, ProtectionNeedAnalysisItemId) WITH (FILLFACTOR=90)
go