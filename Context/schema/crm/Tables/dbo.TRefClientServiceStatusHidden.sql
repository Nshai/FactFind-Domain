CREATE TABLE [dbo].[TRefClientServiceStatusHidden]
(
[RefClientServiceStatusHiddenId] [int] NOT NULL IDENTITY(1, 1),
[RefServiceStatusId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefClientServiceStatusHidden] ADD CONSTRAINT [PK_TRefClientServiceStatusHidden] PRIMARY KEY CLUSTERED  ([RefClientServiceStatusHiddenId])
GO
ALTER TABLE [dbo].[TRefClientServiceStatusHidden] ADD CONSTRAINT [FK_TRefClientServiceStatusHidden_TRefServiceStatus] FOREIGN KEY ([RefServiceStatusId]) REFERENCES [dbo].[TRefServiceStatus] ([RefServiceStatusId])
GO
