CREATE TABLE [dbo].[TAllocatedThemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ThemeId] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__TAllocate__IsAct__168A97FE] DEFAULT ((0)),
[AllocatedThemeId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TAllocate__Stamp__177EBC37] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
