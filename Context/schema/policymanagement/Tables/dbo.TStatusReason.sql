CREATE TABLE [dbo].[TStatusReason]
(
[StatusReasonId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[StatusId] [int] NOT NULL,
[OrigoStatusId] [int] NULL,
[IntelligentOfficeStatusType] [varchar] (50) NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusReason_ConcurrencyId] DEFAULT ((1)),
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF_TStatusReason_RefLicenceTypeId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TStatusReason_IsArchived] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TStatusReason] ADD CONSTRAINT [PK_TStatusReason] PRIMARY KEY CLUSTERED  ([StatusReasonId])
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusReason_StatusId] ON [dbo].[TStatusReason] ([StatusId])
GO
ALTER TABLE [dbo].[TStatusReason] WITH CHECK ADD CONSTRAINT [FK_TStatusReason_StatusId_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[TStatus] ([StatusId])
GO
