CREATE TABLE [dbo].[TServiceActivityAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [Name] [varchar] (100) NULL,
    [CRMContactId] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [DueDate] [datetime] NOT NULL,
    [EndDate] [datetime] NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ChangedDate] [datetime] NULL,
    [TenantId] [int] NOT NULL,
    [Id] [int] NOT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TServiceActivityAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL,
    [TypeSystemName] VARCHAR(50) NULL,
    [ActivityStatus] VARCHAR(50) NULL,
    [StateData] VARCHAR(500) NULL
)

GO
ALTER TABLE [dbo].[TServiceActivityAudit] ADD CONSTRAINT PK_TServiceActivityAudit PRIMARY KEY CLUSTERED ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TServiceActivityAudit_CrmContactId] ON [dbo].[TServiceActivityAudit] ([CRMContactId])
GO