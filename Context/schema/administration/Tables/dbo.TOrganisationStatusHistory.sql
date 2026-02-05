CREATE TABLE [dbo].[TOrganisationStatusHistory]
(
[OrganisationStatusHistoryId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (50)  NOT NULL,
[ChangeDateTime] [datetime] NOT NULL CONSTRAINT [DF_TOrganisationStatusHistory_ChangeDateTime] DEFAULT (getdate()),
[ChangeUser] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrganisationStatusHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOrganisationStatusHistory] ADD CONSTRAINT [PK_TOrganisationStatusHistory] PRIMARY KEY CLUSTERED  ([OrganisationStatusHistoryId])
GO
ALTER TABLE [dbo].[TOrganisationStatusHistory] WITH CHECK ADD CONSTRAINT [FK_TOrganisationStatusHistory_ChangeUser_UserId] FOREIGN KEY ([ChangeUser]) REFERENCES [dbo].[TUser] ([UserId])
GO
ALTER TABLE [dbo].[TOrganisationStatusHistory] WITH CHECK ADD CONSTRAINT [FK_TOrganisationStatusHistory_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
