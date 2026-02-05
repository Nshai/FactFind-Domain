CREATE TABLE [dbo].[TLeadImportResult]
(
[LeadImportResultId] [int] NOT NULL IDENTITY(1, 1),
[LeadImportId] [int] NOT NULL,
[LineNumber] [int] NOT NULL,
[Descriptor] [varchar] (1000)  NULL,
[Result] [varchar] (16)  NULL,
[LeadId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadImportResult_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadImportResult] ADD CONSTRAINT [PK_TLeadImportResult_LeadImportResultId] PRIMARY KEY NONCLUSTERED  ([LeadImportResultId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLeadImportResult_LeadId] ON [dbo].[TLeadImportResult] ([LeadId]) INCLUDE ([ConcurrencyId], [Descriptor], [LeadImportId], [LeadImportResultId], [LineNumber], [Result])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadImportResult_LeadImportIdASC] ON [dbo].[TLeadImportResult] ([LeadImportId])
GO
ALTER TABLE [dbo].[TLeadImportResult] WITH CHECK ADD CONSTRAINT [FK_TLeadImportResult_TLead] FOREIGN KEY ([LeadId]) REFERENCES [dbo].[TLead] ([LeadId])
GO
ALTER TABLE [dbo].[TLeadImportResult] WITH CHECK ADD CONSTRAINT [FK_TLeadImportResult_TLeadImport] FOREIGN KEY ([LeadImportId]) REFERENCES [dbo].[TLeadImport] ([LeadImportId])
GO
