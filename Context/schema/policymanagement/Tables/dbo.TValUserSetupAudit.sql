CREATE TABLE [dbo].[TValUserSetupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[UseValuationFundsFg] [bit] NOT NULL,
[UseValuationAssetsFg] [bit] NOT NULL CONSTRAINT [DF_TValUserSetupAudit_UseValuationAssetsFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValUserSetupAudit_ConcurrencyId] DEFAULT ((1)),
[ValUserSetupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValUserSetupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValUserSetupAudit] ADD CONSTRAINT [PK_TValUserSetupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
