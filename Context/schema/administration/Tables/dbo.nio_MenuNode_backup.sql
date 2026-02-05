CREATE TABLE [dbo].[nio_MenuNode_backup]
(
[MenuNodeID] [int] NOT NULL IDENTITY(1, 1),
[TenantID] [int] NOT NULL,
[Text] [nvarchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Controller] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Action] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ParentMenuNodeID] [int] NULL,
[DisplayOrder] [int] NOT NULL,
[LioURL] [varchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
