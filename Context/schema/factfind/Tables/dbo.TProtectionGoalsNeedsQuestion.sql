CREATE TABLE [dbo].[TProtectionGoalsNeedsQuestion]
(
[ProtectionGoalsNeedsQuestionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[IsSmoker] [bit] NULL,
[HaveSmoked] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__36870511] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProtectionGoalsNeedsQuestion] ADD CONSTRAINT [PK_TProtectionGoalsNeedsQuestion] PRIMARY KEY NONCLUSTERED  ([ProtectionGoalsNeedsQuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionGoalsNeedsQuestion_CRMContactId] ON [dbo].[TProtectionGoalsNeedsQuestion] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TProtectionGoalsNeedsQuestion_CRMContactId] ON [dbo].[TProtectionGoalsNeedsQuestion] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
