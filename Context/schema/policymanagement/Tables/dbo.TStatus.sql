CREATE TABLE [dbo].[TStatus]
(
[StatusId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[OrigoStatusId] [int] NULL,
[IntelligentOfficeStatusType] [varchar] (50) NULL,
[PreComplianceCheck] [bit] NOT NULL CONSTRAINT [DF_TStatus_PreComplianceCheck] DEFAULT ((0)),
[PostComplianceCheck] [bit] NOT NULL CONSTRAINT [DF_TStatus_PostComplianceCheck] DEFAULT ((0)),
[SystemSubmitFg] [bit] NOT NULL CONSTRAINT [DF_TStatus_AutoMoveOnFg] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatus_ConcurrencyId] DEFAULT ((1)),
[IsPipelineStatus] [bit] NOT NULL CONSTRAINT [DF_TStatus_PipelineStatus] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TStatus] ADD CONSTRAINT [PK_TStatus] PRIMARY KEY CLUSTERED  ([StatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatus] ON [dbo].[TStatus] ([IndigoClientId], [IntelligentOfficeStatusType], [Name], [StatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TStatus_OrigoStatusId] ON [dbo].[TStatus] ([OrigoStatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatus_IOStatus] ON [dbo].[TStatus] ([StatusId], [IntelligentOfficeStatusType], [IndigoClientId]) Include (Name)
GO
ALTER TABLE [dbo].[TStatus] WITH CHECK ADD CONSTRAINT [FK_TStatus_OrigoStatusId_OrigoStatusId] FOREIGN KEY ([OrigoStatusId]) REFERENCES [dbo].[TOrigoStatus] ([OrigoStatusId])
GO
create index IX_TStatus_StatusId_Name_IntelligentOfficeStatusType_IndigoClientId on Tstatus (StatusId,Name,IntelligentOfficeStatusType,IndigoClientId) include (OrigoStatusId,PreComplianceCheck,PostComplianceCheck,SystemSubmitFg,ConcurrencyId,IsPipelineStatus)
GO
