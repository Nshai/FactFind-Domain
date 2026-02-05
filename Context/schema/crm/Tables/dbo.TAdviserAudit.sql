CREATE TABLE [dbo].[TAdviserAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[ClientCRMContactId] [int] NOT NULL,
[AdviserTypeId] [int] NOT NULL,
[AdviserName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EmployerName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AdviserPosition] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AddressLine1] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PostCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Telephone] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Fax] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Email] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviserAu_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviserAudit] ADD CONSTRAINT [PK_TAdviserAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAdviserAudit_AdviserId_ConcurrencyId] ON [dbo].[TAdviserAudit] ([AdviserId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
