CREATE TABLE [dbo].[TPostCodeAllocationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllocationTypeId] [int] NOT NULL,
[MaxDistance] [int] NULL,
[SecondaryAllocationTypeId] [int] NULL,
[CanAssignPostCodeMoreThanOne] [bit] NULL,
[CanAssignAdviserMoreThanOne] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAllocationAudit_ConcurrencyId] DEFAULT ((1)),
[PostCodeAllocationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPostCodeAllocationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationAudit] ADD CONSTRAINT [PK_TPostCodeAllocationAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
