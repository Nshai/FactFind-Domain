CREATE TABLE [dbo].[TLeadNote]
(
[LeadNoteId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[LeadId] [int] NOT NULL,
[Text] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [int] NOT NULL,
[UpdatedOn] [datetime] NOT NULL,
[UpdatedBy] [int] NOT NULL,
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_TLeadNote_IsSystem] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadNote_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TLeadNote] ADD CONSTRAINT [PK_TLeadNote] PRIMARY KEY CLUSTERED  ([LeadNoteId])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadNote_LeadId_TenantId] ON [dbo].[TLeadNote] ([LeadId], [TenantId])
GO
ALTER TABLE [dbo].[TLeadNote] ADD CONSTRAINT [FK_TLeadNote_TLead] FOREIGN KEY ([LeadId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
