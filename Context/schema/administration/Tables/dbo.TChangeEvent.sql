CREATE TABLE [dbo].[TChangeEvent]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[AppliedDateTime] [datetime] NULL,
[EventName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ContextData] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ErrorMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[StackTrace] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Priority] [tinyint] NOT NULL CONSTRAINT [DF_TChangeEvent_Priority] DEFAULT(1),
[IsSnsEvent] [bit] NULL
)
GO
ALTER TABLE [dbo].[TChangeEvent] ADD CONSTRAINT [PK_TChangeEvent] PRIMARY KEY CLUSTERED  ([Id])
GO
CREATE NONCLUSTERED INDEX [IX_TChangeEvent_Id_AppliedDateTime] ON [dbo].[TChangeEvent] ([AppliedDateTime],[Id])
GO