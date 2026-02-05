CREATE TABLE [dbo].[TOccupationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Occupation] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Employer] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[EmployerAddress] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Telephone] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Properties] [int] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[OccupationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOccupationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOccupationAudit] ADD CONSTRAINT [PK_TOccupationAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOccupationAudit_OccupationId_ConcurrencyId] ON [dbo].[TOccupationAudit] ([OccupationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
