CREATE TABLE [dbo].[TIntroducerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[AgreementDate] [datetime] NULL,
[RefIntroducerTypeId] [int] NOT NULL,
[PractitionerId] [int] NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TIntroducerAudit_ArchiveFG] DEFAULT ((0)),
[Identifier] [varchar] (50) NULL,
[UniqueIdentifier] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerAudit_ConcurrencyId] DEFAULT ((1)),
[IntroducerId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntroducerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TIntroducerAudit] ADD CONSTRAINT [PK_TIntroducerAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TIntroducerAudit_IntroducerId_ConcurrencyId] ON [dbo].[TIntroducerAudit] ([IntroducerId], [ConcurrencyId])
GO
