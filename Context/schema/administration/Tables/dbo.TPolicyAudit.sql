CREATE TABLE [dbo].[TPolicyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NOT NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TPolicyAud_RightMask_5__56] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TPolicyAud_AdvancedMask_1__56] DEFAULT ((0)),
[RoleId] [int] NOT NULL,
[Propogate] [bit] NOT NULL CONSTRAINT [DF_TPolicyAud_Propogate_4__56] DEFAULT ((1)),
[Applied] [varchar] (16) NOT NULL CONSTRAINT [DF_TPolicyAud_Applied_2__56] DEFAULT ('no'),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyAud_ConcurrencyId_3__56] DEFAULT ((1)),
[PolicyId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyAud_StampDateTime_6__56] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[Inherit] [bit] NOT NULL CONSTRAINT [DF_TPolicyAud_Inherit] DEFAULT ((0)),
[UserId] INT NULL,
[GroupId] INT NULL
)
GO
ALTER TABLE [dbo].[TPolicyAudit] ADD CONSTRAINT [PK_TPolicyAudit_7__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyAudit_PolicyId_ConcurrencyId] ON [dbo].[TPolicyAudit] ([PolicyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
