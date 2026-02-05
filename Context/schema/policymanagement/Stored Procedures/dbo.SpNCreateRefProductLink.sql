SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateRefProductLink]
	@StampUser varchar (255),
	@ApplicationLinkId bigint = NULL, 
	@RefProductTypeId bigint, 
	@ProductGroupData varchar(255)  = NULL, 
	@ProductTypeData varchar(255)  = NULL, 
	@IsArchived bit = 0	
AS


DECLARE @RefProductLinkId bigint, @Result int
			
	
INSERT INTO TRefProductLink
(ApplicationLinkId, RefProductTypeId, ProductGroupData, ProductTypeData, IsArchived, ConcurrencyId)
VALUES(@ApplicationLinkId, @RefProductTypeId, @ProductGroupData, @ProductTypeData, @IsArchived, 1)

SELECT @RefProductLinkId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditRefProductLink @StampUser, @RefProductLinkId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveRefProductLinkByRefProductLinkId @RefProductLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
