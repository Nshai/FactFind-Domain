CREATE TABLE [dbo].[TRefUnitTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UnitType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL CONSTRAINT [DF_TRefUnitTypeAudit_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUnitTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefUnitTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefUnitTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefUnitTypeAudit] ADD CONSTRAINT [PK_TRefUnitTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefUnitTypeAudit_RefUnitTypeId_ConcurrencyId] ON [dbo].[TRefUnitTypeAudit] ([RefUnitTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
