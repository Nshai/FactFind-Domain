CREATE TABLE [dbo].[TRefReturnDeathTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefReturnDeathTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefReturn_RetireFg_2__79] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefReturn_ConcurrencyId_1__79] DEFAULT ((1)),
[RefReturnDeathTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefReturn_StampDateTime_3__79] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefReturnDeathTypeAudit] ADD CONSTRAINT [PK_TRefReturnDeathTypeAudit_4__79] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefReturnDeathTypeAudit_RefReturnDeathTypeId_ConcurrencyId] ON [dbo].[TRefReturnDeathTypeAudit] ([RefReturnDeathTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
