CREATE TABLE [dbo].[TIndigoClientExtendedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[FinancialYearStartMonth] [tinyint] NULL,
[Website] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientExtendedAudit_ConcurrencyId] DEFAULT ((1)),
[IndigoClientExtendedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientExtendedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SftpUserName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GcdContractFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GcdPersonFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FpfDocumentFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LogEventsTo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TIndigoClientExtendedAudit_LogEventsTo] DEFAULT ('None'),
[DocumentGeneratorVersion] [tinyint] NULL CONSTRAINT [DF_TIndigoClientExtendedAudit_DocumentGeneratorVersion] DEFAULT ((1)),
[TerminationOn] [date] NULL,
[StatusReason] [varchar] (512) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientExtendedAudit] ADD CONSTRAINT [PK_TIndigoClientExtendedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientExtendedAudit_IndigoClientExtendedId_ConcurrencyId] ON [dbo].[TIndigoClientExtendedAudit] ([IndigoClientExtendedId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
