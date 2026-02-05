CREATE TABLE [dbo].[TRefApplicationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ApplicationShortName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefApplicationTypeId] [int] NOT NULL,
[ImageName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AuthenticationMode] [smallint] NULL CONSTRAINT [DF_TRefApplicationAudit_AuthenticationMode] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefApplicationAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationAudit_ConcurrencyId] DEFAULT ((1)),
[RefApplicationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefApplicationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationAudit] ADD CONSTRAINT [PK_TRefApplicationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefApplicationAudit_RefApplicationId_ConcurrencyId] ON [dbo].[TRefApplicationAudit] ([RefApplicationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
