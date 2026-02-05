CREATE TABLE [dbo].[TPolicyExpectedCommissionExtended]
(
[PolicyExpectedCommissionExtendedId] [int] NOT NULL IDENTITY(1, 1),
[PolicyExpectedCommissionId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
create index IX_TPolicyExpectedCommissionExtended_MigrationRef_IndigoCLientId on TPolicyExpectedCommissionExtended(MigrationRef,IndigoClientId) 
go 
