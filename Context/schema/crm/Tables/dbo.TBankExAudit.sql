CREATE TABLE [dbo].[TBankExAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Type] [int] NOT NULL,
[TypeDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Size] [int] NULL,
[Required] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ExtensibleColumnId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBankExAud_StampDateTime_1__93] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBankExAudit] ADD CONSTRAINT [PK_TBankExAudit_2__93] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
