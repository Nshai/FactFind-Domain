SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[nio_SpQuickSearchClientOnSdbGetColumnList]
	@TenantId bigint,
	@NameOne varchar (50) = '',
	@NameTwo varchar (50) = '',
	@LoggedInUserIsSuperUserOrSuperViewer bit,
	@_UserId bigint,
	@_TopN int = 0

AS 

SELECT
	0  AS 'ClientId',
	'' AS 'ClientName',
	'' AS 'AddressLine1',
	'' AS 'DOB',
	'' AS 'AdviserFullName',
	0  AS 'Relevance'
WHERE 1=2

GO
