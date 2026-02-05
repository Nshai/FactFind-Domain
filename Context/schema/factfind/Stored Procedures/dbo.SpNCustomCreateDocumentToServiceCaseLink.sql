SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateDocumentToServiceCaseLink]
	@StampUser varchar(255),
	@DocumentId bigint,
	@ServiceCaseId bigint
AS
DECLARE @Id bigint

-- Check that binder information is valid
IF @ServiceCaseId = 0
	RETURN;

-- See if link already exists
IF EXISTS (SELECT 1 FROM Documentmanagement..TDocumentToServiceCase WHERE DocumentId = @DocumentId AND ServiceCaseId = @ServiceCaseId)
	RETURN;
	
-- Create Link	
INSERT INTO Documentmanagement..TDocumentToServiceCase (ServiceCaseId, DocumentId, ConcurrencyId)
VALUES (@ServiceCaseId, @DocumentId, 1)

-- Audit
SET @Id = SCOPE_IDENTITY()
EXEC Documentmanagement..SpNAuditDocumentToServiceCase @StampUser, @Id, 'C'
GO
