CREATE TABLE [dbo].[TEmployeeList]
(
[EmployeeListId] [int] NOT NULL IDENTITY(1, 1),
[RecordId] [int] NOT NULL,
[PractitionerUsername] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[Surname] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[Forename] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[DOB] [datetime] NOT NULL,
[NiNumber] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Department] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[GatewayId] [int] NOT NULL,
[DuplicateFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
