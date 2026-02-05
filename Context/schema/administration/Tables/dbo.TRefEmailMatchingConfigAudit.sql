CREATE TABLE [dbo].[TRefEmailMatchingConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MatchingConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailMatchingConfigAudit_ConcurrencyId] DEFAULT ((1)),
[RefEmailMatchingConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEmailMatchingConfigAudit] ADD CONSTRAINT [PK_TRefEmailMatchingConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
