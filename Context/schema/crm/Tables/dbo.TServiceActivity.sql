CREATE TABLE [dbo].[TServiceActivity]
(
    [Id] [int] NOT NULL IDENTITY(1,1),
    [Name] [varchar] (100) NULL,
    [CRMContactId] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [DueDate] [datetime] NOT NULL,
    [EndDate] [datetime] NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ChangedDate] [datetime] NULL,
    [TenantId] [int] NOT NUll,
    [TypeSystemName] VARCHAR(50) NULL,
    [ActivityStatus] VARCHAR(50) NULL,
    [StateData] VARCHAR(500) NULL

    CONSTRAINT [PK_TServiceActivityId] PRIMARY KEY CLUSTERED  ([Id])
)
GO
CREATE NONCLUSTERED INDEX [IDX_TServiceActivity_CrmContactId] ON [dbo].[TServiceActivity] ([CRMContactId])
GO