CREATE TABLE [dbo].[TBeneficiaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[CoporateId] [int] NOT NULL,
[TrustId] [int] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[BeneficiaryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBeneficia_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBeneficiaryAudit] ADD CONSTRAINT [PK_TBeneficiaryAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TBeneficiaryAudit_BeneficiaryId_ConcurrencyId] ON [dbo].[TBeneficiaryAudit] ([BeneficiaryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
