CREATE TABLE [dbo].[TRefApplicationCustomHandler]
(
[RefApplicationCustomHandlerId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[HandlerPath] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefApplicationCustomHandler_AllowAccess] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationCustomHandler_ConcurrencyId] DEFAULT ((0)),
[IntegratedSystemConfigRole] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationCustomHandler] ADD CONSTRAINT [PK_TRefApplicationCustomHandler] PRIMARY KEY CLUSTERED  ([RefApplicationCustomHandlerId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TRefApplicationCustomHandler_RefApplicationId ON [dbo].[TRefApplicationCustomHandler] ([RefApplicationId]) INCLUDE ([RefApplicationCustomHandlerId])
GO