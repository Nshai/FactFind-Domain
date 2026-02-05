CREATE TABLE [dbo].[TRefServiceStatus]
(
[RefServiceStatusId] [int] NOT NULL IDENTITY(1, 1),
[ServiceStatusName] [varchar] (50) NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatus_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefServiceStatus_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatus_IsPropagated] DEFAULT ((1)),
[ReportFrequency] [int] NULL,
[ReportStartDateType] [smallint] NULL,
[ReportStartDate] [datetime] NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatus_IsDefault] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefServiceStatus] ADD CONSTRAINT [PK_TRefServiceStatus] PRIMARY KEY CLUSTERED  ([RefServiceStatusId])
GO
CREATE NONCLUSTERED INDEX IX_TRefServiceStatus_IndigoClientId_IsArchived ON [dbo].[TRefServiceStatus] ([IndigoClientId],[IsArchived])
GO