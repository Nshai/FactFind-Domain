CREATE TABLE [dbo].[TSplitBasicHistAudit_Not_Used]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractCRMContactId] [int] NOT NULL,
[BasicSplitXML] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[DateSaved] [datetime] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[SplitBasicHistId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSplitBasi_StampDateTime_1__53] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSplitBasicHistAudit_Not_Used] ADD CONSTRAINT [PK_TSplitBasicHistAudit_2__53] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSplitBasicHistAudit_SplitBasicHistId_ConcurrencyId] ON [dbo].[TSplitBasicHistAudit_Not_Used] ([SplitBasicHistId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
