CREATE TABLE [dbo].[TSplitBasicAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[PractitionerId] [int] NULL,
[PractitionerCRMContactId] [int] NULL,
[BandingTemplateId] [int] NULL,
[GroupingId] [int] NULL,
[GroupCRMContactId] [int] NULL,
[SplitPercent] [decimal] (10, 2) NOT NULL,
[PaymentEntityId] [int] NOT NULL,
[PractitionerFg] [bit] NOT NULL CONSTRAINT [DF_TSplitBasi_PractitionerFg_2__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSplitBasi_ConcurrencyId_1__56] DEFAULT ((1)),
[SplitBasicId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSplitBasi_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSplitBasicAudit] ADD CONSTRAINT [PK_TSplitBasicAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSplitBasicAudit_SplitBasicId_ConcurrencyId] ON [dbo].[TSplitBasicAudit] ([SplitBasicId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
