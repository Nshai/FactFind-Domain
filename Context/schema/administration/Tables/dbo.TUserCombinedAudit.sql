CREATE TABLE [dbo].[TUserCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[UnipassSerialNbr] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserCombinedAudit] ADD CONSTRAINT [PK_TUserCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
