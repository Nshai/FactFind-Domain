CREATE TABLE dbo.TPersonalContact (
		[PersonalContactId] int IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalContactId PRIMARY KEY,
		[CRMContactId] int NOT NULL CONSTRAINT FK_CRMContactId FOREIGN KEY (CRMContactId) REFERENCES TCRMContact(CRMContactId),
		[IndigoClientId] int NOT NULL,
	); 