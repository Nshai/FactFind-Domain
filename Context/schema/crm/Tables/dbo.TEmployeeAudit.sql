CREATE TABLE [dbo].[TEmployeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OccupationId] [int] NOT NULL,
[EmployerCRMContactId] [int] NULL,
[RefNatureOfEmploymentId] [int] NULL,
[GrossSalary] [money] NULL,
[MonthOfReview] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[hasGuaranteedOT] [bit] NULL,
[GuaranteedRecieved] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[hasBonus] [bit] NULL,
[IsBonusGuaranteed] [bit] NULL,
[BonusReceived] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[hasCommission] [bit] NULL,
[IsCommissionGuarenteed] [bit] NULL,
[CommissionReceived] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[EmployeeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmployeeA_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmployeeAudit] ADD CONSTRAINT [PK_TEmployeeAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEmployeeAudit_EmployeeId_ConcurrencyId] ON [dbo].[TEmployeeAudit] ([EmployeeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
