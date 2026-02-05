CREATE TABLE [dbo].[TUser]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64)  NOT NULL,
[Password] [varchar] (max)  NULL,
[PasswordSalt] [varchar] (max)  NULL,
[PasswordHistory] [varchar] (512)  NULL CONSTRAINT [DF_TUser_PasswordHistory] DEFAULT (''),
[Email] [varchar] (128)  NOT NULL,
[Telephone] [varchar] (16)  NULL,
[Status] [varchar] (50)  NOT NULL,
[GroupId] [int] NOT NULL,
[SyncPassword] [bit] NULL CONSTRAINT [DF_TUser_SyncPassword] DEFAULT ((0)),
[ExpirePasswordOn] [datetime] NULL,
[SuperUser] [bit] NOT NULL CONSTRAINT [DF_TUser_SuperUser] DEFAULT ((0)),
[SuperViewer] [bit] NOT NULL CONSTRAINT [DF_TUser_SuperViewer] DEFAULT ((0)),
[FinancialPlanningAccess] [bit] NOT NULL CONSTRAINT [DF_TUser_FinancialPlanningAccess] DEFAULT ((0)),
[FailedAccessAttempts] [tinyint] NOT NULL CONSTRAINT [DF_TUser_FailedAccessAttempts] DEFAULT ((0)),
[WelcomePage] [varchar] (64)  NOT NULL CONSTRAINT [DF_TUser_WelcomePage] DEFAULT ('goto,news,links'),
[Reference] [varchar] (64)  NULL,
[CRMContactId] [int] NULL,
[SearchData] [text]  NULL,
[RecentData] [text]  NULL,
[RecentWork] [text]  NULL,
[IndigoClientId] [int] NULL,
[SupportUserFg] [bit] NOT NULL CONSTRAINT [DF_TUser_SupportUserFg] DEFAULT ((0)),
[ActiveRole] [int] NULL,
[CanLogCases] [bit] NOT NULL CONSTRAINT [DF_TUser_CanLogCases] DEFAULT ((0)),
[RefUserTypeId] [int] NOT NULL CONSTRAINT [DF_TUser_RefUserTypeId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TUser_Guid] DEFAULT ([dbo].[NewCombGuid]()),
[IsMortgageBenchEnabled] [bit] NOT NULL CONSTRAINT [DF_TUser_IsMortgageBenchEnabled] DEFAULT ((0)),
[IsMIReportDesigner] [bit] NOT NULL CONSTRAINT [DF_TUser_IsMIReportDesigner] DEFAULT ((0)),
[IsMIReportManager] [bit] NOT NULL CONSTRAINT [DF_TUser_IsMIReportManager] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUser_ConcurrencyId] DEFAULT ((1)),
[LockedOutUntilDateTime] [datetime] NULL,
[EmailConfirmed] [bit] NOT NULL CONSTRAINT [DF_TUser_EmailConfirmed] DEFAULT ((1)),
[IsOutLookExtensionUser] [bit] NOT NULL CONSTRAINT [DF_TUser_IsOutLookExtensionUser] DEFAULT ((0)),
[AdvisaCentaCoreAccess] [bit] NOT NULL CONSTRAINT [DF_TUser_AdvisaCentaCoreAccess] DEFAULT ((0)),
[AdvisaCentaCorePlusAccess] [bit] NOT NULL CONSTRAINT [DF_TUser_AdvisaCentaCorePlusAccess] DEFAULT ((0)),
[PensionFreedomPlanner] [bit] NOT NULL CONSTRAINT [DF_TUser_PensionFreedomPlanner] DEFAULT ((0)),
[FeAnalyticsAccess] [bit] NOT NULL CONSTRAINT [DF_TUser_FEAnalyticsAccess] DEFAULT ((0)),
[IsVoyantUser] [bit] NOT NULL CONSTRAINT [DF_TUser_IsVoyantUser] DEFAULT ((0)),
[AdvisaCentaFullAccess] [bit] NOT NULL CONSTRAINT [DF_TUSER_AdvisaCentaFullAccess] DEFAULT ((0)),
[AdvisaCentaFullAccessPlusLifetimePlanner] [bit] NOT NULL CONSTRAINT [DF_TUSER_AdvisaCentaFullAccessPlusLifetimePlanner] DEFAULT ((0)),
[SolutionBuilderAccess] [bit] NOT NULL CONSTRAINT [DF_TUSER_SolutionBuilderAccess] DEFAULT ((0)),
[Timezone] [varchar] (100) NOT NULL,
[Is2faEnabled] [bit] NOT NULL CONSTRAINT [DF_TUser_Is2faEnabled] DEFAULT((0)),
[HasGroupDataAccess] [bit] NOT NULL CONSTRAINT [DF_TUser_HasGroupDataAccess] DEFAULT((0)),
[LastLoginAt] [datetime] NULL,
[Qualification] [varchar](100) NULL,
[JobTitle] [varchar](100) NULL,
[Signature] [varchar](250) NULL
)
GO
ALTER TABLE [dbo].[TUser] ADD CONSTRAINT [PK_TUser] PRIMARY KEY CLUSTERED  ([UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_ActiveRole] ON [dbo].[TUser] ([ActiveRole])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_CrmContactId] ON [dbo].[TUser] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_GroupIdASC] ON [dbo].[TUser] ([GroupId], [IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_Guid] ON [dbo].[TUser] ([Guid])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IdentifierASC_UserIdASC] ON [dbo].[TUser] ([Identifier], [UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientIdASC] ON [dbo].[TUser] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientId_CRMContactId_1] ON [dbo].[TUser] ([IndigoClientId], [CRMContactId]) include (Identifier,GroupId)
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientId_RefUserTypeId] ON [dbo].[TUser] ([IndigoClientId], [RefUserTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientId_UserId] ON [dbo].[TUser] ([IndigoClientId], [UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientId_Status] ON [dbo].[TUser] ([IndigoClientId], [Status])  Include (SuperUser, SuperViewer, RefUserTypeId, [ActiveRole])
GO
GO
CREATE NONCLUSTERED INDEX [INCL_TUser_UserId] ON [dbo].[TUser] ([SupportUserFg]) INCLUDE ([UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_LastLoginAt] ON [dbo].[TUser] ([LastLoginAt])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_IndigoClientId_LastLoginAt] ON [dbo].[TUser] ([IndigoClientId], [LastLoginAt])
GO
ALTER TABLE [dbo].[TUser] WITH CHECK ADD CONSTRAINT [FK_TGroup_GroupId_GroupId] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[TGroup] ([GroupId])
GO
ALTER TABLE [dbo].[TUser] WITH CHECK ADD CONSTRAINT [FK_TUser_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TUser] ADD CONSTRAINT [FK_TUser_RefUserTypeId_TRefUserType] FOREIGN KEY ([RefUserTypeId]) REFERENCES [dbo].[TRefUserType] ([RefUserTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TUser_GroupId_IndigoClientID] ON [dbo].[TUser] ([GroupId], [IndigoClientId]) include (Identifier,Reference,CRMContactId)
GO
