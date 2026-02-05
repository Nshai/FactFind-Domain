CREATE TABLE [dbo].[TValSchedulePolicy]
(
[ValSchedulePolicyId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ClientCRMContactId] [int] NOT NULL,
[UserCredentialOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalCRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValSchedulePolicy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValSchedulePolicy] ADD CONSTRAINT [PK_TValSchedulePolicy] PRIMARY KEY NONCLUSTERED  ([ValSchedulePolicyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TValSchedulePolicy_ValScheduleId_PolicyBusinessId] ON [dbo].[TValSchedulePolicy] ([ValScheduleId], [PolicyBusinessId]) WITH (FILLFACTOR=80)
GO
