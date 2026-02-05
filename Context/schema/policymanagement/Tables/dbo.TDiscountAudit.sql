CREATE TABLE [dbo].[TDiscountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [decimal] (15, 2) NULL,
[Percentage] [decimal] (5, 2) NULL,
[Reason] [nvarchar] (800) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[DiscountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NULL,
[IsRange] [bit] NULL,
[MinAmount] [decimal] (10, 2)  NULL,
[MaxAmount] [decimal] (10, 2)  NULL,
[MinPercentage] [decimal] (5, 2) NULL,
[MaxPercentage] [decimal] (5, 2) NULL
)
GO
ALTER TABLE [dbo].[TDiscountAudit] ADD CONSTRAINT [PK_TDiscountAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
