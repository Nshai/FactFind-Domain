CREATE TABLE [dbo].[TAdviser]
(
[AdviserId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[ClientCRMContactId] [int] NOT NULL,
[AdviserTypeId] [int] NOT NULL,
[AdviserName] [varchar] (255)  NOT NULL,
[EmployerName] [varchar] (255)  NULL,
[AdviserPosition] [varchar] (100)  NULL,
[AddressLine1] [varchar] (100)  NULL,
[AddressLine2] [varchar] (100)  NULL,
[AddressLine3] [varchar] (100)  NULL,
[AddressLine4] [varchar] (100)  NULL,
[PostCode] [varchar] (20)  NULL,
[Telephone] [varchar] (30)  NULL,
[Fax] [varchar] (30)  NULL,
[Email] [varchar] (50)  NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviser_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviser] ADD CONSTRAINT [PK_TAdviser] PRIMARY KEY NONCLUSTERED  ([AdviserId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviser_ClientCRMContactId] ON [dbo].[TAdviser] ([ClientCRMContactId])
GO
ALTER TABLE [dbo].[TAdviser] WITH CHECK ADD CONSTRAINT [FK_TAdviser_ClientCRMContactId_CRMContactId] FOREIGN KEY ([ClientCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
