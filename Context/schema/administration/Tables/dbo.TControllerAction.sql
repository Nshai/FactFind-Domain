CREATE TABLE [dbo].[TControllerAction]
(
[ControllerActionId] [int] NOT NULL IDENTITY(1, 1),
[ControllerName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ControllerAction] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Text] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[URL] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NoSecurityContextRequired] [bit] NOT NULL CONSTRAINT [DF_TControllerAction_NoSecurityContextRequired] DEFAULT ((0)),
[AccessForAllLoggedOnUsers] [bit] NOT NULL CONSTRAINT [DF_TControllerAction_AccessForAllLoggedOnUsers] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TControllerAction_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TControllerAction] ADD CONSTRAINT [PK_TControllerAction] PRIMARY KEY CLUSTERED  ([ControllerActionId])
GO
