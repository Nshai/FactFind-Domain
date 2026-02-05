CREATE TABLE [dbo].[TRefAcceptanceStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[ShowTimeAs] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAcceptanceStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefAcceptanceStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAcceptanceStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAcceptanceStatusAudit] ADD CONSTRAINT [PK_TRefAcceptanceStatusAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
