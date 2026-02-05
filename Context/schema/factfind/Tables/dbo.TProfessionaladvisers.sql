CREATE TABLE [dbo].[TProfessionaladvisers]
(
[ProfessionaladvisersId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ContactType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Value] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine1] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Postcode] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Country] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProfessi__Concu__2F1AED73] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProfessionaladvisers] ADD CONSTRAINT [PK_TProfessionalAdvisers] PRIMARY KEY CLUSTERED  ([ProfessionaladvisersId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProfessionaladvisers_CRMContactId] ON [dbo].[TProfessionaladvisers] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
