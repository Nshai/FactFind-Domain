CREATE TABLE [dbo].[TFeeModel]
(
[FeeModelId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[RefFeeModelStatusId] [int] NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TFeeModel_IsDefault] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[GroupId] [int] NULL,
[IsSystemDefined] [bit] NOT NULL CONSTRAINT [DF_TFeeModel_IsSystemDefined] DEFAULT ((0)),
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TFeeModel_IsPropagated] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TFeeModel_IsArchived] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFeeModel] ADD CONSTRAINT [PK_TFeeModel] PRIMARY KEY CLUSTERED  ([FeeModelId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModel_GroupId] ON [dbo].[TFeeModel] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModel_TenantId] ON [dbo].[TFeeModel] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModel] ADD CONSTRAINT [FK_TFeeModel_TRefFeeModelStatus] FOREIGN KEY ([RefFeeModelStatusId]) REFERENCES [dbo].[TRefFeeModelStatus] ([RefFeeModelStatusId])
GO
