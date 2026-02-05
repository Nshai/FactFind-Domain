Create Table [dbo].[TProtectionNeedAnalysisItem]
(
	ProtectionNeedAnalysisItemId [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[LastUpdateDateTime] [datetime] NOT NULL,
	[LastUpdateByUserId] [int] NOT NULL,
	[ProtectionSessionId] [int] NOT NULL CONSTRAINT [FK_TProtectionNeedAnalysisItem_ProtectionSessionId_ProtectionSessionId] FOREIGN KEY REFERENCES TProtectionSession(ProtectionSessionId),
	[Description] [nvarchar] (255) NULL,
    [Notes] [nvarchar] (4000) NULL,
    [ClientId] [int] NOT NULL,
    [JointClientId] [int] NULL,
    [NeedAnalysisType] [nvarchar] (255) NOT NULL,
    [NeedOrder] [int] NOT NULL,
    [NeedOrderForJointParty] [int] NULL,
    [Outcome] [nvarchar] (255) NULL,
    [HasSufficientDetail] [bit] NOT NULL,
    [HasSufficientCover] [bit] NOT NULL CONSTRAINT [DF_TProtectionNeedAnalysisItem_HasSufficientCover] DEFAULT (0),
    [CoverAmount] [money] NULL,
	[CoverType] [nvarchar] (255) NULL,
    [Term] [int] NULL,
    [TermType] [nvarchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProtectionNeedAnalysisItem] ADD CONSTRAINT [PK_TProtectionNeedAnalysisItem] PRIMARY KEY NONCLUSTERED  ([ProtectionNeedAnalysisItemId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionNeedAnalysisItem_TenantId_ProtectionSessionId_ClientId ON [dbo].[TProtectionNeedAnalysisItem] ([TenantId], [ProtectionSessionId], [ClientId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionNeedAnalysisItem_TenantId_ProtectionSessionId_JointClientId ON [dbo].[TProtectionNeedAnalysisItem] ([TenantId], [ProtectionSessionId], [JointClientId])
GO