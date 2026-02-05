CREATE TABLE [dbo].[TPasswordPolicy]
(
[PasswordPolicyId] [int] NOT NULL IDENTITY(1, 1),
[Expires] [bit] NOT NULL CONSTRAINT [DF_TPasswordPolicy_Expires] DEFAULT ((1)),
[ExpiryDays] [int] NULL,
[UniquePasswords] [tinyint] NULL,
[MaxFailedLogins] [tinyint] NULL,
[ChangePasswordOnFirstUse] [bit] NULL CONSTRAINT [DF_TPasswordPolicy_ChangePasswordOnFirstUse] DEFAULT ((0)),
[AutoPasswordGeneration] [bit] NULL CONSTRAINT [DF_TPasswordPolicy_AutoPasswordGeneration] DEFAULT ((1)),
[AllowExpireAllPasswords] [bit] NULL CONSTRAINT [DF_TPasswordPolicy_AllowExpireAllPasswords] DEFAULT ((0)),
[AllowAutoUserNameGeneration] [bit] NULL CONSTRAINT [DF_TPasswordPolicy_AllowAutoUserNameGeneration] DEFAULT ((1)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicy_ConcurrencyId] DEFAULT ((1)),
[LockoutPeriodMinutes] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicy_LockoutPeriodMinutes] DEFAULT ((5)),
[NumberOfMonthsBeforePasswordReuse] [int] NOT NULL CONSTRAINT [DF_TPasswordPolicy_NumberOfMonthsBeforePasswordReuse] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TPasswordPolicy] ADD CONSTRAINT [PK_TPasswordPolicy] PRIMARY KEY CLUSTERED  ([PasswordPolicyId]) WITH (FILLFACTOR=80)
GO
