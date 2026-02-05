CREATE TABLE [dbo].[TGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (64) NOT NULL,
[GroupingId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[ParentId] [int] NULL,
[LegalEntity] [bit] NOT NULL CONSTRAINT [DF_TGroupAudit_LegalEntity] DEFAULT ((0)),
[GroupImageLocation] [varchar] (500) NULL,
[AcknowledgementsLocation] [varchar] (500) NULL,
[FinancialYearEnd] [datetime] NULL,
[ApplyFactFindBranding] [bit] NOT NULL CONSTRAINT [DF_TGroupAudit_ApplyFactFindBranding] DEFAULT ((1)),
[VatRegNbr] [varchar] (50) NULL,
[FSARegNbr] [varchar] (24) NULL,
[AuthorisationText] [varchar] (500) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupAudit_ConcurrencyId] DEFAULT ((1)),
[IsFSAPassport] [bit] NULL,
[FRNNumber] [varchar] (10) NULL,
[GroupId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[DocumentFileReference] [varchar] (1000) NULL,
[MigrationRef] [varchar] (255) NULL,
[AdminEmail] [varchar] (128) NULL,
[DefaultClientGroupId] [int] NULL,
[ExternalRef] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TGroupAudit] ADD CONSTRAINT [PK_TGroupAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
