CREATE TABLE [dbo].[TPersonCitizenship]
(
[PersonId] [int] NOT NULL,
[CountryId] [int] NOT NULL ,
CONSTRAINT [FK_TPersonCitizenship_TPerson] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId]),
CONSTRAINT [FK_TPersonCitizenship_TRefCountry] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[TRefCountry] ([RefCountryId]),
CONSTRAINT [PK_TPersonCitizenship] PRIMARY KEY NONCLUSTERED ([PersonId], [CountryId])
); 