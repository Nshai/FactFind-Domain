CREATE TABLE [dbo].[TFeeModelHidden]
(
[FeeModelHiddenId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFeeModelHidden] ADD CONSTRAINT [PK_TFeeModelHidden] PRIMARY KEY CLUSTERED  ([FeeModelHiddenId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelHidden_GroupId] ON [dbo].[TFeeModelHidden] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelHidden_TenantId] ON [dbo].[TFeeModelHidden] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelHidden] ADD CONSTRAINT [FK_TFeeModelHidden_TFeeModel] FOREIGN KEY ([FeeModelId]) REFERENCES [dbo].[TFeeModel] ([FeeModelId]) ON DELETE CASCADE
GO
