CREATE TABLE [dbo].[TLightHouse_Groups]
(
[GroupId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupingId] [int] NOT NULL,
[ParentId] [int] NULL,
[CRMContactId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[LegalEntity] [bit] NOT NULL,
[GroupImageLocation] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[AcknowledgementsLocation] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[FinancialYearEnd] [datetime] NULL,
[ApplyFactFindBranding] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
