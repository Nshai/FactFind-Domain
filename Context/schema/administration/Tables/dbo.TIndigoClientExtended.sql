CREATE TABLE [dbo].[TIndigoClientExtended]
(
[IndigoClientExtendedId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[FinancialYearStartMonth] [tinyint] NOT NULL CONSTRAINT [DF_TIndigoClientExtended_FinancialYearStartMonth] DEFAULT ((1)),
[Website] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientExtended_ConcurrencyId] DEFAULT ((1)),
[SftpUserName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GcdContractFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GcdPersonFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FpfDocumentFileFormat] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LogEventsTo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF__TIndigoCl__LogEv__57934319] DEFAULT ('None'),
[DocumentGeneratorVersion] [tinyint] NULL CONSTRAINT [DF_TIndigoClientExtended_DocumentGeneratorVersion] DEFAULT ((1)),
[TerminationOn] [date] NULL,
[StatusReason] [varchar] (512) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientExtended] ADD CONSTRAINT [PK_TIndigoClientExtended] PRIMARY KEY NONCLUSTERED  ([IndigoClientExtendedId])
GO
ALTER TABLE [dbo].[TIndigoClientExtended] ADD CONSTRAINT [FK_TIndigoClientExtended_IndigoClientId_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX IX_TIndigoClientExtended_DocumentGeneratorVersion ON [dbo].[TIndigoClientExtended] ([DocumentGeneratorVersion]) INCLUDE ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX IX_TIndigoClientExtended_IndigoClientId_DocumentGeneratorVersion ON [dbo].[TIndigoClientExtended] ([IndigoClientId],[DocumentGeneratorVersion])
GO
