CREATE TABLE [dbo].[TValScheduleDump]
(
[ValScheduleDumpId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleId] [int] NULL,
[IndigoClientId] [int] NULL,
[RefProdProviderId] [int] NULL,
[ClientCRMContactId] [int] NULL,
[PortalCRMContactId] [int] NULL,
[UserId] [int] NULL,
[ValScheduleScratchId] [int] NULL,
[ValScheduleItemId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[TimeStamp] [datetime] NULL,
[AcquiredBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AcquiredAt] [datetime] NULL,
[SubmitSequenceByProvider] [int] NULL,
[SubmitAtOrAfter] [datetime] NULL
)
GO
