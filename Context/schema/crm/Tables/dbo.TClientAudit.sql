CREATE TABLE [dbo].[TClientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefClientStatusId] [int] NULL,
[PersonId] [int] NULL,
[CorporateId] [int] NULL,
[TrustId] [int] NULL,
[AdvisorId] [int] NULL,
[RefSourceOfClientId] [int] NOT NULL,
[SourceValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[IndividualCorporateTrustFg] [tinyint] NULL,
[AddressFg] [tinyint] NULL,
[ContactsFg] [tinyint] NULL,
[RelationshipsFg] [tinyint] NULL,
[TasksFg] [tinyint] NULL,
[DiaryFg] [tinyint] NULL,
[HistoryFg] [tinyint] NULL,
[PlansFg] [tinyint] NULL,
[FeesFg] [tinyint] NULL,
[PaymentsFg] [tinyint] NULL,
[QuotesFg] [tinyint] NULL,
[PayawaysFg] [tinyint] NULL,
[SalesPlanFg] [tinyint] NULL,
[DocumentsFg] [tinyint] NULL,
[CustomFg] [tinyint] NULL,
[ExtendedFg] [tinyint] NULL,
[ArchiveFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[ClientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientAud_StampDateTime_1__55] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientAudit] ADD CONSTRAINT [PK_TClientAudit_2__55] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TClientAudit_ClientId_ConcurrencyId] ON [dbo].[TClientAudit] ([ClientId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
