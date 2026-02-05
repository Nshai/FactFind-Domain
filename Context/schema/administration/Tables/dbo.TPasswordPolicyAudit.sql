CREATE TABLE [dbo].[TPasswordPolicyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Expires] [bit] NOT NULL CONSTRAINT [DF_TPasswordPolicyAudit_Expires] DEFAULT ((1)),
[ExpiryDays] [int] NULL,
[UniquePasswords] [tinyint] NULL,
[MaxFailedLogins] [tinyint] NULL,
[ChangePasswordOnFirstUse] [bit] NULL CONSTRAINT [DF_TPasswordPolicyAudit_ChangePasswordOnFirstUse] DEFAULT ((0)),
[AutoPasswordGeneration] [bit] NULL CONSTRAINT [DF_TPasswordPolicyAudit_AutoPasswordGeneration] DEFAULT ((1)),
[AllowExpireAllPasswords] [bit] NULL CONSTRAINT [DF_TPasswordPolicyAudit_AllowExpireAllPasswords] DEFAULT ((0)),
[AllowAutoUserNameGeneration] [bit] NULL CONSTRAINT [DF_TPasswordPolicyAudit_AllowAutoUserNameGeneration] DEFAULT ((1)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicyAudit_ConcurrencyId] DEFAULT ((1)),
[PasswordPolicyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPasswordPolicyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LockoutPeriodMinutes] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicyAudit_LockoutPeriodMinutes] DEFAULT ((5)),
[NumberOfMonthsBeforePasswordReuse] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicyAudit_NumberOfMonthsBeforePasswordReuse] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TPasswordPolicyAudit] ADD CONSTRAINT [PK_TPasswordPolicyAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
