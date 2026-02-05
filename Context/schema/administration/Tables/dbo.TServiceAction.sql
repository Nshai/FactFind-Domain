CREATE TABLE [dbo].[TServiceAction]
(
[ServiceActionId] [int] NOT NULL IDENTITY(1, 1),
[ServiceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ServiceAction] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ServiceActionSubType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NoSecurityContextRequired] [bit] NOT NULL CONSTRAINT [DF_TServiceAction_NoSecurityContextRequired] DEFAULT ((0)),
[AccessForAllLoggedOnUsers] [bit] NOT NULL CONSTRAINT [DF_TServiceAction_AccessForAllLoggedOnUsers] DEFAULT ((0)),
[MinimiumAccessRequired] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceAction_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TServiceAction] ADD CONSTRAINT [PK_TServiceAction] PRIMARY KEY CLUSTERED  ([ServiceActionId])
GO
